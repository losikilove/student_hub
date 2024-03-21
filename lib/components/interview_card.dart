import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/interview_model.dart';

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

    // TODO: cancel the interview
    if (isRescheduledInterview == false) {
      return;
    }

    // TODO: re-schedule the interview
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
            Row(
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

  String _dateForm(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  String _timeForm(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
