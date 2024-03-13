import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/initial_body.dart';

class MessageBody extends StatefulWidget {
  const MessageBody({super.key});

  @override
  State<MessageBody> createState() => _MessageBody();
}

class _MessageBody extends State<MessageBody> {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(child: Center()),
    );
  }
}
