import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/components/custom_listtile.dart';

class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});

  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreen();
}

class _SwitchAccountScreen extends State<SwitchAccountScreen> {
  EnumUser _selectedAccount = EnumUser.student;
  final String name = 'Hai Pham';

  void onPressed() {}

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
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  // Toggle the expansion state
                  _selectedAccount =
                      isExpanded ? EnumUser.company : EnumUser.student;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      leading: Icon(Icons.person, size: 50),
                      title: CustomText(
                        text: name,
                        isBold: true,
                      ),
                      subtitle: CustomText(text: 'Company'),
                      onTap: onPressed,
                    );
                  },
                  body: ListTile(
                    leading: Icon(Icons.person, size: 50),
                    title: CustomText(
                      text: name,
                      isBold: true,
                    ),
                    subtitle: CustomText(text: 'Student'),
                    contentPadding: EdgeInsets.only(left: 30),
                    onTap: onPressed,
                  ),
                  backgroundColor: ColorUtil.lightPrimary,
                  isExpanded: _selectedAccount == EnumUser.company,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Column(
                children: [
                  CustomListTitle(
                    icon: Icons.person_2_outlined,
                    text: 'Profile',
                    onTap: onPressed,
                    subtext: null,
                  ),
                  CustomListTitle(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                    onTap: onPressed,
                    subtext: null,
                  ),
                  CustomListTitle(
                    icon: Icons.logout_outlined,
                    text: 'Logout',
                    onTap: onPressed,
                    subtext: null,
                  ),
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
