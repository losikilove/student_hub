import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/custom_listtile.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/screens/signin_screen.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/user_util.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreen();
}

class _SwitchAccountScreen extends State<SwitchAccountScreen> {
  final ExpansionTileController _switchProfileController =
      ExpansionTileController();

  // switch to main screen
  void onSwitchedToMainScreen() {
    NavigationUtil.toMainScreen(context, MainScreenIndex.dashboard);
  }

  // switch profile
  Future<void> onSwitchedProfile() async {
    // confirm that user want to switch profile
    final isConfirmed = await _showDialogConfirmSwitchProfile();

    // user do not want to switch profile
    if (isConfirmed == null || isConfirmed == false) {
      return;
    }

    // change priority role when switched profile
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.changeToRestRole();

    // collapse the expanded profile after switch profile successfully
    if (_switchProfileController.isExpanded) {
      setState(() {
        _switchProfileController.collapse();
      });
    }

    // if priority (current) role have no profile, create user profile
    if (userProvider.user!.isNullPriorityRole() == true) {
      await popupNotification(
        context: context,
        type: NotificationType.warning,
        content:
            'Your ${userProvider.user!.priorityRole.name} role have no profile. Let\'s go to create a profile.',
        textSubmit: 'Ok',
        submit: null,
      );

      UserUtil.switchToCreateProfile(context);
    }
  }

  // switch to company-register-screen
  void onSwitchedToProfileScreen() {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    // if have info of user, switch to view profile:
    // switch to view-company-profile
    if (user?.priorityRole == EnumUser.company && user?.company != null) {
      NavigationUtil.toCompanyViewProfileScreen(context);
      return;
    }

    // switch to view-student-profile
    if (user?.priorityRole == EnumUser.student && user?.student != null) {
      NavigationUtil.toStudentViewProfileScreen(context);
      return;
    }

    // else switch to create profile:
    UserUtil.switchToCreateProfile(context);
  }

  // switch to setting screen
  void onSwitchedToSettingScreen() {
    NavigationUtil.toSettingScreen(context);
  }

  // switch to sign in screen
  void onLogout() async {
    // confirm that logging out
    final isConfirmed = await _showDialogConfirmLogout();

    // do not want to log out
    if (isConfirmed == false || isConfirmed == null) {
      return;
    }

    // expire token
    Provider.of<UserProvider>(context, listen: false).signout();
    // back to sign in screen
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (BuildContext context)=> const SignInScreen()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onSwitchedToMainScreen,
        currentContext: context,
        iconButton: Icons.home_filled,
      ),
      body: InitialBody(
        left: 0.0,
        right: 0.0,
        top: 0.0,
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    controller: _switchProfileController,
                    title: Text(
                      userProvider.user?.fullname ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(userProvider.user?.priorityRole.name ?? ''),
                    children: <Widget>[
                      const CustomDivider(),
                      GestureDetector(
                        onTap: onSwitchedProfile,
                        child: ListTile(
                          title: Text(userProvider.user?.fullname ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          subtitle: Text(
                              '${userProvider.user?.getEnumRestRole.name ?? ''} ${(userProvider.user?.isNullRestRole() == true ? '- not active' : '')}'),
                          contentPadding: const EdgeInsets.only(left: 30),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            const CustomDivider(
              isFullWidth: true,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Column(
                children: [
                  CustomListTitle(
                    icon: Icons.person_2_outlined,
                    text: 'Profile',
                    onTap: onSwitchedToProfileScreen,
                    subtext: null,
                  ),
                  const CustomDivider(),
                  CustomListTitle(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                    onTap: onSwitchedToSettingScreen,
                    subtext: null,
                  ),
                  const CustomDivider(),
                  CustomListTitle(
                    icon: Icons.logout_outlined,
                    text: 'Logout',
                    onTap: onLogout,
                    subtext: null,
                  ),
                  const CustomDivider(),
                ],
              ),
            ),
            // Your other widgets can go here
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDialogConfirmLogout() => showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'WARNING',
            style: TextStyle(color: Colors.red),
          ),
          content: const CustomText(
            text: 'Are you sure to log out?',
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: 'Yes',
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: 'No',
            ),
          ],
        );
      });

  Future<bool?> _showDialogConfirmSwitchProfile() => showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'WARNING',
            style: TextStyle(color: Colors.red),
          ),
          content: const CustomText(
            text: 'Are you sure to switch profile?',
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: 'Yes',
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: 'No',
            ),
          ],
        );
      });
}
