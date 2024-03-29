import 'package:flutter/material.dart';
import 'package:student_hub/screens/browse_project_detail_screen.dart';
import 'package:student_hub/screens/companyprofile_screen.dart';
import 'package:student_hub/screens/companyregister_screen.dart';
import 'package:student_hub/screens/home_screen.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/screens/meeting_screen.dart';
import 'package:student_hub/screens/message_detail_screen.dart';
import 'package:student_hub/screens/profile_student_step1_screen.dart';
import 'package:student_hub/screens/profile_student_step2_screen.dart';
import 'package:student_hub/screens/profile_student_step3_screen.dart';
import 'package:student_hub/screens/project_post_step1_screen.dart';
import 'package:student_hub/screens/project_post_step2_screen.dart';
import 'package:student_hub/screens/project_post_step3_screen.dart';
import 'package:student_hub/screens/project_post_step4_screen.dart';
import 'package:student_hub/screens/proposal_hire_offer_screen.dart';
import 'package:student_hub/screens/registration_two_company_screen.dart';
import 'package:student_hub/screens/registration_two_student_screen.dart';
import 'package:student_hub/screens/signin_screen.dart';
import 'package:student_hub/screens/signupsetup1_screen.dart';
import 'package:student_hub/screens/student_submit_proposal_screen.dart';
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

  // switch to profile student step 1 screen
  static void toProfileStudentStep1Screen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProfileStudentStep1Screen(),
      ),
    );
  }

  // switch to profile student step 2 screen
  static void toProfileStudentStep2Screen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProfileStudentStep2Screen(),
      ),
    );
  }

  // switch to profile student step 3 screen
  static void toProfileStudentStep3Screen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProfileStudentStep3Screen(),
      ),
    );
  }

  // switch to main screen
  static void toMainScreen(
      BuildContext currentContext, MainScreenIndex contentBody) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          contentBody: contentBody,
        ),
      ),
    );
  }

  // switch to project-post-step1 screen
  static void toProjectPostStep1Screen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep1Screen(),
      ),
    );
  }

  // switch to project-post-step2 screen
  static void toProjectPostStep2Screen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep2Screen(),
      ),
    );
  }

  // switch to project-post-step3 screen
  static void toProjectPostStep3Screen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep3Screen(),
      ),
    );
  }

  // switch to project-post-step4 screen
  static void toProjectPostStep4Screen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep4Screen(),
      ),
    );
  }

  // switch to browse-project-detail screen
  static void toBrowseProjectDetailScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const BrowseProjectDetailScreen(),
      ),
    );
  }

  // switch to proposal-hire-offer screen
  static void toProposalHireOfferScreen(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProposalHireOfferScreen(),
      ),
    );
  }

  //post a job
  static void toPostProjectStep1(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep1Screen(),
      ),
    );
  }

  static void toPostProjectStep2(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep2Screen(),
      ),
    );
  }

  static void toPostProjectStep3(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep3Screen(),
      ),
    );
  }

  static void toPostProjectStep4(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(
        builder: (context) => const ProjectPostStep4Screen(),
      ),
    );
  }

  //Manage project flow
  static void toSendHireOffer(BuildContext currentContext) {
    Navigator.push(
      currentContext,
      MaterialPageRoute(builder: (context) => const ProposalHireOfferScreen()),
    );
  }

  //Student submit proposal
  static void toSubmitProposal(BuildContext currentContext) {
    Navigator.push(
        currentContext,
        MaterialPageRoute(
            builder: (context) => const StudentSubmitProposalScreen()));
  }

  //Chat
  static void toMessageDetail(BuildContext currentContext) {
    Navigator.push(currentContext,
        MaterialPageRoute(
          builder: (context) => const MessageDetailScreen()));
  }
  static void toJoinMeetingScreen(BuildContext currentContext){
    Navigator.push(currentContext,
      MaterialPageRoute(builder: (context) => const MeetingScreen(),));
  }
}
