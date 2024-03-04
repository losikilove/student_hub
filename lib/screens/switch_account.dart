import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/initial_body_SwitchAccount.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/components/custom_listtile.dart';

enum AccountType { company, student }

class SwitchAccount extends StatefulWidget {
  const SwitchAccount({super.key});

  @override
  State<SwitchAccount> createState() => _SwitchAccount();
}

class _SwitchAccount extends State<SwitchAccount> {
  AccountType _selectedAccount = AccountType.student;

  void onPressed(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        iconButton: Icons.search,
      ),
      body: InitialBody(
        child: Column(
          children: <Widget>[
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  // Toggle the expansion state
                  _selectedAccount = isExpanded ? AccountType.company : AccountType.student;
                });
              },
              children: [
                
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return CustomListTitle(
                      icon: Icons.person,
                      text: 'Hai Pham',
                      onTap: onPressed,
                      subtext: 'Hai Pham company',
                    );
                  },
                  body: ListTile(
                    leading: Icon(Icons.person, size: 50),
                    title: Text('Hai Pham', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Hai Pham student'),
                    contentPadding: EdgeInsets.only(left: 30),
                    onTap: onPressed,
                  ),
                                 
                  isExpanded: _selectedAccount == AccountType.company,
                ),
              ],
              
            ),
            CustomListTitle(
              icon: Icons.person_2_outlined,
              text: 'Profile',
              onTap: onPressed,
              subtext: null,
            ),
            CustomListTitle(
              icon:Icons.settings_outlined,
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
            // Your other widgets can go here
          ],
        ),

      ),
    );
  }
}
