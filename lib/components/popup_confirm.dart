import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';

Future<bool?> popupConfirm({
  required BuildContext context,
  required String content,
}) =>
    showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title of popup
            title: const Text(
              'WARNING',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            // content of popup
            content: CustomText(
              text: content,
            ),
            // buttons
            actions: <Widget>[
              // denied button
              CustomButton(
                onPressed: () => Navigator.of(context).pop(false),
                text: 'No',
              ),
              // agreed button
              CustomButton(
                onPressed: () => Navigator.of(context).pop(true),
                text: 'Yes',
                buttonColor: Theme.of(context).colorScheme.secondary,
              ),
            ],
          );
        });
