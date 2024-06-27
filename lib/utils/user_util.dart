import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/login/companyregister_screen.dart';
import 'package:student_hub/screens/profile_student_step1_screen.dart';


class UserUtil {
  static void switchToCreateProfile(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    // handle company role
    if (user!.priorityRole == EnumUser.company && user.company == null) {
      // NavigationUtil.toCompanyRegisterScreen(context);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context)=> const CompanyRegisterScreen()));
      return;
    }

    // handle student role
    if (user.priorityRole == EnumUser.student && user.student == null) {
      // NavigationUtil.toProfileStudentStep1Screen(context);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context)=> const ProfileStudentStep1Screen()));
      return;
    }
  }
}
