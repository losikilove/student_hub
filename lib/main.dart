import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/change_password_screen.dart';
import 'package:student_hub/screens/signin_screen.dart';
import 'package:student_hub/providers/theme_provider.dart';
import 'package:student_hub/screens/switch_account_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const StudentHubApp(),
    ),
  );
}

class StudentHubApp extends StatelessWidget {
  const StudentHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignInScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
