import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/color_util.dart';

enum AccountType { company, student }

class ExpansionPanelExample extends StatefulWidget {
  const ExpansionPanelExample({super.key});

  @override
  _ExpansionPanelExampleState createState() => _ExpansionPanelExampleState();
}

class _ExpansionPanelExampleState extends State<ExpansionPanelExample> {
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
                    return ListTile(
                      leading: Icon(Icons.person, size: 50),
                      title: Text('Hai Pham company'),
                      
                    );
                  },
                  body: ListTile(
                      leading: Icon(Icons.person, size: 50),
                      title: Text('Hai Pham student'),
                      contentPadding: EdgeInsets.only(left: 40),
                      onTap: onPressed,
                  ),
                  backgroundColor: ColorUtil.lightPrimary,
                  
                  isExpanded: _selectedAccount == AccountType.company,
                ),
              ],
              
            ),
            ListTile(
              leading: Icon(Icons.person_2_outlined, size: 50),
              title: Text('Profile'),
              onTap: onPressed,

            ),
            ListTile(
              leading: Icon(Icons.settings_outlined, size: 50),
              title: Text('Settings'),
              onTap: onPressed,
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined, size: 50),
              title: Text('Logout'),
              onTap: onPressed,
            ),
            // Your other widgets can go here
          ],
        ),

      ),
    );
  }
}
