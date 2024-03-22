
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/utils/spacing_util.dart';
const appId = '';
const token = '0066e9b192579ef490f92f9ec510d093746IABCEjOJopDj3EGGEWuzXAIOubp5vr/YXL4+9mMQRiEj1npKVfgAAAAAEABt1X4ozpv9ZQEAAQBeWPxl';
const channel ='';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final AgoraClient client = AgoraClient( 
    agoraConnectionData: AgoraConnectionData( 
      appId: "6e9b192579ef490f92f9ec510d093746", 
      channelName: "vannghi", 
      tempToken: token,
      uid: 0,
      rtmEnabled: true,
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
  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: (){},
        currentContext: context,
        title: 'Luis',
      ),

      body: SafeArea( 
        child: Column( 
          children: [
            Center(
              child: Icon(Icons.people, size: 300,),
            ),
            SizedBox(height: SpacingUtil.largeHeight,),
            Center(
              child: Icon(Icons.people, size: 300,),
            ),
            SizedBox(height: SpacingUtil.largeHeight,),
            AgoraVideoButtons(client: client,
            enabledButtons: [
              BuiltInButtons.callEnd,
              BuiltInButtons.toggleCamera,
              BuiltInButtons.toggleMic],), 
          ], 
        ),
      ) 
    );
  }

}