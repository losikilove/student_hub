import 'package:flutter/material.dart';
import 'package:student_hub/screens/meeting_screen.dart';
import 'package:student_hub/utils/api_meeting.dart';
import 'package:student_hub/utils/text_util.dart';

class JoinButton extends StatelessWidget{
  final void Function()? onPressed;
  final String id_room;
  const JoinButton({
    super.key,
    required this.onPressed,
    required this.id_room,
  });
  void onJoinButtonPressed(BuildContext context) {
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    // check meeting id is not null or invaild
    // if meeting id is vaild then navigate to MeetingScreen with meetingId,token
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MeetingScreen(
          meetingId: id_room,
          token: token,
        ),
      ),
    );

  }
  @override
  Widget build(BuildContext){
    return ElevatedButton(
      onPressed: onPressed, 
      child: Text(
        'join',
        style: TextStyle(
          fontSize: TextUtil.textSize,
        ),
      ));
  }
}