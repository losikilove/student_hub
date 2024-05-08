import 'dart:convert';
import 'package:http/http.dart' as http;

class MessageModel{
  final int id;
  final String createdAt;
  final String content;
  final InterviewNotificationModel? interview;
  MessageModel({
    required this.id,
    required this.createdAt,
    required this.content,
    required this.interview,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      createdAt: json['createdAt'],
      content: json['content'],
      interview: json['interview'] != null ? InterviewNotificationModel.fromJson(json['interview']) : null,

    );
  }
}

class UserNotification{
  final int id;
  final String email;
  final String fullname;

  UserNotification({
    required this.id,
    required this.email,
    required this.fullname,

  });
  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
    );
  } 
}


class InterviewNotificationModel{
  final String title;
  final String startTime;
  final String endTime;
  final int disableFlag;
  InterviewNotificationModel({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.disableFlag,
  });

  factory InterviewNotificationModel.fromJson(Map<String, dynamic> json) {
    return InterviewNotificationModel(
      title: json['title'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      disableFlag: json['disableFlag'],
    );
  }
}

class NotificationModel{
  final int id;
  final String createdAt;
  final int receiverId;
  final int senderId;
  final String title;
  final String typeNotifyFlag;
  final String content;
  final MessageModel message;
  final UserNotification sender;


  NotificationModel({
    required this.id,
    required this.createdAt,
    required this.receiverId,
    required this.senderId,
    required this.title,
    required this.typeNotifyFlag,
    required this.content,
    required this.message,
    required this.sender,

  });
  
  static List<NotificationModel> fromResponse(http.Response response) {
    return (json.decode(response.body)['result'] as List<dynamic>)
        .map((e) => NotificationModel(
              id: e['id'],
              createdAt: e['createdAt'],
              receiverId: e['receiverId'],
              senderId: e['senderId'],
              title: e['title'],
              typeNotifyFlag: e['typeNotifyFlag'],
              content: e['content'],
              message: MessageModel.fromJson(e['message']),
              sender: UserNotification.fromJson(e['sender']),
            ))
        .toList();
  }
}
