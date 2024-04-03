import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';

class ProjectPostStep4Screen extends StatefulWidget {
  const ProjectPostStep4Screen({Key? key}) : super(key: key);

  @override
  State<ProjectPostStep4Screen> createState() => _ProjectPostStep4ScreenState();
}

class _ProjectPostStep4ScreenState extends State<ProjectPostStep4Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "4/4-Project details",
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            const CustomText(text: "Title job"),
            const CustomDivider(),
            const CustomText(text: "Student are looking for"),
            const CustomBulletedList(listItems: [
              "Clear expectation about your project or deliverables",
              "The skills required for your project",
              "Detail about your project"
            ]),
            const CustomDivider(),
            const CustomText(text: "Student are looking for"),
            _projectRequirement(Icons.alarm, 'Project scope', '3 to 6 months'),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            _projectRequirement(
                Icons.people_outline, 'Required students', '6 students'),
          ],
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
            onPressed: () {},
            text: 'Save',
          ),
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
