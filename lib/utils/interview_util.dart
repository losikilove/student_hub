import 'package:flutter/material.dart';

class InterviewUtil {
  static const minuteBetweenInterview = 30;

  static double calculateTheDiffTimes(TimeOfDay startTime, TimeOfDay endTime) {
    double doubleStartTime =
        startTime.hour + (startTime.minute == minuteBetweenInterview ? 0.5 : 0);
    double doubleEndTime =
        endTime.hour + (endTime.minute == minuteBetweenInterview ? 0.5 : 0);

    double result = ((doubleEndTime - doubleStartTime).abs() % 24);

    // if start time is greater than end time, multiply the result with -1
    return doubleStartTime > doubleEndTime ? -1 * result : result;
  }
}
