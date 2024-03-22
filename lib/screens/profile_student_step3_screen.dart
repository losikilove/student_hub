import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:file_picker/file_picker.dart';

class ProfileStudentStep3Screen extends StatefulWidget {
  const ProfileStudentStep3Screen({Key? key}) : super(key: key);

  @override
  State<ProfileStudentStep3Screen> createState() =>
      _ProfileStudentStep3ScreenState();
}

class _ProfileStudentStep3ScreenState extends State<ProfileStudentStep3Screen> {
  Future<void> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Handle the selected file
        String filePath = result.files.single.path!;
        log('Selected file: $filePath');
        // You can use the filePath as needed (e.g., upload to server)
      } else {
        // User canceled the file picker
        log('User canceled file picker');
      }
    } catch (e) {
      log('Error picking file: $e');
    }
  }

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
            const Center(
              child: CustomText(
                text: "CV & Transcript",
                isBold: true,
              ),
            ),
            const CustomText(
              text:
                  "Tell us about yourself and you will be on your way to connect with real projects.",
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            const CustomText(text: "Resume/CV (*)"),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            DottedBorder(
              radius:const Radius.circular(8),
              child: Container(
                alignment: Alignment.center,
                color: Colors.cyan.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.upload_file,
                      size: 90,
                      color: Colors.white,
                    ),
                    // CustomText(text: "Drag on",isBold: true,),
                    CustomButton(
                      onPressed: () {
                        pickFile(context);
                      },
                      text: "choose file to up",
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomText(text: "Transcript (*)"),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            DottedBorder(
              radius:const Radius.circular(8),
              child: Container(
                alignment: Alignment.center,
                color: Colors.cyan.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.upload_file,
                      size: 90,
                      color: Colors.white,
                    ),
                    // CustomText(text: "Drag on",isBold: true,),
                    CustomButton(
                      onPressed: () {
                        pickFile(context);
                      },
                      text: "choose file to up",
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            Container(
              alignment: Alignment.topRight,
              child: CustomButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=>const MainScreen(contentBody: MainScreenIndex.project)));
                },
                text: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
