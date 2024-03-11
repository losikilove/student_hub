import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';

class HireOfferScreen extends StatefulWidget {
  //TODO: get data of project

  const HireOfferScreen({super.key});

  @override
  State<HireOfferScreen> createState() => _HireOfferScreenState();
}

class _HireOfferScreenState extends State<HireOfferScreen> {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [CustomText(text: 'Title of project')],
        ),
      ),
    );
  }
}
