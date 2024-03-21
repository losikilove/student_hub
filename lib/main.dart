import 'package:flutter/material.dart';
import 'package:student_hub/screens/browse_project_detail_screen.dart';
import 'package:student_hub/screens/content_body/main_screen/message_body.dart';
import 'package:student_hub/screens/home_screen.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/screens/companyprofile_screen.dart';
import 'package:student_hub/screens/message_detail_screen.dart';
import 'package:student_hub/screens/profile_student_step1_screen.dart';
import 'package:student_hub/screens/profile_student_step2_screen.dart';
import 'package:student_hub/screens/project_post_step2_screen.dart';
import 'package:student_hub/screens/proposal_hire_offer_screen.dart';
import 'package:student_hub/screens/registration_two_company_screen.dart';
import 'package:student_hub/screens/registration_two_student_screen.dart';
import 'package:student_hub/screens/settings_screen.dart';
import 'package:student_hub/screens/signupsetup1_screen.dart';
import 'package:student_hub/screens/switch_account_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessageDetailScreen(),
    ),
  );
}
