
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({super.key});
  
  @override
  State<Dashboard> createState() => _Dashboard();
}
void onPressed(){}

class _Dashboard extends State<Dashboard>{

  final name = 'Hai';
  int _selectedIndex = 0;
  static const TextStyle optionStyle = 
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Project',
      style: optionStyle,
    ),
    Center(
      child: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          InitialBody(
            child: Row(
              children: [
                Text('Yours job',),
                const SizedBox(width: 180,),
                CustomButton(onPressed: onPressed, text: 'Post a job')
              ],
            ),
          ),
          SizedBox( height: SpacingUtil.largeHeight,),
          Center(
            child: CustomText(text: 'Welcome, Hai!'),
          ),
          SizedBox( height: SpacingUtil.smallHeight,),
          Center(
            child: CustomText(text: 'You have no jobs!'),
          )
        ],
      ),
    ),
    Text(
      'Index 2: Message',
      style: optionStyle,
    ),
    Text(
      'Index 3: Alert',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
        
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Arlets',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 52, 145, 231),
        onTap: _onItemTapped,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      
    );

  }
}