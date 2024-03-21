import 'package:flutter/material.dart';
import 'package:student_hub/utils/interview_util.dart';

class InterviewModel {
  final String? id;
  final List<dynamic> participants;
  double _duration;
  String _title;
  DateTime _dateInterview;
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  bool _isCanceled;

  InterviewModel(
    this.id,
    this.participants,
    this._title,
    this._dateInterview,
    this._startTime,
    this._endTime,
  )   : _duration = InterviewUtil.calculateTheDiffTimes(_startTime, _endTime),
        _isCanceled = false;

  // getter
  String get getInterviewId => id!;
  List<dynamic> get getParticipants => participants;
  String get getTitle => _title;
  DateTime get getDateInterview => _dateInterview;
  TimeOfDay get getStartTime => _startTime;
  TimeOfDay get getEndTime => _endTime;
  double get getDuration => _duration;
  bool get isCanceled => _isCanceled;

  // setter
  set setTitle(String title) {
    _title = title;
  }

  set setDateInterview(DateTime dateInterview) {
    _dateInterview = dateInterview;
  }

  set setStartTime(TimeOfDay startTime) {
    _startTime = startTime;
    _duration = InterviewUtil.calculateTheDiffTimes(_startTime, _endTime);
  }

  set setEndTime(TimeOfDay endTime) {
    _endTime = endTime;
    _duration = InterviewUtil.calculateTheDiffTimes(_startTime, _endTime);
  }

  void cancelMeeting() {
    _isCanceled = true;
  }
}
