import 'dart:async';
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
  final titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 0, minute: 0);
  bool isEnteredTitle = false,
      isSelectedStartTime = false,
      isSelectedEndTime = false;

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            // open-close the meeting bottom-sheet
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                double doubleStartTime = 0, doubleEndTime = 0;
                double timeDiff = 0;
                int hour = 0;
                double minute = 0;

                // show date-picker
                Future<void> selectDate() async {
                  await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then(
                    (value) => setModalState(() {
                      selectedDate = value!;
                    }),
                  );
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
                                  if (selectedHour != null &&
                                      selectedMinute != null) {
                                    final timeOfDay = TimeOfDay(
                                        hour: selectedHour!,
                                        minute: selectedMinute!);
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
                                            initialMinuteIndex * 15;
                                      },
                                      childCount: 24,
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                        selectedMinute = index * 15;
                                      },
                                      childCount: 4,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Center(
                                          child: Text('${index * 15}'),
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

                // return the meeting-picker bottom sheet
                return Container(
                  padding: EdgeInsets.only(left:6,right:6,top:14),
                  height:400,
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
                              await selectDate();
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
                                '${selectedStartTime.hour}:${selectedStartTime.minute}',
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
                                '${selectedEndTime.hour}:${selectedEndTime.minute}',
                            buttonColor: ColorUtil.darkPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomText(
                        text: "Duration: $hour hour $minute minutes",
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
                            onPressed: () {},
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
                );
              },
            );
          },
        );
      },
      icon: const Icon(Icons.keyboard_control),
    );
  }
}
