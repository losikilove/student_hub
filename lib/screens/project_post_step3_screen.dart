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

class ProjectPostStep3Screen extends StatefulWidget {
  final ProjectCompanyModel projectCompanyModel;
  const ProjectPostStep3Screen({super.key, required this.projectCompanyModel});

  @override
  State<ProjectPostStep3Screen> createState() => _ProjectPostStep3ScreenState();
}

class _ProjectPostStep3ScreenState extends State<ProjectPostStep3Screen> {
  final _descriptionController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: '3/4 - Next, provide project description',
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomText(
              text: 'Student are looking for',
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomBulletedList(listItems: [
                  'Clear expectation about your project or deliverables',
                  'The skills required for your project',
                  'Detail about your project',
                ])
              ],
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomText(text: 'Describe your project:'),
            CustomTextfield(
              controller: _descriptionController,
              hintText: 'describe',
              isBox: true,
              maxLines: 5,
            ),
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                onPressed: () {
                  NavigationUtil.toPostProjectStep4(context, widget.projectCompanyModel);
                },
                text: 'Preview your post',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
