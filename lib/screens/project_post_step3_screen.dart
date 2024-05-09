import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectPostStep3Screen extends StatefulWidget {
  final ProjectCompanyModel projectCompanyModel;
  const ProjectPostStep3Screen({super.key, required this.projectCompanyModel});

  @override
  State<ProjectPostStep3Screen> createState() => _ProjectPostStep3ScreenState();
}

class _ProjectPostStep3ScreenState extends State<ProjectPostStep3Screen> {
  final _descriptionController = TextEditingController();

  void onPressed() {
    widget.projectCompanyModel.description = _descriptionController.text;
    NavigationUtil.toPostProjectStep4(context, widget.projectCompanyModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //overflows
      resizeToAvoidBottomInset: false, 
      appBar: CustomAppbar(
        onPressed: (){},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: '3/4 - ${AppLocalizations.of(context)!.nextProvideProjectDescription}',
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomText(
              text: AppLocalizations.of(context)!.studentAreLookingFor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomBulletedList(listItems: [
                  AppLocalizations.of(context)!.clearExpectionAboutYourProject,
                  AppLocalizations.of(context)!.theSkillsRequiredForYourProject,
                  AppLocalizations.of(context)!.detailAboutYourProject,
                ])
              ],
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomText(text: AppLocalizations.of(context)!.describeYourProject, isBold: true,),
            CustomTextfield(
              controller: _descriptionController,
              hintText: AppLocalizations.of(context)!.describe,
              isBox: true,
              maxLines: 5,
            ),
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                onPressed: onPressed,
                text: AppLocalizations.of(context)!.previewYourPost,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
