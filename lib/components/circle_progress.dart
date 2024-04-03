import 'package:flutter/material.dart';

Future<void> showCircleProgress({required BuildContext context}) => showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
