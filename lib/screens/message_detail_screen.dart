import 'dart:developer';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/interview_card.dart';
import 'package:student_hub/models/interview_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/interview_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class MessageDetailScreen extends StatefulWidget {
  const MessageDetailScreen({super.key});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final optionOfMinute = 2;
  final optionOfHour = 24;
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'phat', lastName: 'bo');
  final ChatUser _anotherUser =
      ChatUser(id: '2', firstName: 'nhat', lastName: 'bo');

  final List<ChatMessage> _message = <ChatMessage>[];
  final List<ChatUser> _typing = <ChatUser>[];
  getData(ChatMessage message) async {
    setState(() {
      _message.insert(0, message);
    });
  }

  @override
  void initState() {
    super.initState();
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

    // creating new Interview
    showInterviewBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          title: 'chat',
          onPressed: onOpenedMoreAction,
          currentContext: context,
          iconButton: Icons.calendar_month,
          isBack: true,
        ),
        body: Container(
          color: ColorUtil.lightPrimary,
          child: DashChat(
            typingUsers: _typing,
            currentUser: _currentUser,
            onSend: (ChatMessage message) {
              getData(message);
            },
            messages: _message,
            inputOptions: const InputOptions(
              cursorStyle: CursorStyle(color: ColorUtil.primary),
            ),
            messageOptions: MessageOptions(
              currentUserContainerColor: ColorUtil.primary,
              containerColor: const Color.fromARGB(255, 255, 255, 255),
              messageTextBuilder: (message, previousMessage, nextMessage) {
                // if message is an interview, show box-interview
                if (message.customProperties != null &&
                    message.customProperties!.containsKey('interview')) {
                  InterviewModel invitation =
                      message.customProperties!['interview'];

                  return InterviewCard(
                    interviewInfo: invitation,
                    onJoined: () {},
                  );
                } else {
                  return Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
          ),
        ));
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
                        child: const Text(
                          'Schedule on interview',
                          style: TextStyle(color: Colors.black),
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
    bool isEnteredTitle = false,
        isSelectedStartTime = false,
        isSelectedEndTime = false;

    // send invite interview to student
    void onSentInvite() {
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

      setState(() {
        _message.insert(0, invitation);
      });

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
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 8),
              height: 400,
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
                      hintText: "Title of interview",
                      onHelper: ((messageError) {
                        // enable the create-Interview button
                        isEnteredTitle = messageError == null ? true : false;
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
                            final selectedDateTime = await selectDate();
                            setModalState(() {
                              selectedDate = selectedDateTime!;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorUtil.darkPrimary),
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
                            final selectedTime = await selectTime(context);
                            setModalState(() {
                              selectedStartTime = selectedTime!;
                              // enable the create-Interview button
                              isSelectedStartTime = true;
                            });
                          },
                          text:
                              '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}',
                          buttonColor: ColorUtil.darkPrimary,
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
                            final selectedTime = await selectTime(context);
                            setModalState(() {
                              selectedEndTime = selectedTime!;
                              // enable the create-Interview button
                              isSelectedEndTime = true;
                            });
                          },
                          text:
                              '${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}',
                          buttonColor: ColorUtil.darkPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomText(
                      text:
                          "Duration: ${InterviewUtil.calculateTheDiffTimes(selectedStartTime, selectedEndTime)} hours",
                      isItalic: true,
                      size: 15,
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
                          onPressed: onSentInvite,
                          text: "Send Invite",
                          // handle button
                          isDisabled: !isEnteredTitle ||
                              !isSelectedStartTime ||
                              !isSelectedEndTime,
                          buttonColor: ColorUtil.darkPrimary,
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

  // show date-picker
  Future<DateTime?> selectDate() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    return dateTime!;
  }

  // show time-picker
  Future<TimeOfDay?> selectTime(BuildContext context) async {
    int? selectedHour;
    int? selectedMinute;
    int initialMinuteIndex = 0; // Chỉ mục ban đầu của phút

    final timeOfday = await showModalBottomSheet<TimeOfDay?>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250.0,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    if (selectedHour != null && selectedMinute != null) {
                      final timeOfDay = TimeOfDay(
                          hour: selectedHour!, minute: selectedMinute!);
                      // pop picked time
                      Navigator.of(context).pop(timeOfDay);
                    }
                  },
                  child: const Text('Done'),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          selectedHour = index;
                          selectedMinute = initialMinuteIndex *
                              InterviewUtil.minuteBetweenInterview;
                        },
                        childCount: optionOfHour,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text('$index'),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          initialMinuteIndex = index;
                          selectedMinute =
                              index * InterviewUtil.minuteBetweenInterview;
                        },
                        childCount: optionOfMinute,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text(
                                '${index * InterviewUtil.minuteBetweenInterview}'),
                          );
                        },
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

    return timeOfday;
  }

  Future<void> getChatResponse(ChatMessage message) async {
    setState(() {
      _message.insert(0, message);
    });
  }
}
