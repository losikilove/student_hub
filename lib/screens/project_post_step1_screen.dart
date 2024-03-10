import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProjectPostStep1Screen extends StatefulWidget {
  const ProjectPostStep1Screen({Key? key}) : super(key: key);

  @override
  State<ProjectPostStep1Screen> createState() => _ProjectPostStep1ScreenState();
}

class _ProjectPostStep1ScreenState extends State<ProjectPostStep1Screen> {
  final titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "1/4-Let's start with a strong title",isBold: true,),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              CustomText(text:"This helps your post stand out to the right students. It's the first thing they will see, so make it impressive"),
              CustomTextfield(controller: titleController, hintText: "write your title for your post"),
              const SizedBox(
                height: SpacingUtil.largeHeight,
              ),
              CustomText(text: "Example titles"),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              const BulletedList(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black
                ),
                bulletColor: Colors.black,
                listItems: [
                  "Build responsive WorldPress site with booking/paying functionality",
                  "Facebook ad specialist need for product launch"
                ]),
                const SizedBox(
                  height: SpacingUtil.largeHeight,
                ),
          
                Container(
                  alignment: Alignment.topRight,
                  child: CustomButton(onPressed: (){}, text: "Next:Scope")
                )
          
            ],
          ),
        ),
      ),
    );
  }
}
