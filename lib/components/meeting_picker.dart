import 'dart:async';
import 'dart:math';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class MeetingPicker extends StatefulWidget {
  const MeetingPicker({super.key});

  @override
  State<MeetingPicker> createState() => _MeetingPickerState();
}

class _MeetingPickerState extends State<MeetingPicker> {
  final minuteBetweenMeeting = 30;
  final optionOfMinute = 2;
  final optionOfHour = 24;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showMeetingBottomSheet();
      },
      icon: const Icon(Icons.keyboard_control),
    );
  }

  // show meeting bottom sheet
  Future showMeetingBottomSheet() {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedStartTime = const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay selectedEndTime = const TimeOfDay(hour: 0, minute: 0);
    bool isEnteredTitle = false,
        isSelectedStartTime = false,
        isSelectedEndTime = false;
    bool isWarningInvalidTime = false;

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        // open-close the meeting bottom-sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // return the meeting-picker bottom sheet
            return Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 20, bottom: 8),
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title of meeting-sheet
                    const CustomText(
                      text: "Schedule for a video interview",
                      isBold: true,
                      size: 20,
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    // title of meeting textfield
                    const CustomText(
                      text: 'Title',
                      isBold: true,
                    ),
                    CustomTextForm(
                      controller: titleController,
                      listErros: const <InvalidationType>[
                        InvalidationType.isBlank
                      ],
                      hintText: "Catch up meeting",
                      onHelper: ((messageError) {
                        // enable the create-meeting button
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
                        // Select date to organize a meeting
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
                    // Select start time to organize a meeting
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
                              // enable the create-meeting button
                              isSelectedStartTime = true;
                            });
                          },
                          text:
                              '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}',
                          buttonColor: ColorUtil.darkPrimary,
                        ),
                      ],
                    ),
                    // Select end time to organize a meeting
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
                              // enable the create-meeting button
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
                          "Duration: ${calculateTheDiffTimes(selectedStartTime, selectedEndTime)} hours",
                      isItalic: true,
                      size: 15,
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                        ),
                        CustomButton(
                          onPressed: () {},
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
                          selectedMinute =
                              initialMinuteIndex * minuteBetweenMeeting;
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
                          selectedMinute = index * minuteBetweenMeeting;
                        },
                        childCount: optionOfMinute,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text('${index * minuteBetweenMeeting}'),
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

  double calculateTheDiffTimes(TimeOfDay startTime, TimeOfDay endTime) {
    double doubleStartTime =
        startTime.hour + (startTime.minute == minuteBetweenMeeting ? 0.5 : 0);
    double doubleEndTime =
        endTime.hour + (endTime.minute == minuteBetweenMeeting ? 0.5 : 0);

    double result = ((doubleEndTime - doubleStartTime).abs() % 24);

    // if start time is greater than end time, multiply the result with -1
    return doubleStartTime > doubleEndTime ? -1 * result : result;
  }
}
