
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';

const appId  = '10d071544ef044f199f30a46de11a7e8';
const token = '007eJxTYDgRlP7tQ3z90V2XGaU3fT6fvD1Q+wHnFsG498EFUbdaVi9QYDBLtUwytDQyNbdMTTOxNEizNEqzTE02NTRIMbA0Njcxe870J7UhkJGh4tFsRkYGCATxORjKEvPy0jMyDRkYAIEwIxk=';
const channel = 'vannghi';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  int? _remoteUid;
  late RtcEngine _engine;
  bool _localUserJoined = false;

  final AgoraClient client = AgoraClient( 
  agoraConnectionData: AgoraConnectionData( 
    appId: "10d071544ef044f199f30a46de11a7e8", 
    channelName: "vannghi1", 
    tempToken: token, 
  ), 
  enabledPermission: [ 
    Permission.camera, 
    Permission.microphone, 
  ], 
);
  @override
  void initState(){
    super.initState();
    initForAgora();
    
  }

  void initForAgora() async { 
  await client.initialize(); 
} 
@override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: SafeArea( 
        child: Stack( 
          children: [ 
            AgoraVideoViewer(client: client),  
            AgoraVideoButtons(client: client), 
          ], 
        ),
      ) 
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}