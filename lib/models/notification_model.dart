import 'dart:convert';
import 'package:http/http.dart' as http;
class MessageModel{
  // final int id;
  final String createdAt;
  // final int senderId;
  // final int receiverId;
  // final int projectId;
  // final int interviewId;
  final String content;
  // final int messageFlag;
  MessageModel({
    // required this.id,
    required this.createdAt,
    // required this.senderId,
    // required this.receiverId,
    // required this.projectId,
    // required this.interviewId,
    required this.content,
    // required this.messageFlag,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
    //  id: json['id'],
      createdAt: json['createdAt'],
      // senderId: json['senderId'],
      // receiverId: json['receiverId'],
      // projectId: json['projectId'],
      // interviewId: json['interviewId'],
      content: json['content'],
      // messageFlag: json['messageFlag'],
    );
  }
}

class UserNotification{
  // final int id;
  // final String createdAt;
  // final String email;
  final String fullname;
  // final int roles;
  // final bool verified;
  // final bool isConfirmed;
  UserNotification({
    // required this.id,
    // required this.createdAt,
    // required this.email,
    required this.fullname,
    // required this.roles,
    // required this.verified,
    // required this.isConfirmed,
  });
  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      // id: json['id'],
      // createdAt: json['createdAt'],
      // email: json['email'],
      fullname: json['fullname'],
      // roles: json['roles'],
      // verified: json['verified'],
      // isConfirmed: json['isConfirmed'],
    );
  } 
}

class MeetingRoomModel{
  final int id;
  final String createdAt;
  final String meetingRoomCode;
  final String meetingRoomId;
  final String expiredAt;
  MeetingRoomModel({
    required this.id,
    required this.createdAt,
    required this.meetingRoomCode,
    required this.meetingRoomId,
    required this.expiredAt,
  });
  factory MeetingRoomModel.fromJson(Map<String, dynamic> json) {
    return MeetingRoomModel(
      id: json['id'],
      createdAt: json['createdAt'],
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
  final InterviewNotificationModel? interview;
  final MeetingRoomModel? meetingRoom;

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
    required this.interview,
    required this.meetingRoom,
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
              interview: e['interview'] != null ? InterviewNotificationModel.fromJson(e['interview']) : null,
              meetingRoom: e['meetingRoom'] != null ? MeetingRoomModel.fromJson(e['meetingRoom']) : null,
            ))
        .toList();
  }
}
