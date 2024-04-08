import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_appbar.dart';
class BrowseProjectDetailScreen extends StatefulWidget {
  // TODO: require a project-model attribute
  final int id;
  final String token;
  const BrowseProjectDetailScreen({super.key,required this.id,required this.token});

  @override
  State<BrowseProjectDetailScreen> createState() =>
      _BrowseProjectDetailScreenState();
}

class _BrowseProjectDetailScreenState extends State<BrowseProjectDetailScreen> {
  void onPressed() {}
  String title = '',projectScope = '1-3',requiredStudent = '6';
  String description = '';
 
  // apply this project
  void onAppliedNow() {
    NavigationUtil.toSubmitProposal(context);
  }

  // save this project
  void onSaved() {}
  
  void getDetail() async{
    if (!mounted) return;
    final response = await ProjectService.viewProjectDetail(id: widget.id, token: widget.token);  
    final result = ApiUtil.getResult(response); 
    setState(() {
      title = result['project']['title'];
      description = result['project']['description'];
      if (result['project']['projectScopeFlag'] == 1) {
      projectScope = '3 - 6';
    }
    requiredStudent = result['project']['numberOfStudents'].toString();
  });
    
  }
  @override
  Widget build(BuildContext context) {
    getDetail();
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Saved projects',
        isBack: true,
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(onPressed: (){
            //       NavigationUtil.turnBack(context);
            //     }, icon: Icon(Icons.cancel)),
            //   ],
            // ),
            CustomText(
              text: "Detail: "+ title,
              isBold: true,
              size: 23,
            ),
            const CustomDivider(),
            // desirements of student text
            const CustomText(
              size: 18,
              text: 'Student are looking for',
            ),
            CustomBulletedList(
              textSize: 18,
              listItems:description.split(';'),
            ),
            const CustomDivider(),
            // scope of project
            _projectRequirement(Icons.alarm, 'Project scope', '$projectScope months'),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Required students
            _projectRequirement(
                Icons.people_outline, 'Required students', '$requiredStudent students'),
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
          size: 42,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title,size: 20,),
              CustomBulletedList(
                textSize: 18,
                listItems: [detailRequirement],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
