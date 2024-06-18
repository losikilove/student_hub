import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:quickalert/quickalert.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpSetup1Screen extends StatefulWidget {
  const SignUpSetup1Screen({super.key});

  @override
  State<SignUpSetup1Screen> createState() => _SignUpSetup1ScreenState();
}

class _SignUpSetup1ScreenState extends State<SignUpSetup1Screen> {
  EnumUser? _user = EnumUser.student;

  void chooseUserType(EnumUser? value) {
    setState(() {
      _user = value;
    });
  }

  // create account in next screen
  void onGoneToNextScreen() {
    // show notification
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: '${AppLocalizations.of(context)!.youreallyWantToRegisterAs} ${_user?.name.toUpperCase()}',
      confirmBtnText: AppLocalizations.of(context)!.yes,
      onConfirmBtnTap: () {
        if (_user == EnumUser.company) {
          NavigationUtil.toSignUpStepTwoAsCompanyScreen(context);
        } else if (_user == EnumUser.student) {
          NavigationUtil.toSignUpStepTwoAsStudentScreen(context);
        }
      },
    );
  }

  // back to sigin in screen
  void backToSigin() {
    NavigationUtil.toSignInScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            // Title text
            Center(
              child: CustomText(
                text: AppLocalizations.of(context)!.joinAsCompanyOrStudent,
                isBold: true,
                size: 20,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // Card of company introducing
            _cardChoice("assets/icons/company.png", EnumUser.company,
                AppLocalizations.of(context)!.iAmACompanyFindEngieerForProject),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            // Card of student introducing
            _cardChoice("assets/icons/student.png", EnumUser.student,
                AppLocalizations.of(context)!.iAmAStudentFindProject),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            CustomButton(
              onPressed: onGoneToNextScreen,
              text: 'Create account',
              size: CustomButtonSize.large,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(text: 'Already have an account? ',size: 18,),
                CustomAnchor(text: "Log in", onTap: backToSigin)
              ],
            ),
          ],
        ),
      ),
    );
  }

  // create card widget which is unique of this screen
  Widget _cardChoice(String name, EnumUser user, String intro) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(1, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(name, width: 50, height: 50,),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intro.split('\n').length > 1 ? intro.split('\n')[0] : '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          intro.split('\n').length > 1 ? intro.split('\n')[1] : '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),

                      ],
                    ),
                    Spacer(),
                    Radio<EnumUser>(
                      activeColor: Theme.of(context).colorScheme.onPrimary,
                      value: user,
                      groupValue: _user,
                      onChanged: chooseUserType,
                    ),
                  ],
                ),
          ],
        ),
            
  
      ),
    );
    
   
  }
}
