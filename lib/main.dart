import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/l10n/l10n.dart';
import 'package:student_hub/providers/langue_provider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/signin_screen.dart';
import 'package:student_hub/providers/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context)=> LanguageProvider())
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: Locale(Provider.of<LanguageProvider>(context).languageCode),
      home: const SignInScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
