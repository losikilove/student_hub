import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/navigation_util.dart';

class UserUtil {
  static void switchToCreateProfile(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    // handle company role
    if (user!.priorityRole == EnumUser.company && user.company == null) {
      NavigationUtil.toCompanyRegisterScreen(context);
      return;
    }

    // handle student role
    if (user.priorityRole == EnumUser.student && user.student == null) {
      NavigationUtil.toProfileStudentStep1Screen(context);
      return;
    }
  }
}
