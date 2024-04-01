import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';
// import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/models/enums/enum_numberpeople.dart';
import 'package:student_hub/components/custom_appbar.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();
  EnumNumberPeople? _numberPeople = EnumNumberPeople.one;
  void changeNumberPeople(EnumNumberPeople? value) {
    setState(() {
      _numberPeople = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: () {}, currentContext: context),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child:
                    CustomText(text: "Welcome to Student Hub", isBold: true)),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            const CustomText(
              text: "Company name",
              isBold: true,
            ),
            CustomTextfield(
              controller: companyNameController,
              hintText: "",
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomText(
              text: "Website",
              isBold: true,
            ),
            CustomTextfield(
              controller: websiteController,
              hintText: "",
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomText(
              text: "Description",
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
            const CustomText(
              text: "How many people are there in your company ?",
            ),
            chooseNumber(EnumNumberPeople.one, "It's just me"),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  onPressed: () {
                    
                  },
                  text: "Edit",
                  buttonColor: Theme.of(context).colorScheme.secondary,
                ),
                CustomButton(
                  onPressed: () {},
                  text: "Cancel",
                ),
              ],
            )
          ],
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
          groupValue: _numberPeople,
          onChanged: changeNumberPeople,
        ),
        CustomText(text: text)
      ],
    );
  }
}
