import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InterviewUtil {
  static const minuteBetweenInterview = 30;
  static const optionOfHour = 24;
  static const optionOfMinute = 2;

  // calculate the difference times
  static double calculateTheDiffTimes(TimeOfDay startTime, TimeOfDay endTime) {
    double doubleStartTime =
        startTime.hour + (startTime.minute == minuteBetweenInterview ? 0.5 : 0);
    double doubleEndTime =
        endTime.hour + (endTime.minute == minuteBetweenInterview ? 0.5 : 0);

    double result = ((doubleEndTime - doubleStartTime).abs() % 24);

    // if start time is greater than end time, multiply the result with -1
    return doubleStartTime > doubleEndTime ? -1 * result : result;
  }

  // show date-picker
  static Future<DateTime?> selectDate(BuildContext context) async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    return dateTime!;
  }

  // show time-picker
  static Future<TimeOfDay?> selectTime(BuildContext context) async {
    int selectedHour = 0;
    int selectedMinute = 0;
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
                    final timeOfDay =
                        TimeOfDay(hour: selectedHour, minute: selectedMinute);
                    // pop picked time
                    Navigator.of(context).pop(timeOfDay);
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

  // choose color by duration
  static Color chooseColorByDuration(double duration) {
    return duration <= 0 ? Colors.red : Colors.black;
  }

  // format timedate to push interview
  static String formatDateTimeInterview(DateTime date, TimeOfDay time) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00Z';
  }

  // is expired meeting
  static bool isExpiredMeeting(DateTime expiredDate) {
    return expiredDate.isBefore(DateTime.now());
  }
}
