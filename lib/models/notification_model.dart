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

// {
//     "result": [
//         {
//             "id": 1,
//             "createdAt": "2024-04-27T04:29:08.630Z",
//             "updatedAt": "2024-04-27T04:29:08.630Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 996,
//             "title": "new meeting",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 996,
//                 "createdAt": "2024-04-27T04:29:08.614Z",
//                 "updatedAt": "2024-04-27T04:29:08.614Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 8,
//                 "content": "Interview created",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 8,
//                     "createdAt": "2024-04-27T04:29:08.598Z",
//                     "updatedAt": "2024-05-05T13:49:58.704Z",
//                     "deletedAt": "2024-05-05T13:49:58.701Z",
//                     "title": "new meeting",
//                     "startTime": "2024-04-30T13:30:00.000Z",
//                     "endTime": "2024-04-30T15:30:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": null,
//                     "meetingRoom": null
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2,
//             "createdAt": "2024-04-27T04:30:22.913Z",
//             "updatedAt": "2024-04-27T04:30:22.913Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 997,
//             "title": "new meeting",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 997,
//                 "createdAt": "2024-04-27T04:30:22.893Z",
//                 "updatedAt": "2024-04-27T04:30:22.893Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 9,
//                 "content": "Interview created",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 9,
//                     "createdAt": "2024-04-27T04:30:22.876Z",
//                     "updatedAt": "2024-05-05T13:50:04.386Z",
//                     "deletedAt": "2024-05-05T13:50:04.385Z",
//                     "title": "new meeting",
//                     "startTime": "2024-04-30T13:30:00.000Z",
//                     "endTime": "2024-04-30T15:30:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": null,
//                     "meetingRoom": null
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 28,
//             "createdAt": "2024-04-29T23:19:52.161Z",
//             "updatedAt": "2024-04-29T23:19:52.161Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 1729,
//             "title": "vannghi",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 1729,
//                 "createdAt": "2024-04-29T23:19:52.152Z",
//                 "updatedAt": "2024-04-29T23:19:52.152Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 37,
//                 "content": "Interview created",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 37,
//                     "createdAt": "2024-04-29T23:19:52.143Z",
//                     "updatedAt": "2024-04-29T23:19:52.143Z",
//                     "deletedAt": null,
//                     "title": "vannghi",
//                     "startTime": "2024-04-29T23:19:18.339Z",
//                     "endTime": "2024-04-29T23:19:18.339Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 43,
//                     "meetingRoom": {
//                         "id": 43,
//                         "createdAt": "2024-04-29T23:19:52.135Z",
//                         "updatedAt": "2024-04-29T23:19:52.135Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "hisd",
//                         "meeting_room_id": "45678",
//                         "expired_at": "2024-04-29T23:19:18.339Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 37,
//             "createdAt": "2024-04-30T02:18:26.074Z",
//             "updatedAt": "2024-04-30T02:18:26.074Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 25,
//             "messageId": 1741,
//             "title": "hello",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 1741,
//                 "createdAt": "2024-04-30T02:18:26.066Z",
//                 "updatedAt": "2024-04-30T02:18:26.066Z",
//                 "deletedAt": null,
//                 "senderId": 25,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 46,
//                 "content": "Interview created",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 46,
//                     "createdAt": "2024-04-30T02:18:26.058Z",
//                     "updatedAt": "2024-04-30T02:18:26.058Z",
//                     "deletedAt": null,
//                     "title": "hello",
//                     "startTime": "2024-04-30T02:13:56.718Z",
//                     "endTime": "2024-04-30T02:13:56.718Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 52,
//                     "meetingRoom": {
//                         "id": 52,
//                         "createdAt": "2024-04-30T02:18:26.053Z",
//                         "updatedAt": "2024-04-30T02:18:26.053Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "hellosdp",
//                         "meeting_room_id": "5555",
//                         "expired_at": "2024-04-30T02:13:56.718Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 40,
//             "createdAt": "2024-04-30T02:22:45.098Z",
//             "updatedAt": "2024-04-30T02:22:45.098Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 1744,
//             "title": "hello",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 1744,
//                 "createdAt": "2024-04-30T02:22:45.090Z",
//                 "updatedAt": "2024-04-30T02:22:45.090Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 49,
//                 "content": "Interview created",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 49,
//                     "createdAt": "2024-04-30T02:22:45.084Z",
//                     "updatedAt": "2024-04-30T02:22:45.084Z",
//                     "deletedAt": null,
//                     "title": "hello",
//                     "startTime": "2024-04-30T02:13:56.718Z",
//                     "endTime": "2024-04-30T02:13:56.718Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 56,
//                     "meetingRoom": {
//                         "id": 56,
//                         "createdAt": "2024-04-30T02:22:45.080Z",
//                         "updatedAt": "2024-04-30T02:22:45.080Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "58889",
//                         "meeting_room_id": "42113",
//                         "expired_at": "2024-04-30T02:13:56.718Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 41,
//             "createdAt": "2024-04-30T02:35:03.083Z",
//             "updatedAt": "2024-04-30T02:35:03.083Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 1745,
//             "title": "hello",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 1745,
//                 "createdAt": "2024-04-30T02:35:03.075Z",
//                 "updatedAt": "2024-04-30T02:35:03.075Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 50,
//                 "content": "Interview created",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 50,
//                     "createdAt": "2024-04-30T02:35:03.065Z",
//                     "updatedAt": "2024-04-30T02:35:03.065Z",
//                     "deletedAt": null,
//                     "title": "hello",
//                     "startTime": "2024-04-30T02:13:56.718Z",
//                     "endTime": "2024-04-30T02:13:56.718Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 57,
//                     "meetingRoom": {
//                         "id": 57,
//                         "createdAt": "2024-04-30T02:35:03.060Z",
//                         "updatedAt": "2024-04-30T02:35:03.060Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "58889",
//                         "meeting_room_id": "42113",
//                         "expired_at": "2024-04-30T02:13:56.718Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 313,
//             "createdAt": "2024-05-01T00:02:00.165Z",
//             "updatedAt": "2024-05-01T00:02:00.165Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 2094,
//             "title": "New message is sent by user 267",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "3",
//             "proposalId": null,
//             "content": "New message created",
//             "message": {
//                 "id": 2094,
//                 "createdAt": "2024-05-01T00:02:00.162Z",
//                 "updatedAt": "2024-05-01T00:02:00.162Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": null,
//                 "content": "Phat",
//                 "messageFlag": 0,
//                 "interview": null
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2200,
//             "createdAt": "2024-05-05T13:31:04.776Z",
//             "updatedAt": "2024-05-05T13:31:04.776Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3807,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3807,
//                 "createdAt": "2024-05-05T13:31:04.771Z",
//                 "updatedAt": "2024-05-05T13:31:04.771Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 388,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 388,
//                     "createdAt": "2024-05-05T13:31:04.761Z",
//                     "updatedAt": "2024-05-05T13:31:04.761Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 423,
//                     "meetingRoom": {
//                         "id": 423,
//                         "createdAt": "2024-05-05T13:31:04.755Z",
//                         "updatedAt": "2024-05-05T13:31:04.755Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T20:31:00Z",
//                         "meeting_room_id": "2024-05-05T20:31:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2258,
//             "createdAt": "2024-05-05T15:01:02.025Z",
//             "updatedAt": "2024-05-05T15:01:02.025Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3835,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3835,
//                 "createdAt": "2024-05-05T15:01:02.020Z",
//                 "updatedAt": "2024-05-05T15:01:02.020Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 398,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 398,
//                     "createdAt": "2024-05-05T15:01:02.012Z",
//                     "updatedAt": "2024-05-05T15:01:02.012Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 433,
//                     "meetingRoom": {
//                         "id": 433,
//                         "createdAt": "2024-05-05T15:01:02.008Z",
//                         "updatedAt": "2024-05-05T15:01:02.008Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:01:00Z",
//                         "meeting_room_id": "2024-05-05T22:01:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2261,
//             "createdAt": "2024-05-05T15:07:45.375Z",
//             "updatedAt": "2024-05-05T15:07:45.375Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3838,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3838,
//                 "createdAt": "2024-05-05T15:07:45.368Z",
//                 "updatedAt": "2024-05-05T15:07:45.368Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 400,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 400,
//                     "createdAt": "2024-05-05T15:07:45.361Z",
//                     "updatedAt": "2024-05-05T15:07:45.361Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 435,
//                     "meetingRoom": {
//                         "id": 435,
//                         "createdAt": "2024-05-05T15:07:45.356Z",
//                         "updatedAt": "2024-05-05T15:07:45.356Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:08:00Z",
//                         "meeting_room_id": "2024-05-05T22:08:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2263,
//             "createdAt": "2024-05-05T15:12:31.060Z",
//             "updatedAt": "2024-05-05T15:12:31.060Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3840,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3840,
//                 "createdAt": "2024-05-05T15:12:31.053Z",
//                 "updatedAt": "2024-05-05T15:12:31.053Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 402,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 402,
//                     "createdAt": "2024-05-05T15:12:31.045Z",
//                     "updatedAt": "2024-05-05T15:12:31.045Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 437,
//                     "meetingRoom": {
//                         "id": 437,
//                         "createdAt": "2024-05-05T15:12:31.039Z",
//                         "updatedAt": "2024-05-05T15:12:31.039Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:14:00Z",
//                         "meeting_room_id": "2024-05-05T22:14:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2264,
//             "createdAt": "2024-05-05T15:17:42.206Z",
//             "updatedAt": "2024-05-05T15:17:42.206Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3841,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3841,
//                 "createdAt": "2024-05-05T15:17:42.200Z",
//                 "updatedAt": "2024-05-05T15:17:42.200Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 403,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 403,
//                     "createdAt": "2024-05-05T15:17:42.190Z",
//                     "updatedAt": "2024-05-05T15:17:42.190Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 438,
//                     "meetingRoom": {
//                         "id": 438,
//                         "createdAt": "2024-05-05T15:17:42.182Z",
//                         "updatedAt": "2024-05-05T15:17:42.182Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:18:00Z",
//                         "meeting_room_id": "2024-05-05T22:18:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2265,
//             "createdAt": "2024-05-05T15:19:16.760Z",
//             "updatedAt": "2024-05-05T15:19:16.760Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3842,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3842,
//                 "createdAt": "2024-05-05T15:19:16.754Z",
//                 "updatedAt": "2024-05-05T15:19:16.754Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 404,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 404,
//                     "createdAt": "2024-05-05T15:19:16.746Z",
//                     "updatedAt": "2024-05-05T15:19:16.746Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 440,
//                     "meetingRoom": {
//                         "id": 440,
//                         "createdAt": "2024-05-05T15:19:16.742Z",
//                         "updatedAt": "2024-05-05T15:19:16.742Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:20:00Z",
//                         "meeting_room_id": "2024-05-05T22:20:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2266,
//             "createdAt": "2024-05-05T15:20:08.919Z",
//             "updatedAt": "2024-05-05T15:20:08.919Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3843,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3843,
//                 "createdAt": "2024-05-05T15:20:08.910Z",
//                 "updatedAt": "2024-05-05T15:20:08.910Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 405,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 405,
//                     "createdAt": "2024-05-05T15:20:08.902Z",
//                     "updatedAt": "2024-05-05T15:20:08.902Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 441,
//                     "meetingRoom": {
//                         "id": 441,
//                         "createdAt": "2024-05-05T15:20:08.896Z",
//                         "updatedAt": "2024-05-05T15:20:08.896Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:21:00Z",
//                         "meeting_room_id": "2024-05-05T22:21:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2270,
//             "createdAt": "2024-05-05T15:22:58.154Z",
//             "updatedAt": "2024-05-05T15:22:58.154Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3847,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3847,
//                 "createdAt": "2024-05-05T15:22:58.148Z",
//                 "updatedAt": "2024-05-05T15:22:58.148Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 408,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 408,
//                     "createdAt": "2024-05-05T15:22:58.140Z",
//                     "updatedAt": "2024-05-05T15:22:58.140Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 446,
//                     "meetingRoom": {
//                         "id": 446,
//                         "createdAt": "2024-05-05T15:22:58.135Z",
//                         "updatedAt": "2024-05-05T15:22:58.135Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:23:00Z",
//                         "meeting_room_id": "2024-05-05T22:23:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2271,
//             "createdAt": "2024-05-05T15:23:28.411Z",
//             "updatedAt": "2024-05-05T15:23:28.411Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3848,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3848,
//                 "createdAt": "2024-05-05T15:23:28.407Z",
//                 "updatedAt": "2024-05-05T15:23:28.407Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 409,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 409,
//                     "createdAt": "2024-05-05T15:23:28.402Z",
//                     "updatedAt": "2024-05-05T15:23:28.402Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 447,
//                     "meetingRoom": {
//                         "id": 447,
//                         "createdAt": "2024-05-05T15:23:28.398Z",
//                         "updatedAt": "2024-05-05T15:23:28.398Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:24:00Z",
//                         "meeting_room_id": "2024-05-05T22:24:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2274,
//             "createdAt": "2024-05-05T15:26:37.146Z",
//             "updatedAt": "2024-05-05T15:26:37.146Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3851,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3851,
//                 "createdAt": "2024-05-05T15:26:37.139Z",
//                 "updatedAt": "2024-05-05T15:26:37.139Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 412,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 412,
//                     "createdAt": "2024-05-05T15:26:37.133Z",
//                     "updatedAt": "2024-05-05T15:26:37.133Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 451,
//                     "meetingRoom": {
//                         "id": 451,
//                         "createdAt": "2024-05-05T15:26:37.129Z",
//                         "updatedAt": "2024-05-05T15:26:37.129Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T22:27:00Z",
//                         "meeting_room_id": "2024-05-05T22:27:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         },
//         {
//             "id": 2309,
//             "createdAt": "2024-05-05T16:07:21.817Z",
//             "updatedAt": "2024-05-05T16:07:21.817Z",
//             "deletedAt": null,
//             "receiverId": 25,
//             "senderId": 267,
//             "messageId": 3886,
//             "title": "interview",
//             "notifyFlag": "0",
//             "typeNotifyFlag": "1",
//             "proposalId": null,
//             "content": "Interview created",
//             "message": {
//                 "id": 3886,
//                 "createdAt": "2024-05-05T16:07:21.812Z",
//                 "updatedAt": "2024-05-05T16:07:21.812Z",
//                 "deletedAt": null,
//                 "senderId": 267,
//                 "receiverId": 25,
//                 "projectId": 436,
//                 "interviewId": 431,
//                 "content": "showInterview",
//                 "messageFlag": 1,
//                 "interview": {
//                     "id": 431,
//                     "createdAt": "2024-05-05T16:07:21.807Z",
//                     "updatedAt": "2024-05-05T16:07:21.807Z",
//                     "deletedAt": null,
//                     "title": "interview",
//                     "startTime": "2024-05-10T13:00:00.000Z",
//                     "endTime": "2024-04-27T15:00:00.000Z",
//                     "disableFlag": 0,
//                     "meetingRoomId": 475,
//                     "meetingRoom": {
//                         "id": 475,
//                         "createdAt": "2024-05-05T16:07:21.802Z",
//                         "updatedAt": "2024-05-05T16:07:21.802Z",
//                         "deletedAt": null,
//                         "meeting_room_code": "2024-05-05T23:08:00Z",
//                         "meeting_room_id": "2024-05-05T23:08:00Z",
//                         "expired_at": "2024-04-27T15:00:00.000Z"
//                     }
//                 }
//             },
//             "sender": {
//                 "id": 267,
//                 "email": "doanvannghi2002+1@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "receiver": {
//                 "id": 25,
//                 "email": "doanvannghi2002@gmail.com",
//                 "fullname": "Van Nghi"
//             },
//             "proposal": null
//         }
//     ]
// }
