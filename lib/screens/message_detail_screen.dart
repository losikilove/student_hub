import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/interview_card.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/chat_model.dart';
import 'package:student_hub/models/enums/enum_disable_flag.dart';
import 'package:student_hub/models/interview_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/interview_service.dart';
import 'package:student_hub/services/message_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/interview_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageDetailScreen extends StatefulWidget {
  final ChatModel chatModel;
  MessageDetailScreen({super.key, required this.chatModel});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final List<int> _existedInterview = [];
  final optionOfMinute = 2;
  final optionOfHour = 24;
  final socket = IO.io(
    ApiUtil.websocketUrl,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );
  List<ChatMessage> _message = <ChatMessage>[];
  final List<ChatUser> _typing = <ChatUser>[];
  late ChatUser _currentUser;
  late ChatUser _anotherUser;
  StreamController<void> _updateStreamController = StreamController<void>();
  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    _currentUser = ChatUser(
        id: userProvider.user!.userId.toString(),
        firstName: userProvider.user!.fullname);
    _anotherUser = ChatUser(
        id: widget.chatModel.idUser.toString(),
        firstName: widget.chatModel.name);

    getMessages();
    //Add authorization to header
    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer ${userProvider.token}',
    };
    //Add query param to url
    socket.io.options?['query'] = {'project_id': widget.chatModel.idProject};

    socket.connect();

    socket.onConnect((data) => {
          print('Connected'),
        });

    socket.onConnectError(
        (data) => print('Error connection: ${data.toString()}'));
    socket.onError((data) => print('Error connection: ${data.toString()}'));

    //Listen to channel receive message
    socket.on('RECEIVE_MESSAGE', (data) {
      if (data['notification']['interview'] == null &&
          data['notification']['senderId'] == widget.chatModel.idUser) {
        _message.insert(
          0,
          ChatMessage(
            user: _anotherUser,
            text: data['notification']['message']['content'],
            createdAt: DateTime.parse(data['notification']['createdAt']),
          ),
        );
        _updateStreamController.add(null);
      }
    });
    //listen to channel receive interview
    socket.on('RECEIVE_INTERVIEW', (data) {
      // receive the interview
      if (data['notification']['message']['interview'] != null &&
          !_existedInterview
              .contains(data['notification']['message']['interviewId']) &&
          data['notification']['senderId'] == widget.chatModel.idUser) {
        String meeting = data['notification']['message']['interview']
            ['meetingRoom']['meeting_room_id'];

        log('$meeting why?');
        _message.insert(
          0,
          ChatMessage(
            user: _anotherUser,
            createdAt: DateTime.parse(data['notification']['createdAt']),
            text: 'showInvitation',
            customProperties: {
              'interview': {
                'model': InterviewModel(
                  data['notification']['message']['interviewId'],
                  [_currentUser, _anotherUser],
                  data['notification']['message']['interview']['title'],
                  DateTime.parse(data['notification']['message']['interview']
                      ['startTime']),
                  TimeOfDay.fromDateTime(DateTime.parse(data['notification']
                      ['message']['interview']['startTime'])),
                  TimeOfDay.fromDateTime(DateTime.parse(
                      data['notification']['message']['interview']['endTime'])),
                  (data['notification']['message']['interview']
                              ['disableFlag'] ==
                          EnumDisableFlag.disable.value ||
                      InterviewUtil.isExpiredMeeting(
                        DateTime.parse(
                          data['notification']['message']['interview']
                              ['meetingRoom']['expired_at'],
                        ),
                      )),
                ),
                'meeting': meeting,
              }
            },
          ),
        );

        _existedInterview.add(data['notification']['message']['interviewId']);

        _updateStreamController.add(null);
        return;
      }

      // post the interview
      else if (data['notification']['message']['interview'] != null &&
          !_existedInterview
              .contains(data['notification']['message']['interviewId']) &&
          data['notification']['receiverId'] == widget.chatModel.idUser &&
          data['notification']['senderId'].toString() == _currentUser.id) {
        String meeting = data['notification']['message']['interview']
            ['meetingRoom']['meeting_room_id'];

        _message.insert(
          0,
          ChatMessage(
            user: _currentUser,
            createdAt: DateTime.parse(data['notification']['createdAt']),
            text: 'showInvitation',
            customProperties: {
              'interview': {
                'model': InterviewModel(
                  data['notification']['message']['interviewId'],
                  [_currentUser, _anotherUser],
                  data['notification']['message']['interview']['title'],
                  DateTime.parse(data['notification']['message']['interview']
                      ['startTime']),
                  TimeOfDay.fromDateTime(DateTime.parse(data['notification']
                      ['message']['interview']['startTime'])),
                  TimeOfDay.fromDateTime(DateTime.parse(
                      data['notification']['message']['interview']['endTime'])),
                  (data['notification']['message']['interview']
                              ['disableFlag'] ==
                          EnumDisableFlag.disable.value ||
                      InterviewUtil.isExpiredMeeting(
                        DateTime.parse(
                          data['notification']['message']['interview']
                              ['meetingRoom']['expired_at'],
                        ),
                      )),
                ),
                'meeting': meeting,
              }
            },
          ),
        );

        _existedInterview.add(data['notification']['message']['interviewId']);

        _updateStreamController.add(null);
        return;
      }
    });

    //Listen for error from socket
    socket.on("ERROR", (data) => print('Error: ${data}'));
  }

  // show the more actions bottom-sheet
  void onOpenedMoreAction() async {
    // open more actions bottom
    // which can cancel or create a meeting
    final isCreatedNewInterview = await showMoreActionsBottomSheet();

    // have no creating new Interview
    if (isCreatedNewInterview == null || isCreatedNewInterview == false) {
      return;
    }

    // show options Interview
    showInterviewBottomSheet();
  }

  Future<void> getMessages() async {
    final response = await MessageService.getMessageUser(
        context: context,
        projectID: widget.chatModel.idProject,
        userID: widget.chatModel.idUser);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for (var item in jsonData['result']) {
        try {
          if (item['interview'] == null) {
            var message = ChatMessage(
              user: ChatUser(
                id: item['sender']['id'].toString(),
                firstName: item['sender']['fullname'],
              ),
              text: item['content'],
              createdAt: DateTime.parse(item['createdAt']),
            );

            setState(() {
              _message.insert(0, message);
            });
          } else {
            ChatUser sender = ChatUser(
              id: item['sender']['id'].toString(),
              firstName: item['sender']['fullname'],
            );

            ChatUser receiver = ChatUser(
              id: item['receiver']['id'].toString(),
              firstName: item['receiver']['fullname'],
            );

            var interview = ChatMessage(
              user: sender,
              createdAt: DateTime.parse(item['createdAt']),
              text: 'showInvitation',
              customProperties: {
                'interview': {
                  'model': InterviewModel(
                    item['interview']['id'],
                    [sender, receiver],
                    item['interview']['title'],
                    DateTime.parse(item['interview']['startTime']),
                    TimeOfDay.fromDateTime(
                        DateTime.parse(item['interview']['startTime'])),
                    TimeOfDay.fromDateTime(
                        DateTime.parse(item['interview']['endTime'])),
                    (item['interview']['disableFlag'] ==
                            EnumDisableFlag.disable.value ||
                        InterviewUtil.isExpiredMeeting(
                          DateTime.parse(
                              item['interview']['meetingRoom']['expired_at']),
                        )),
                  ),
                  'meeting': item['interview']['meetingRoom']
                      ['meeting_room_id'],
                }
              },
            );

            setState(() {
              _message.insert(0, interview);
            });
            _existedInterview.add(item['interview']['id']);
          }
        } catch (e) {
          log('meeting null error');
        }
      }
    } else {
      throw Exception('Failed to load chats');
    }
  }

  // Send the message to the server
  Future<void> onSentMessage(ChatMessage message) async {
    if (message.text.isEmpty) {
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: 'Empty message is not permitted!',
        textSubmit: 'Ok',
        submit: null,
      );

      return;
    }

    final response = await MessageService.sendMessage(
      context: context,
      projectId: widget.chatModel.idProject,
      receiverId: int.parse(_anotherUser.id),
      senderId: int.parse(_currentUser.id),
      content: message.text,
    );

    // send message successfully
    if (response.statusCode == StatusCode.created.code) {
      setState(() {
        _message.insert(0, message);
      });
      return;
    }

    // expired token
    if (response.statusCode == StatusCode.unauthorized.code) {
      ApiUtil.handleExpiredToken(context: context);
      return;
    }

    // other issues
    ApiUtil.handleOtherStatusCode(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.chatModel.name,
        onPressed: onOpenedMoreAction,
        currentContext: context,
        iconButton: Icons.calendar_month,
        isBack: true,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: StreamBuilder<void>(
          stream: _updateStreamController.stream,
          builder: (context, snapshot) {
            return DashChat(
              typingUsers: _typing,
              currentUser: _currentUser,
              onSend: onSentMessage,
              messages: _message,
              inputOptions: const InputOptions(
                inputTextStyle: TextStyle(color: Colors.black),
                cursorStyle: CursorStyle(color: Colors.black),
              ),
              messageOptions: MessageOptions(
                currentUserContainerColor:
                    Theme.of(context).colorScheme.primary,
                containerColor: Theme.of(context).colorScheme.primary,
                messageTextBuilder: (message, previousMessage, nextMessage) {
                  // if message is an interview, show box-interview
                  if (message.customProperties != null &&
                      message.customProperties!.containsKey('interview')) {
                    InterviewModel invitation =
                        message.customProperties!['interview']['model'];
                    String meetingId =
                        message.customProperties!['interview']['meeting'];

                    return InterviewCard(
                      socket: socket,
                      interviewInfo: invitation,
                      currentUserId: int.parse(_currentUser.id),
                      otherUserId: widget.chatModel.idUser,
                      projectId: widget.chatModel.idProject,
                      onJoined: () {
                        NavigationUtil.toJoinMeetingScreen(
                          context,
                          '${_anotherUser.firstName}',
                          _currentUser.id,
                          '${_currentUser.firstName}',
                          meetingId,
                          meetingId,
                        );
                      },
                    );
                  } else {
                    return Text(
                      message.text,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // show more actions bottom sheet
  Future<bool?> showMoreActionsBottomSheet() => showModalBottomSheet<bool>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 120,
              maxHeight: double.maxFinite,
            ),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // create new Interview button
                      TextButton(
                        onPressed: () {
                          // create new a Interview
                          Navigator.of(context).pop(true);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(30),
                        ),
                        child: Text(
                          'Schedule on interview',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      const CustomDivider(
                        isFullWidth: true,
                      ),
                      // cancel button
                      TextButton(
                        onPressed: () {
                          // have no clue
                          Navigator.of(context).pop(false);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(30),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

  // show Interview bottom sheet
  Future showInterviewBottomSheet() {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedStartTime = const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay selectedEndTime = const TimeOfDay(hour: 0, minute: 0);

    double duration =
        InterviewUtil.calculateTheDiffTimes(selectedStartTime, selectedEndTime);
    bool isValidTitle = false;

    // send invite interview to student
    Future<void> onSentInvititation() async {
      String meetingId = DateTime.now().toString();
      // Send the meeting to the server
      final response = await InterviewService.postInterview(
        context: context,
        title: titleController.text,
        startTime: InterviewUtil.formatDateTimeInterview(
          selectedDate,
          selectedStartTime,
        ),
        endTime: InterviewUtil.formatDateTimeInterview(
          selectedDate,
          selectedEndTime,
        ),
        projectId: widget.chatModel.idProject,
        receiverId: int.parse(_anotherUser.id),
        senderId: int.parse(_currentUser.id),
        meetingRoomId: meetingId,
      );

      Navigator.of(context).pop();

      if (response.statusCode == StatusCode.created.code) return;

      // send fail invite interview
      if (response.statusCode == StatusCode.unauthorized.code) {
        ApiUtil.handleExpiredToken(context: context);
      } else {
        ApiUtil.handleOtherStatusCode(context: context);
      }
    }

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        // open-close the Interview bottom-sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // return the Interview-picker bottom sheet
            return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title of Interview-sheet
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Schedule for a video interview",
                          isBold: true,
                          size: 20,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    // title of Interview textfield
                    const CustomText(
                      text: 'Title',
                      isBold: true,
                    ),
                    CustomTextForm(
                      isFocus: true,
                      controller: titleController,
                      listErros: const <InvalidationType>[
                        InvalidationType.isBlank
                      ],
                      hintText: "Enter title",
                      onHelper: ((messageError) {
                        // a title is valid when the message error is null
                        // that means have no error
                        setModalState(() {
                          isValidTitle = messageError == null ? true : false;
                        });
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Select date area
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 25,
                        ),
                        const SizedBox(
                          width: SpacingUtil.mediumHeight,
                        ),
                        // Select date to organize a Interview
                        ElevatedButton(
                          onPressed: () async {
                            final selectedDateTime =
                                await InterviewUtil.selectDate(context);
                            setModalState(() {
                              selectedDate = selectedDateTime!;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          child: Text(
                            '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    // Select start time to organize a Interview
                    Row(
                      children: [
                        const CustomText(
                          text: 'Start time',
                          isBold: true,
                        ),
                        const SizedBox(
                          width: SpacingUtil.mediumHeight,
                        ),
                        CustomButton(
                          onPressed: () async {
                            final selectedTime =
                                await InterviewUtil.selectTime(context);
                            setModalState(() {
                              selectedStartTime = selectedTime!;
                              // update the duration
                              duration = InterviewUtil.calculateTheDiffTimes(
                                  selectedStartTime, selectedEndTime);
                            });
                          },
                          text:
                              '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}',
                        ),
                      ],
                    ),
                    // Select end time to organize a Interview
                    Row(
                      children: [
                        const CustomText(
                          text: 'End time',
                          isBold: true,
                        ),
                        const SizedBox(
                          width: SpacingUtil.mediumHeight,
                        ),
                        CustomButton(
                          onPressed: () async {
                            final selectedTime =
                                await InterviewUtil.selectTime(context);
                            setModalState(() {
                              selectedEndTime = selectedTime!;
                              // update the duration
                              duration = InterviewUtil.calculateTheDiffTimes(
                                  selectedStartTime, selectedEndTime);
                            });
                          },
                          text:
                              '${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomText(
                      text: "Duration: $duration hours",
                      isItalic: true,
                      size: 15,
                      textColor: InterviewUtil.chooseColorByDuration(duration),
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // button cancel interview creation
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                        ),
                        // button send invite
                        CustomButton(
                          onPressed: onSentInvititation,
                          text: "Send Invite",
                          // when the duration is less than 0 or the title is not valid
                          // disable this button
                          isDisabled: duration <= 0 || !isValidTitle,
                          buttonColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
