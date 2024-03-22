import 'package:dash_chat_2/dash_chat_2.dart';
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

    // show options Interview
    showInterviewBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          title: 'Luis Pham',
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
              setState(() {
                _message.insert(0, message);
              });
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
    double duration =
        InterviewUtil.calculateTheDiffTimes(selectedStartTime, selectedEndTime);
    bool isValidTitle = false;

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
                          buttonColor: ColorUtil.darkPrimary,
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
}
