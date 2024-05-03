import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/enums/enum_type_notify_flag.dart';
import 'package:student_hub/models/notification_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/notification_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:intl/intl.dart';
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

  Future<List<NotificationModel>> initializeNotifications() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    String? token = userProvider.token;
    String receiverId = userProvider.user!.userId.toString();
    // get all notifications
    final response = await NotificationService.getNotification(
        receiverId: receiverId, token: token!);
    return NotificationModel.fromResponse(response);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onSwitchedToSwitchAccountScreen,
        currentContext: context,
      ),
      body: InitialBody(
          child: CustomFutureBuilder(
            future: initializeNotifications(), 
            widgetWithData: (snapshot){
              List<NotificationModel> list = snapshot.data as List<NotificationModel>;
              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context,index){
                    NotificationModel notification = list[index];
                     
                      if (notification.typeNotifyFlag == EnumTypeNotifyFlag.Interview.value ){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
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
                                  CustomText(text:"You have invited to interview project: ${notification.title} at ${DateFormat('dd-MM-yyyy').format(DateTime.parse(notification.interview!.startTime),)}",size: 18,),
                                  const SizedBox(
                                    height: SpacingUtil.smallHeight,
                                  ),
                                  CustomText(text:"Time: ${DateFormat('hh:mm').format(DateTime.parse(notification.interview!.startTime),)} - ${DateFormat('hh:mm').format(DateTime.parse(notification.interview!.endTime),)}",size: 16,),
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
                            CustomButton(onPressed: (){}, text: "Join"),
                            const SizedBox(
                              width: SpacingUtil.largeHeight,
                            ),
                           
                          ],
                        ),
                        const CustomDivider(),      
                      ],
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
                              
                                      CustomText(text: "Content: ${notification.content}",isBold: true,),
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
                }
              );
            },
            
            widgetWithError: (snapshot) {
                return CustomText(
                  text: snapshot.error.toString(),
                  textColor: Colors.red,
                );
              },
          )
        ),
    );
  }
}

