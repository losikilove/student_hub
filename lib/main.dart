import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/screens/companyregister_screen.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/screens/message_detail_screen.dart';
import 'package:student_hub/screens/welcome_screen.dart';
import 'package:student_hub/theme/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
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
      home: const MainScreen(contentBody: MainScreenIndex.project),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
