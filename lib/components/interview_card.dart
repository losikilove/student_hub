import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/models/interview_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/interview_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class InterviewCard extends StatefulWidget {
  final InterviewModel interviewInfo;
  final void Function() onJoined;

  const InterviewCard(
      {super.key, required this.interviewInfo, required this.onJoined});

  @override
  State<InterviewCard> createState() => _InterviewCardState();
}

class _InterviewCardState extends State<InterviewCard> {
  void onOpenedMoreActions() async {
    final isRescheduledInterview = await showMoreActionsBottomSheet();

    // have no clue
    if (isRescheduledInterview == null) {
      return;
    }

    // cancel the meeting interview
    if (isRescheduledInterview == false) {
      // showing the dialog warning the canceled meeting
      // and waiting for its response
      final isCanceledMeeting = await openDialogWarningCanceledMeeting();

      // have no clue
      if (isCanceledMeeting == null) {
        return;
      }

      // cancel the meeting
      setState(() {
        widget.interviewInfo.cancelMeeting();
      });
      return;
    }

    // re-schedule the meeting interview
    showUpdatingMeetingInterview();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // title of interview
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CustomText(
                    text: widget.interviewInfo.getTitle,
                    isBold: true,
                    size: 17.0,
                    isOverflow: true,
                  ),
                ),
                // duration of interview
                CustomText(
                  text: 'in ${widget.interviewInfo.getDuration} hours',
                  isItalic: true,
                )
              ],
            ),
            // date interview
            CustomText(
                text:
                    'Day: ${_dateForm(widget.interviewInfo.getDateInterview)}'),
            // start time to end time interview
            CustomText(
              text:
                  'Start: ${_timeForm(widget.interviewInfo.getStartTime)} - End: ${_timeForm(widget.interviewInfo.getEndTime)}',
            ),
            // if the meeting canceled, show the canceling text
            // else show buttons
            widget.interviewInfo.isCanceled
                // cenceled the meeting text
                ? const Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      text: 'The meeting has canceled',
                      textColor: Colors.red,
                      isItalic: true,
                    ),
                  )
                // buttons
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // join button
                      CustomButton(
                        onPressed: widget.onJoined,
                        text: 'Join',
                      ),
                      // more actions button
                      IconButton(
                        onPressed: onOpenedMoreActions,
                        icon: const Icon(
                          Icons.keyboard_control,
                        ),
                      ),
                    ],
                  ),
          ],
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
                      // reschedule interview button
                      TextButton(
                        onPressed: () {
                          // create new a Interview
                          Navigator.of(context).pop(true);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(30),
                        ),
                        child: const Text(
                          'Re-schedule the meeting',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const CustomDivider(
                        isFullWidth: true,
                      ),
                      // cancel interview button
                      TextButton(
                        onPressed: () {
                          // cancel the interview
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

  // determine to cancel or keep the meeting alert dialog
  Future<bool?> openDialogWarningCanceledMeeting() => showDialog<bool>(
        context: context,
        builder: (context) {
          void onYes() {
            Navigator.of(context).pop(true);
          }

          return AlertDialog(
            title: const Text(
              'WARNING',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text('Are you sure to cancel this meeting'),
            actions: [
              CustomButton(
                onPressed: onYes,
                text: 'YES',
              ),
            ],
          );
        },
      );

  // show Interview bottom sheet
  Future showUpdatingMeetingInterview() {
    final titleController =
        TextEditingController(text: widget.interviewInfo.getTitle);
    DateTime selectedDate = widget.interviewInfo.getDateInterview;
    TimeOfDay selectedStartTime = widget.interviewInfo.getStartTime;
    TimeOfDay selectedEndTime = widget.interviewInfo.getEndTime;
    double duration = widget.interviewInfo.getDuration;

    // update meeting
    void onUpdatedMeeting() {
      // edit the values of meeting
      setState(() {
        widget.interviewInfo.setTitle = titleController.text;
        widget.interviewInfo.setDateInterview = selectedDate;
        widget.interviewInfo.setStartTime = selectedStartTime;
        widget.interviewInfo.setEndTime = selectedEndTime;
      });

      // out of this updating
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
                      text: "Re-schedule for the video interview",
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
                      onHelper: ((messageError) {}),
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
                              duration = widget.interviewInfo.getDuration;
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
                    // duration text
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
                          onPressed: onUpdatedMeeting,
                          text: "Update",
                          buttonColor: ColorUtil.darkPrimary,
                          // when the duration is less than 0, disable this button
                          isDisabled: duration <= 0,
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

  String _dateForm(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  String _timeForm(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
