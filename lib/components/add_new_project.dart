import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/education_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class AddNewProject extends StatefulWidget{
  final void Function (List<ProjectModel> projects) onHelper;
  const AddNewProject({super.key, required this.onHelper});

  @override
  State<AddNewProject> createState() => _AddNewProject();
}

class _AddNewProject extends State<AddNewProject>{

  final List<ProjectModel> _projects =[
    ProjectModel('Intelligent Taxi Dispatching System', 
    'It is developer of a super-app for ride-halling, food delivery'
    ' and digital payments services on mobile device that operates in Singapor, Malaysia,...'
    ,'9/2020', '12/2020', '4 months'),
    ProjectModel('Intelligent Taxi Dispatching System', 
    'It is developer of a super-app for ride-halling, food delivery'
    ' and digital payments services on mobile device that operates in Singapor, Malaysia,...'
    ,'9/2020', '12/2020', '4 months'),
  ];

  void onCreateNewProject() async{
    final projectInfo = await openDialogHandleNewOne(null);
    if (projectInfo == null) return;

    setState(() {
      _projects.add(projectInfo);
    });
  }
  String caculateSetMonths(String timeStart, String timeEnd){
    List<String> start = timeStart.split('/'); 
    List<String> end = timeEnd.split('/'); 
    int index;
    if(int.parse(end[1]) > int.parse(start[1])){
      index = 12 - (int.parse(end[1]) - int.parse(start[1])) + 1;
      return  index.toString() + ' months';
    }
    else{
      index = int.parse(end[0]) - int.parse(start[0]);
      return  index.toString() + ' months';
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // education title
            const CustomText(
              text: 'Project',
              isBold: true,
            ),
            IconButton(onPressed: onCreateNewProject, icon: const Icon(Icons.add_circle_outline))
          ]
        ) 
      ],
    );
  }

  Future<ProjectModel?> openDialogHandleNewOne(ProjectModel? project) =>
    showDialog<ProjectModel>(
      context: context, 
      builder: (context){
        final tileProject = TextEditingController(
          text: project == null ? '' : project.getTileProject
        );
        final descriptionProject = TextEditingController(
          text: project == null ? '' : project.getDescription
        );
        //months
        final listBeginningMonths =List<String>.generate(
          12,
           (index) => '${index + 1}');        
        final listEndMonths =List<String>.generate(
          12,
           (index) => '${index + 1}');
        //years
        final listBeginningYears = List<String>.generate(
          EducationUtil.numberOfYears(),
           (index) => '${DateTime.now().year - index}');
        final listEndYears = List<String>.generate(
          EducationUtil.numberOfYears(),
           (index) => '${DateTime.now().year - index}');
        //selectime


        String beginTime = listBeginningMonths.first + '/' 
          + listBeginningYears.first;
        String endTime = listEndMonths.first + '/' 
          + listEndYears.first;

        bool isDisabledSubmit = true;
        
        void onSubmitedToAddNewOne(){
          Navigator.of(context).pop(ProjectModel(
            tileProject.text, 
            descriptionProject.text,
            beginTime,
            endTime,
            caculateSetMonths(beginTime,endTime)));
        }
        void onGettingBeginningOfTime(String? time) {
          beginTime = time!;
        }
        void onGettingEndOfTime(String? time) {
          endTime = time!;
        }
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: const Text('Project'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                
                children: [
                  TextField(
                    onChanged: (value){
                      setState((){
                        isDisabledSubmit = tileProject.text.isEmpty;
                      });
                    },
                    controller: tileProject,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your project'
                    ),
                  ),
                  TextField(
                    onChanged: (value){
                      setState((){
                        isDisabledSubmit = tileProject.text.isEmpty;
                      });
                    },
                    controller: tileProject,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your description'
                    ),
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 100,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Begin: ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: CustomOption<String>(
                              options: listBeginningYears,
                              onHelper: onGettingBeginningOfTime,
                              initialSelection: project == null
                                  ? listBeginningYears.first
                                  : project.getTimeStart,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 100,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'End: ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: CustomOption<String>(
                              options: listBeginningYears,
                              onHelper: onGettingEndOfTime,
                              initialSelection: project == null
                                  ? listBeginningYears.first
                                  : project.getTimeEnd,
                            ),
                          ),
                        ],
                      ),
                    ),
                ]),
                actions: [
                  CustomButton(
                    onPressed: onSubmitedToAddNewOne,
                    text: 'SUBMIT',
                    isDisabled: isDisabledSubmit,
                  )
                ],
            );
          }
        );
      }
    );
}