import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingScreen extends StatefulWidget {
  final String anotherUserName;
  final String currentUserId;
  final String currentUserName;
  final String meetingRoom;
  final String meetingId;
  const MeetingScreen({
    super.key,
    required this.anotherUserName,
    required this.currentUserId,
    required this.currentUserName,
    required this.meetingRoom,
    required this.meetingId,
  });

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
        title: widget.anotherUserName,
        isBack: true,
      ),
      body: SafeArea(
        child: ZegoUIKitPrebuiltVideoConference(
          appID: 1291705273,
          appSign:
              'd51929e609d4b72836877cfc070a2c496c6c5d86cbcbf96a7d7c9cefdbb03309',
          conferenceID: widget.meetingId,
          userID: widget.currentUserId.toString(),
          userName: widget.currentUserName,
          config: ZegoUIKitPrebuiltVideoConferenceConfig(),
        ),
      ),
    );
  }
}
