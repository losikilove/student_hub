import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/company_model.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/models/enums/enum_numberpeople.dart';
import 'package:student_hub/components/custom_appbar.dart';

class CompanyRegisterScreen extends StatefulWidget {
  const CompanyRegisterScreen({super.key});

  @override
  State<CompanyRegisterScreen> createState() => _CompanyRegisterScreenState();
}

class _CompanyRegisterScreenState extends State<CompanyRegisterScreen> {
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();

  EnumNumberPeople? _numberPeople = EnumNumberPeople.one;
  void changeNumberPeople(EnumNumberPeople? value) {
    setState(() {
      _numberPeople = value;
    });
  }
  void createProfile(){

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
              const Center(
                  child:
                      CustomText(text: "Welcome to Student Hub", isBold: true)),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              const CustomText(
                  text:
                      "Tell us about your company and you will be on your way connect with high-skilled student"),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              const CustomText(text: "How many people are in your company ?"),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                chooseNumber(EnumNumberPeople.one, "It's just me"),
                chooseNumber(EnumNumberPeople.two_to_nine, "2-9 employees"),
                chooseNumber(
                    EnumNumberPeople.ten_to_nightynine, "10-99 employees"),
                chooseNumber(
                    EnumNumberPeople.hundred_to_thousand, "100-1000 employees"),
                chooseNumber(EnumNumberPeople.more_than_thousand,
                    "more than 1000 emoployees"),
              ]),
              const SizedBox(
                height: SpacingUtil.smallHeight,
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
              Container(
                alignment: Alignment.topRight,
                child: CustomButton(
                  onPressed: () {
                    createProfile();
                    NavigationUtil.toWelcomeScreen(context);
                  },
                  text: "Continue",
                ),
              ),
              const SizedBox(height: SpacingUtil.mediumHeight)
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
          groupValue: _numberPeople,
          onChanged: changeNumberPeople,
        ),
        CustomText(text: text)
      ],
    );
  }
}
