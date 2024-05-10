import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_type_notify_flag.dart';
import 'package:student_hub/models/notification_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/notification_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/utils/api_util.dart';
class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBody();
}

class _NotificationBody extends State<NotificationBody> {
  // switch to switch account screen
  void onSwitchedToSwitchAccountScreen() {
    NavigationUtil.toSwitchAccountScreen(context);
  }
  String currentUserId = "";
  String currentUserName = "";
   final socket = IO.io(
    ApiUtil.websocketUrl,
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );
  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
 
    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer ${userProvider.token}',
    };
     socket.onConnect((data) => {
          print('Connected'),
        });

    socket.onConnectError(
        (data) => print('Error connection: ${data.toString()}'));
    socket.onError((data) => print('Error connection: ${data.toString()}'));
    socket.on('NOTI_${userProvider.user!.userId}', (data) {
      if (data['notification']['typeNotifyFlag'] == EnumTypeNotifyFlag.Chat.value) {
        popupNotification(
          context: context,
          type: NotificationType.success, 
          content: "You have a new message", 
          textSubmit: "Ok", 
          submit: null
        );
      } else if (data['notification']['typeNotifyFlag'] == EnumTypeNotifyFlag.Interview.value) {
        popupNotification(
          context: context,
          type: NotificationType.success, 
          content: "You have a new intervỉew invitation", 
          textSubmit: "Ok", 
          submit: null
        );
      } else if (data['notification']['typeNotifyFlag'] == EnumTypeNotifyFlag.Offer.value) {
        popupNotification(
          context: context,
          type: NotificationType.success, 
          content: "You have a new offer to join project", 
          textSubmit: "Ok", 
          submit: null
        );
      } else if (data['notification']['typeNotifyFlag'] == EnumTypeNotifyFlag.Submitted.value) {
        popupNotification(
          context: context,
          type: NotificationType.success, 
          content: "You have been submitted to join project", 
          textSubmit: "Ok", 
          submit: null
        );
      }

    });

    //Listen for error from socket
    socket.on("ERROR", (data) => print('Error: ${data}'));
  }
  
  Stream<List<NotificationModel>> streamNotifications() async* {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    String? token = userProvider.token;
    String receiverId = userProvider.user!.userId.toString();
    currentUserId = userProvider.user!.userId.toString();
    currentUserName = userProvider.user!.fullname;
    while (true) {
      final response = await NotificationService.getNotification(receiverId: receiverId, token: token!);
      yield NotificationModel.fromResponse(response);
    
      await Future.delayed(const Duration(seconds: 6)); 
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onSwitchedToSwitchAccountScreen,
        currentContext: context,
      ),
      body: InitialBody(
          child: StreamBuilder(
            stream: streamNotifications(), 
            builder: (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }else if (snapshot.hasError){
                  return CustomText(
                    text: snapshot.error.toString(),
                    textColor: Colors.red,
                  );
                }
                else if (snapshot.hasData){
                  List<NotificationModel> list = snapshot.data!;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context,index){
                      NotificationModel notification = list[index];
                      if (notification.typeNotifyFlag == EnumTypeNotifyFlag.Interview.value ){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_offer_rounded,size: 17,color: Theme.of(context).colorScheme.onPrimary),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text:"You have invited to interview project: ${notification.title} at ${DateFormat('dd-MM-yyyy').format(DateTime.parse(notification.message.interview!.startTime),)}",size: 18,),
                                    const SizedBox(
                                      height: SpacingUtil.smallHeight,
                                    ),
                                    CustomText(text:"Time: ${DateFormat('hh:mm').format(DateTime.parse(notification.message.interview!.startTime),)} - ${DateFormat('hh:mm').format(DateTime.parse(notification.message.interview!.endTime),)}",size: 16,),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: SpacingUtil.smallHeight,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButton(onPressed: (){
                                NavigationUtil.toJoinMeetingScreen(context, 
                                notification.sender.fullname, 
                                currentUserId, 
                                currentUserName, 
                                notification.message.interview!.meetingInterview!.meetingRoomId, 
                                notification.message.interview!.meetingInterview!.meetingRoomId);
                              }, text: "Join"),
                              const SizedBox(
                                width: SpacingUtil.largeHeight,
                              ),                      
                            ],
                          ),
                          const CustomDivider()
                        ]
                      );
                    }
                  else if(notification.typeNotifyFlag == EnumTypeNotifyFlag.Submitted.value ){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle_rounded,size: 17,color:Theme.of(context).colorScheme.onPrimary),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text:"You have submitted to join project: ${notification.title}",size: 18,),
                                  const SizedBox(
                                    height: SpacingUtil.smallHeight,
                                  ),
                                  CustomText(text:DateFormat('dd-MM-yyyy').format(DateTime.parse(notification.createdAt),),size: 16,),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const CustomDivider(),
                      ],
                    );
                  }
                  else if(notification.typeNotifyFlag == EnumTypeNotifyFlag.Offer.value ){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.handshake_outlined,size: 17,color:Theme.of(context).colorScheme.onPrimary),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text:"You have offer to join project: ${notification.title}",size: 18,),
                                  const SizedBox(
                                    height: SpacingUtil.smallHeight,
                                  ),
                                  CustomText(text:DateFormat('dd-MM-yyyy').format(DateTime.parse(notification.createdAt),),size: 16,),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: SpacingUtil.mediumHeight,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(onPressed: (){}, text: "View offer"),
                            const SizedBox(
                              width: SpacingUtil.largeHeight,
                            ),
                           
                          ],
                        ),
                        const CustomDivider(),
                      ],
                    );
                  }
                  else if (notification.typeNotifyFlag == EnumTypeNotifyFlag.Chat.value ){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Row(
                              children: [
                                Icon(Icons.message_rounded,size: 17,color:Theme.of(context).colorScheme.onPrimary,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(text:"Sender: ${notification.sender.fullname}",size: 18,),
                                      const SizedBox(
                                        height: SpacingUtil.smallHeight,
                                      ),
                              
                                      CustomText(text: "Content: ${notification.message.content}",isBold: true,),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomText(text:"Created at ${DateFormat('dd-MM-yyyy').format(DateTime.parse(notification.createdAt),)}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        const CustomDivider(),
                      ],
                    );
                  }
                    }, 
                  );
                }
                else{
                  return const CustomText(text: "No notification found!",size: 19,);
                }
              
  
            }
          ),
        )
    );
  }
}