import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';

class ChatModel {
  int idUser;
  int idProject;
  String name;
  String profession;
  DateTime dateTime;

  ChatModel(
    this.idUser,
    this.idProject,
    this.name,
    this.profession,
    this.dateTime,
  );

  // getter
  int get getId => idUser;
  int get getIdProject => idProject;
  String get getName => name;
  String get getProfession => profession;
  String get getDateTime =>
      '${dateTime.hour}:${dateTime.minute} ${dateTime.day}/${dateTime.month}/${dateTime.year}';

  // setter
  set setName(String newName) {
    name = newName;
  }

  set setProfession(String newProfession) {
    profession = newProfession;
  }

  set setDateTime(DateTime newTime) {
    dateTime = newTime;
  }

  static List<ChatModel> fromResponse(
      http.Response response, BuildContext context) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> result = data['result'];
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final myId = userProvider.user!.userId;
    final myName = userProvider.user!.fullname;

    Map<String, ChatModel> latestChats = {};
    var idUser = 0;
    var Name = '';
    for (var item in result) {
      var projectId = item['project']['id'];
      if(item['sender']['id'] == myId) {
        idUser = item['receiver']['id'];
      }
      else{
        idUser = item['sender']['id'];
      }
      if(item['sender']['fullname'] == myName){
        Name = item['receiver']['fullname'];
      }else{
        Name = item['sender']['fullname'];
      }
      
      var senderProfession = item['sender']['profession'] ?? 'Unknown';
      var messageDateTime = DateTime.parse(item['createdAt']);

      var chat = ChatModel(
          idUser, projectId, Name, senderProfession, messageDateTime);

      var key = '$idUser-$projectId';

      // If there's already a chat for this user and it's newer, skip this one
      if (latestChats.containsKey(key) &&
          latestChats[key]!.dateTime.isAfter(messageDateTime)) {
        continue;
      }

      // Otherwise, add this chat as the latest chat for this user
      latestChats[key] = chat;
    }

    return latestChats.values.toList();
  }
}
