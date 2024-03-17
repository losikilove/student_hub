import 'package:flutter/material.dart';

class ChatModel {
  String _name;
  String _profession;
  DateTime _dateTime;
  IconData _avatar;

  ChatModel(
    this._name,
    this._profession,
    this._dateTime,
    this._avatar,
  );

  // getter
  String get getName => _name;
  String get getProfession => _profession;
  String get getDateTime =>
      '${_dateTime.hour}:${_dateTime.minute} ${_dateTime.day}/${_dateTime.month}/${_dateTime.year}';
  IconData get getAvatar => _avatar;

  // setter
  set setName(String newName) {
    _name = newName;
  }

  set setProfession(String newProfession) {
    _profession = newProfession;
  }

  set setDateTime(DateTime newTime) {
    _dateTime = newTime;
  }

  set setAvatar(IconData newAvatar) {
    _avatar = newAvatar;
  }
}
