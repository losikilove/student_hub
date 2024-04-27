import 'dart:async';
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/interview_card.dart';
import 'package:student_hub/models/chat_model.dart';
import 'package:student_hub/models/interview_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/message_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/interview_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:student_hub/services/interview_service.dart';

class MessageDetailScreen extends StatefulWidget {
  final ChatModel chatModel;
  MessageDetailScreen({super.key, required this.chatModel});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
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
      if (data['senderId'] == widget.chatModel.idUser) {
        _message.insert(
            0,
            ChatMessage(
              user: _anotherUser,
              text: data['content'],
              createdAt: DateTime.now(),
            ));
        _updateStreamController.add(null);
      }
    });

    // notify the other user
    socket.on('NOTI_${_currentUser.id}', (data) {
      // todo
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
      }
    } else {
      throw Exception('Failed to load chats');
    }
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
              onSend: (ChatMessage message) {
                // Send the message to the server
                socket.emit("SEND_MESSAGE", {
                  "content": message.text,
                  "projectId": widget.chatModel.idProject,
                  "messageFlag": 0,
                  "senderId": _currentUser.id,
                  'receiverId': _anotherUser.id,
                });
                setState(() {
                  _message.insert(0, message);
                });
              },
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
                        message.customProperties!['interview'];

                    return InterviewCard(
                      interviewInfo: invitation,
                      onJoined: () {
                        NavigationUtil.toJoinMeetingScreen(context);
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

  Widget ChatBoard(BuildContext context) {
    return StreamBuilder<void>(
      stream: _updateStreamController.stream,
      builder: (context, snapshot) {
        return DashChat(
          typingUsers: _typing,
          currentUser: _currentUser,
          onSend: (ChatMessage message) {
            // Send the message to the server
            socket.emit("SEND_MESSAGE", {
              "content": message.text,
              "projectId": widget.chatModel.idProject,
              "messageFlag": 0,
              "senderId": _currentUser.id,
              'receiverId': _anotherUser.id
            });
            setState(() {
              _message.insert(0, message);
            });
          },
          messages: _message,
          inputOptions: const InputOptions(
            inputTextStyle: TextStyle(color: Colors.black),
            cursorStyle: CursorStyle(color: Colors.black),
          ),
          messageOptions: MessageOptions(
            currentUserContainerColor: Theme.of(context).colorScheme.primary,
            containerColor: Theme.of(context).colorScheme.primary,
            messageTextBuilder: (message, previousMessage, nextMessage) {
              // if message is an interview, show box-interview
              if (message.customProperties != null &&
                  message.customProperties!.containsKey('interview')) {
                InterviewModel invitation =
                    message.customProperties!['interview'];

                return InterviewCard(
                  interviewInfo: invitation,
                  onJoined: () {
                    NavigationUtil.toJoinMeetingScreen(context);
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

    void saveInterview() async {
      await InterviewService.postInterview(
          title: titleController.text,
          dateStartInterview: selectedDate,
          timeStartInterview: selectedStartTime,
          timeEndInterview: selectedEndTime);
    }

    // send invite interview to student
    void onSentInvititation() {
      ChatMessage invitation = ChatMessage(
          user: _currentUser,
          createdAt: DateTime.now(),
          text: 'showInvitation',
          customProperties: {
            'interview': InterviewModel(
              null,
              [_currentUser, _anotherUser],
              titleController.text,
              selectedDate,
              selectedStartTime,
              selectedEndTime,
            ),
          });

      // save the interview meeting info into messages
      setState(() {
        _message.insert(0, invitation);
      });
      saveInterview();
      // out of this Interview bottom sheet
      Navigator.of(context).pop();
    }

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        // open-close the Interview bottom-sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // return the Interview-picker bottom sheet
            return Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              height: 450,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title of Interview-sheet
                    const CustomText(
                      text: "Schedule for a video interview",
                      isBold: true,
                      size: 20,
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
