import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/enums/enum_type_flag.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProjectPostStep1Screen extends StatefulWidget {
  const ProjectPostStep1Screen({Key? key}) : super(key: key);

  @override
  State<ProjectPostStep1Screen> createState() => _ProjectPostStep1ScreenState();
}

class _ProjectPostStep1ScreenState extends State<ProjectPostStep1Screen> {
  final titleController = TextEditingController();
  ProjectCompanyModel projectCModel = ProjectCompanyModel(
    title: "title", 
    projectScopeFlag: EnumProjectLenght.less_than_one_month, 
    numberofStudent: 0, 
    description: 'description',
    typeFlag: EnumTypeFlag.archive,
  );

  bool _titlePost = false;
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
              text: "1/4-Let's start with a strong title",
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            const CustomText(
                text:
                    "This helps your post stand out to the right students. It's the first thing they will see, so make it impressive"),
            CustomTextForm(
              controller: titleController,
              listErros: const <InvalidationType>[
                InvalidationType.isBlank,
              ],
              hintText: "write a title for your post",
              onHelper: (messageError) {
                setState(() {
                  _titlePost = messageError == null ? true : false;
                });
              },
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            const CustomText(text: "Example titles"),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                    const CustomBulletedList(
                      listItems: [
                        "Build responsive WorldPress site with booking/paying functionality",
                        "Facebook ad specialist need for product launch"
                      ]
                    ),
                    const SizedBox(
                      height: SpacingUtil.largeHeight,
                    ),
                    Container(
                    alignment: Alignment.topRight,
                    child: CustomButton(
                        isDisabled: !_titlePost,
                        onPressed: () {
                          projectCModel.title = titleController.text;
                          NavigationUtil.toPostProjectStep2(context,projectCModel);
                        },
                        text: "Next Scope"
                      )
                    )
                  ]
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
