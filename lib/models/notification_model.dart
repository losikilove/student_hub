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
class MeetingInterviewModel{
  final int id;
  final String meetingRoomCode;
  final String meetingRoomId;
  final String expiredAt;
  MeetingInterviewModel({
    required this.id,
    required this.meetingRoomCode,
    required this.meetingRoomId,
    required this.expiredAt,
  });
  factory MeetingInterviewModel.fromJson(Map<String, dynamic> json) {
    return MeetingInterviewModel(
      id: json['id'],
      meetingRoomCode: json['meeting_room_code'],
      meetingRoomId: json['meeting_room_id'],
      expiredAt: json['expired_at'],
    );
  }

}

class InterviewNotificationModel{
  final String title;
  final String startTime;
  final String endTime;
  final int disableFlag;
  final MeetingInterviewModel? meetingInterview;
  InterviewNotificationModel({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.disableFlag,
    required this.meetingInterview,
  });

  factory InterviewNotificationModel.fromJson(Map<String, dynamic> json) {
    MeetingInterviewModel meetingInterviewModel1 = MeetingInterviewModel(
      id: 52,
      meetingRoomCode: "hellosdp",
      meetingRoomId: "5555",
      expiredAt:"2024-04-30T02:13:56.718Z",
    );
    return InterviewNotificationModel(
      title: json['title'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      disableFlag: json['disableFlag'],
      meetingInterview: json['meetingRoom'] != null ? MeetingInterviewModel.fromJson(json['meetingRoom']) :meetingInterviewModel1,
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
