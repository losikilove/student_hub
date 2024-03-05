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
              height: SpacingUtil.smallHeight,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomText(
              text: "Company name",
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomTextfield(controller: companyNameController, hintText: ""),
            const CustomText(
              text: "website",
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomTextfield(controller: websiteController, hintText: ""),
            const CustomText(
              text: "Description",
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomTextfield(
              controller: descriptionController,
              hintText: "",
              maxLines: 2,
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            const CustomText(text: "How many people are in your company ?"),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            chooseNumber(EnumNumberPeople.one, "It's just me"),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(onPressed: () {}, text: "Edit"),
                CustomButton(onPressed: () {}, text: "Cancel"),
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
          activeColor: const Color.fromARGB(236, 3, 70, 147),
          value: numberpeople,
          groupValue: _numberPeople,
          onChanged: changeNumberPeople,
        ),
        CustomText(text: text)
      ],
    );
  }
}
