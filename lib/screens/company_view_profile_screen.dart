import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class CompanyViewProfileScreen extends StatefulWidget {
  const CompanyViewProfileScreen({super.key});

  @override
  State<CompanyViewProfileScreen> createState() =>
      _CompanyViewProfileScreenState();
}

class _CompanyViewProfileScreenState extends State<CompanyViewProfileScreen> {
  void onPressed() {}

  // switch to update-company-profile screen
  void onSwitchedToCompanyUpdateProfile() {
    NavigationUtil.toCompanyUpdateProfileScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: Align(
          alignment: Alignment.center,
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return Column(
                children: [
                  // title of screen
                  CustomText(
                    text: AppLocalizations.of(context)!.yourCompanyProfile,
                    isBold: true,
                    size: 25,
                  ),
                  const SizedBox(
                    height: SpacingUtil.mediumHeight,
                  ),
                  // name of company
                  CustomText(
                    text: AppLocalizations.of(context)!.company,
                    size: 18,
                  ),
                  CustomText(
                    text: userProvider.user!.company!.companyName,
                    size: 22,
                    isBold: true,
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  // website of company
                  CustomText(
                    text: AppLocalizations.of(context)!.website,
                    size: 18,
                  ),
                  CustomText(
                    text: userProvider.user!.company!.website,
                    isBold: true,
                    size: 18,
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  // size of company
                  const CustomText(
                    text: 'Size',
                    size: 18,
                  ),
                  CustomText(
                    text: userProvider.user!.company!.size.name,
                    isBold: true,
                    size: 18,
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  // description of company
                  CustomText(
                    text: AppLocalizations.of(context)!.aboutUs,
                    size: 18,
                  ),
                  CustomText(
                    text: userProvider.user!.company!.description,
                    isBold: true,
                    size: 18,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 0,
        color: Theme.of(context).colorScheme.background,
        child: Container(
          alignment: Alignment.topRight,
          child: CustomButton(
            size: CustomButtonSize.small,
            onPressed: onSwitchedToCompanyUpdateProfile,
            text: AppLocalizations.of(context)!.update,
          ),
        ),
      ),
    );
  }
}
