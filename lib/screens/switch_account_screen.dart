import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/custom_listtile.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/navigation_util.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreen();
}

class _SwitchAccountScreen extends State<SwitchAccountScreen> {
  final String name = 'Hai Pham';

  void onPressed() {}

  // switch to company-register-screen
  void onSwitchedToProfileScreen() {
    NavigationUtil.toCompanyRegisterScreen(context);
  }

  // switch to setting screen
  void onSwitchedToSettingScreen() {
    NavigationUtil.toSettingScreen(context);
  }

  // switch to sign in screen
  void onLogout() async {
    // expire token
    final token = Provider.of<UserProvider>(context, listen: false).token;
    await AuthService.signout(token: token!, context: context);

    NavigationUtil.toSignInScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        iconButton: Icons.search,
      ),
      body: InitialBody(
        left: 0.0,
        right: 0.0,
        top: 0.0,
        child: Column(
          children: <Widget>[
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  '$name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text('Company'),
                children: <Widget>[
                  CustomDivider(),
                  ListTile(
                    title: Text('$name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Text('Student'),
                    contentPadding: EdgeInsets.only(left: 30),
                  )
                ],
              ),
            ),
            Divider(
              height: 20,
              thickness: 2,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
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
                  CustomDivider(),
                  CustomListTitle(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                    onTap: onSwitchedToSettingScreen,
                    subtext: null,
                  ),
                  CustomDivider(),
                  CustomListTitle(
                    icon: Icons.logout_outlined,
                    text: 'Logout',
                    onTap: onLogout,
                    subtext: null,
                  ),
                  CustomDivider(),
                ],
              ),
            ),
            // Your other widgets can go here
          ],
        ),
      ),
    );
  }
}
