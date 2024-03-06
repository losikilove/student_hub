import 'package:flutter/material.dart';
import 'package:student_hub/screens/companyprofile_screen.dart';
import 'package:student_hub/screens/companyregister_screen.dart';
import 'package:student_hub/screens/home_screen.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/screens/registration_two_company_screen.dart';
import 'package:student_hub/screens/registration_two_student_screen.dart';
import 'package:student_hub/screens/signin_screen.dart';
import 'package:student_hub/screens/signupsetup1_screen.dart';
import 'package:student_hub/screens/switch_account_screen.dart';
import 'package:student_hub/screens/welcome_screen.dart';

class NavigationUtil {
  // back to previous screen
  static void turnBack(BuildContext currentContext) {
    if (Navigator.canPop(currentContext)) {
      Navigator.pop(currentContext);
    }
  }

  // switch to home screen
  static void toHomeScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  // switch to sign-in screen
  static void toSignInScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  // switch to sign-up-step1 screen
  static void toSignUpStepOneScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(builder: (context) => const SignUpSetup1Screen()),
    );
  }

  // switch to sign-up-step2-as-company screen
  static void toSignUpStepTwoAsCompanyScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
          builder: (context) => const RegistrationTwoCompanyScreen()),
    );
  }

  // switch to sign-up-step2-as-student screen
  static void toSignUpStepTwoAsStudentScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
          builder: (context) => const RegistrationTwoStudentScreen()),
    );
  }

  // switch to switch-account screen
  static void toSwitchAccountScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const SwitchAccountScreen(),
      ),
    );
  }

  // switch to profile input a.k.a company-profile screen
  static void toCompanyProfileScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const CompanyProfileScreen(),
      ),
    );
  }

  // switch to profile input a.k.a company-register scren
  static void toCompanyRegisterScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const CompanyRegisterScreen(),
      ),
    );
  }

  // switch to welcome screen
  static void toWelcomeScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  // switch to main screen
  static void toMainScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }
}
