import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/content_body/main_screen/dashboard_body/dashboard_company.dart';
import 'package:student_hub/screens/content_body/main_screen/dashboard_body/dashboard_student.dart';
import 'package:student_hub/utils/navigation_util.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBody();
}

class _DashboardBody extends State<DashboardBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed:(){
          NavigationUtil.toSwitchAccountScreen(context);
        },
        currentContext: context,
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, _) {
        return userProvider.user!.priorityRole == EnumUser.student
            ? const DashboardStudent()
            : const DashboardCompany();
      }),
    );
  }
}
