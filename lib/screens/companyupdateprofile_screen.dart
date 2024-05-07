import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/company_model.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/enums/enum_numberpeople.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class CompanyUpdateProfileScreen extends StatefulWidget {
  const CompanyUpdateProfileScreen({super.key});

  @override
  State<CompanyUpdateProfileScreen> createState() =>
      _CompanyUpdateProfileScreenState();
}

class _CompanyUpdateProfileScreenState
    extends State<CompanyUpdateProfileScreen> {
  late TextEditingController companyNameController;
  late TextEditingController websiteController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    // get token and user which are app state
    CompanyModel company = Provider.of<UserProvider>(
      context,
      listen: false,
    ).user!.company!;

    // initialize controllers
    companyNameController = TextEditingController(text: company.companyName);
    websiteController = TextEditingController(text: company.website);
    descriptionController = TextEditingController(text: company.description);
  }

  @override
  void dispose() {
    companyNameController.dispose();
    websiteController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  // update profile
  void onUpdate() async {
    // confirm updated company profile
    final isConfirmed = await _showDialogConfirmUpdatedCompanyProfile();

    // user does not want to update the company profile
    if (isConfirmed == null || isConfirmed == false) {
      return;
    }

    // get token and user which are app state
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    UserModel user = userProvider.user!;
    String token = userProvider.token!;

    // call API update-company-profile
    final response = await ProfileService.updateCompanyProfile(
      companyName: companyNameController.text,
      id: user.company!.id.toString(),
      website: websiteController.text,
      description: descriptionController.text,
      token: token,
    );

    // handle the response
    if (response.statusCode == StatusCode.ok.code) {
      // update successfully
      userProvider.saveCompanyWhenUpdatedProfileCompany(
        companyName: companyNameController.text,
        website: websiteController.text,
        description: descriptionController.text,
      );

      // then show popup success and switch user to settings screen
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: AppLocalizations.of(context)!.updateYourCompanyProfileSuccessfully,
        textSubmit: 'Ok',
        submit: () {
          NavigationUtil.turnBack(context);
        },
      );

      // auto back to settings screen
      NavigationUtil.turnBack(context);
      return;
    } else if (response.statusCode == StatusCode.unauthorized.code) {
      // expired token
      ApiUtil.handleExpiredToken(context: context);
      return;
    } else {
      // others
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }
  }

  // cancel update company profile
  void onCanceled() {
    NavigationUtil.turnBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: () {}, currentContext: context),
      body: InitialBody(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child:
                      CustomText(text: AppLocalizations.of(context)!.welcomeToStudentHub, isBold: true)),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.company,
                isBold: true,
              ),
              CustomTextfield(
                controller: companyNameController,
                hintText: "",
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.website,
                isBold: true,
              ),
              CustomTextfield(
                controller: websiteController,
                hintText: "",
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.description,
                isBold: true,
              ),
              CustomTextfield(
                controller: descriptionController,
                hintText: "",
                maxLines: 2,
              ),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.howManyPeopleAreInYourCompany,
              ),
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                EnumNumberPeople? numberPeople =
                    userProvider.user?.company!.size;
                return chooseNumber(numberPeople!, numberPeople.name);
              }),
              const SizedBox(
                height: SpacingUtil.largeHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onPressed: onUpdate,
                    text: AppLocalizations.of(context)!.edit,
                    buttonColor: Theme.of(context).colorScheme.secondary,
                  ),
                  CustomButton(
                    onPressed: onCanceled,
                    text: AppLocalizations.of(context)!.cancel,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseNumber(EnumNumberPeople numberpeople, String text) {
    return Row(
      children: [
        Radio<EnumNumberPeople>(
          activeColor: Theme.of(context).colorScheme.onPrimary,
          value: numberpeople,
          groupValue: numberpeople,
          onChanged: (EnumNumberPeople? value) {},
        ),
        CustomText(text: text)
      ],
    );
  }

  Future<bool?> _showDialogConfirmUpdatedCompanyProfile() => showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.warning,
            style: TextStyle(color: Colors.red),
          ),
          content: CustomText(
            text: AppLocalizations.of(context)!.areYouSureToUpdateYourCompanyProfile,
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: AppLocalizations.of(context)!.yes,
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: AppLocalizations.of(context)!.no,
            ),
          ],
        );
      });
}
