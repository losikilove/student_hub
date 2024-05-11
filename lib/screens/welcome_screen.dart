import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            // signpost icon
            const Icon(
              Icons.signpost_outlined,
              size: 40.0,
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            // welcome text
            Consumer<UserProvider>(
              builder: (context, userProvider, child) => Center(
                child: CustomText(
                    text: '${AppLocalizations.of(context)!.welcome}, ${userProvider.user?.fullname ?? 'you'}!'),
              ),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // greeting text
            Center(
              child: CustomText(
                text: AppLocalizations.of(context)!.letsStartWithYourFirstProjectPost,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            // switch to dashboard button
            CustomButton(
              onPressed: () {
                NavigationUtil.toMainScreen(context, MainScreenIndex.dashboard);
              },
              text: AppLocalizations.of(context)!.getStarted,
            ),
          ],
        ),
      ),
    );
  }
}
