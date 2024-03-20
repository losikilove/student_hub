import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBody();
}

class _NotificationBody extends State<NotificationBody> {
  void onPressed() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed, 
        currentContext: context
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.accessibility_new_rounded,size: 35,),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "You have submitted to join project 'Jarvis-AI Copilot'",
                        isBold: true,
                      ),
                      SizedBox(height: 12,),
                      CustomText(text: '6/6/2024')
                    ],
                  ),
                )
              ],
            ),
            CustomDivider(),
            Row(
              children: [
                Icon(Icons.settings_outlined,size: 35,),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "You have invited to interview for project 'Jarvis-AI Copilot' at 14:00 March 20, Thursday",
                        isBold: true,
                      ),
                      SizedBox(height: 12,),
                      CustomText(text: '6/6/2024'),
                      SizedBox(height: 12,),
                      CustomButton(onPressed: (){}, text: "Join")
                    ],
                  ),
                ),
              ],
            ),
            CustomDivider(),
            Row(
              children: [
                Icon(Icons.settings_outlined,size: 35,),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "You have offered to join project 'Jarvis-AI Copilot'",
                      isBold: true,
                    ),
                      SizedBox(height: 12,),
                      CustomText(text: '6/6/2024'),
                      SizedBox(height: 12,),
                      CustomButton(onPressed: (){}, text: "View offer")
                    ],
                  ),
                ),
              ],
            ),
            CustomDivider(),
            Row(
              children: [
                Icon(Icons.accessibility_new_rounded,size:35),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Alex Jor",isBold: true,),
                      SizedBox(height: 12,),
                      CustomText(text: 'How are you doing ?'),
                      SizedBox(height: 12,),
                      CustomText(text: '6/6/2024'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
