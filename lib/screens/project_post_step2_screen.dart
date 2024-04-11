import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProjectPostStep2Screen extends StatefulWidget {
  final ProjectCompanyModel projectCompanyModel;
  const ProjectPostStep2Screen({super.key, required this.projectCompanyModel});

  @override
  State<ProjectPostStep2Screen> createState() => _ProjectPostStep2ScreenState();
}

class _ProjectPostStep2ScreenState extends State<ProjectPostStep2Screen> {
  EnumProjectLenght _projectDuration = EnumProjectLenght.less_than_one_month;
  final _numberStudentsController = TextEditingController();
  bool _isDisabledNextButton = true;

  void onPressedNext() {
    widget.projectCompanyModel.projectScopeFlag = _projectDuration;
    widget.projectCompanyModel.numberofStudent =
        int.parse(_numberStudentsController.text);
    NavigationUtil.toPostProjectStep3(context, widget.projectCompanyModel);
  }

  // change value of project-duration when selecting another duration
  void onSelectedDuration(EnumProjectLenght? duration) {
    setState(() {
      _projectDuration = duration!;
    });
  }

  // has an error, disable the next button
  void onHandledButtonWithTextfield(String? messageError) {
    setState(() {
      _isDisabledNextButton = messageError != null ? true : false;
    });
  }

  // go to the next screen
  void onGoneToNextScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: () {}, currentContext: context),
      resizeToAvoidBottomInset: false,
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title text
            const CustomText(
              text: '2/4 - Next, estimate the scope of your job',
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // considering text
            const CustomText(
                text: 'Consider the size of your project and the time line'),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // duration text
            const CustomText(
              text: 'How long will your project take?',
              isBold: true,
            ),
            // select duration radio
            ListTile(
              horizontalTitleGap: 0.0,
              contentPadding: const EdgeInsets.only(),
              title:
                  CustomText(text: EnumProjectLenght.less_than_one_month.name),
              leading: Radio<EnumProjectLenght>(
                activeColor: Theme.of(context).colorScheme.onPrimary,
                value: EnumProjectLenght.less_than_one_month,
                groupValue: _projectDuration,
                onChanged: onSelectedDuration,
              ),
            ),
            ListTile(
              horizontalTitleGap: 0.0,
              contentPadding: const EdgeInsets.only(),
              title:
                  CustomText(text: EnumProjectLenght.one_to_three_month.name),
              leading: Radio<EnumProjectLenght>(
                activeColor: Theme.of(context).colorScheme.onPrimary,
                value: EnumProjectLenght.one_to_three_month,
                groupValue: _projectDuration,
                onChanged: onSelectedDuration,
              ),
            ),
            ListTile(
              horizontalTitleGap: 0.0,
              contentPadding: const EdgeInsets.only(),
              title:
                  CustomText(text: EnumProjectLenght.three_to_six_month.name),
              leading: Radio<EnumProjectLenght>(
                activeColor: Theme.of(context).colorScheme.onPrimary,
                value: EnumProjectLenght.three_to_six_month,
                groupValue: _projectDuration,
                onChanged: onSelectedDuration,
              ),
            ),
            ListTile(
              horizontalTitleGap: 0.0,
              contentPadding: const EdgeInsets.only(),
              title:
                  CustomText(text: EnumProjectLenght.more_than_six_month.name),
              leading: Radio<EnumProjectLenght>(
                activeColor: Theme.of(context).colorScheme.onPrimary,
                value: EnumProjectLenght.more_than_six_month,
                groupValue: _projectDuration,
                onChanged: onSelectedDuration,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // quantity of students text
            const CustomText(
              text: 'How many students do you want for this project?',
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // type number of students textfield
            CustomTextForm(
              controller: _numberStudentsController,
              listErros: const [InvalidationType.isBlank],
              hintText: 'number of students',
              onHelper: onHandledButtonWithTextfield,
              keyboardType: TextInputType.number,
              inputFormaters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            // next-description button
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                onPressed: onPressedNext,
                text: 'Next: Description',
                isDisabled: _isDisabledNextButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
