import 'package:flutter/material.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/screens/companyprofile_screen.dart';
import 'package:student_hub/screens/profile_student_step1.dart';
import 'package:student_hub/screens/registration_two_company_screen.dart';
import 'package:student_hub/screens/registration_two_student_screen.dart';
import 'package:student_hub/screens/signupsetup1_screen.dart';
import 'package:student_hub/screens/switch_account_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SwitchAccountScreen(),
  ));
}
