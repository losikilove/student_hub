import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class BrowseProjectDetailScreen extends StatefulWidget {
  // TODO: require a project-model attribute

  const BrowseProjectDetailScreen({super.key});

  @override
  State<BrowseProjectDetailScreen> createState() =>
      _BrowseProjectDetailScreenState();
}

class _BrowseProjectDetailScreenState extends State<BrowseProjectDetailScreen> {
  void onPressed() {}

  // apply this project
  void onAppliedNow() {
    NavigationUtil.toSubmitProposal(context);
  }

  // save this project
  void onSaved() {}

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
            // title of this screen
            const CustomText(
              text: 'Project detail',
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // title of job
            CustomText(
              text: 'Title of the job',
              isBold: true,
            ),
            const CustomDivider(),
            // desirements of student text
            const CustomText(
              text: 'Student are looking for',
            ),
            CustomBulletedList(
              listItems: [
                'Clear expectation about your project or deliverables',
                'The skills required for your project',
                'Detail about your project'
              ],
            ),
            const CustomDivider(),
            // scope of project
            _projectRequirement(Icons.alarm, 'Project scope', '3 to 6 months'),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Required students
            _projectRequirement(
                Icons.people_outline, 'Required students', '6 students'),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 0,
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              size: CustomButtonSize.small,
              onPressed: onAppliedNow,
              text: 'Apply Now',
              buttonColor: Theme.of(context).colorScheme.secondary,
            ),
            CustomButton(
              size: CustomButtonSize.small,
              onPressed: onSaved,
              text: 'Save',
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectRequirement(
      IconData icon, String title, String detailRequirement) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 35,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title),
              CustomBulletedList(
                listItems: [detailRequirement],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
