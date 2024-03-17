import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProjectPostStep3Screen extends StatefulWidget
{
  const ProjectPostStep3Screen({super.key});

  @override
  State<ProjectPostStep3Screen> createState() => _ProjectPostStep3ScreenState();
}

class _ProjectPostStep3ScreenState extends State<ProjectPostStep3Screen>{

  void onPressed(){}

  bool _isDisabledNextButton = true;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context,),
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
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomBulletedList(listItems: [
                    'Clear expectation about your project or deliverables',
                    'The skills required for your project',
                    'Detail about your project',
                  ]          
                  )
                ],
              ),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ),
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                onPressed: (){
                  NavigationUtil.toPostProjectStep4(context);
                },
                text: 'Preview your post',
                isDisabled: _isDisabledNextButton,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
    
}