import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/utils/navigation_util.dart';

enum NotificationType {
  error(message: 'Error', color: Colors.red),
  warning(message: 'Warning', color: Colors.yellow),
  success(message: 'Success', color: Colors.green);

  final String message;
  final Color color;

  const NotificationType({required this.message, required this.color});
}

Future<void> popupNotification(
        {required BuildContext context,
        required NotificationType type,
        required String content,
        required String textSubmit,
        required void Function()? submit}) =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title of popup
            title: Text(
              type.message,
              style: TextStyle(
                color: type.color,
              ),
            ),
            // content of popup
            content: CustomText(
              text: content,
            ),
            // buttons
            actions: <Widget>[
              // cancel button
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  NavigationUtil.turnBack(context);
                },
              ),
              // submit button
              submit == null
                  // back to previous screen
                  ? CustomButton(
                      onPressed: () {
                        NavigationUtil.turnBack(context);
                      },
                      text: textSubmit)
                  // another button
                  : CustomButton(onPressed: submit, text: textSubmit),
            ],
          );
        });
