import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/mutliselect_chip.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/utils/education_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class AddNewExperience extends StatefulWidget {
  final void Function(List<ExperienceModel> projects) onHelper;
  const AddNewExperience({super.key, required this.onHelper});

  @override
  State<AddNewExperience> createState() => _AddNewExperienceState();
}

class _AddNewExperienceState extends State<AddNewExperience> {
  final List<ExperienceModel> _experiences = [
    ExperienceModel(
        'Intelligent Taxi Dispatching System',
        'It is developer of a super-app for ride-halling, food delivery'
            ' and digital payments services on mobile device that operates in Singapor, Malaysia,...',
        '9/2020',
        '12/2020',
        '4 months',
        ['C++', 'Java']),
    ExperienceModel(
        'Intelligent Taxi Dispatching System',
        'It is developer of a super-app for ride-halling, food delivery'
            ' and digital payments services on mobile device that operates in Singapor, Malaysia,...',
        '9/2020',
        '12/2020',
        '4 months',
        ['C++', 'Java']),
  ];
  final List<String> skillsetOptions = [
    'iOS dev',
    'C/C++',
    'Java',
    'ReactJS',
    'NodeJS',
  ];
  late List<String> selectedSkillsets;

  void onGettingValuesOfSkillset(List<String> selectedItems) {
    selectedSkillsets = selectedItems;
  }

  void onCreateNewExperience() async {
    final experienceInfo = await openDialogHandleNewOne(null);
    if (experienceInfo == null) return;

    setState(() {
      _experiences.add(experienceInfo);
    });
  }

  String caculateSetMonths(String timeStart, String timeEnd) {
    List<String> start = timeStart.split('/');
    List<String> end = timeEnd.split('/');
    int index;
    if (int.parse(end[1]) > int.parse(start[1])) {
      index = 12 - (int.parse(end[1]) - int.parse(start[1])) + 1;
      return index.toString() + ' months';
    } else {
      index = int.parse(end[0]) - int.parse(start[0]);
      return index.toString() + ' months';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // education title
          const CustomText(
            text: 'Project',
            isBold: true,
          ),
          IconButton(
              onPressed: onCreateNewExperience,
              icon: const Icon(Icons.add_circle_outline))
        ]),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _experiences.length,
            itemBuilder: (BuildContext context, int index) {
              void onEdited() async {
                final editedExperience =
                    await openDialogHandleNewOne(_experiences[index]);
                if (editedExperience == null) return;

                //
                setState(() {
                  _experiences[index].setTile = editedExperience.getTile;
                  _experiences[index].setDescription =
                      editedExperience.getDescription;
                  _experiences[index].setTimeStart =
                      editedExperience.getTimeStart;
                  _experiences[index].setTimeEnd = editedExperience.getTimeEnd;
                  _experiences[index].setMonths = editedExperience.getMonths;
                  _experiences[index].setSelectSkill =
                      editedExperience.getSkills;
                });
                widget.onHelper(_experiences);
              }

              // remove this education out of list
              void onRemoved() async {
                // show alert which confirms removed this education
                final decision = await openDialogWarningRemoveItem(
                    _experiences[index].getTile);

                // do not want to remove this education
                if (decision == null) return;

                // after confirm, remove this education
                setState(() {
                  _experiences.removeAt(index);
                });
                widget.onHelper(_experiences);
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: CustomText(
                              text: _experiences[index].getTile,
                              size: 14.5,
                              isOverflow: true,
                            ),
                          ),
                          Text(
                            _experiences[index].getTime,
                            style: const TextStyle(
                                fontSize: 14.5, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: onEdited,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      // remove this one
                      IconButton(
                        onPressed: onRemoved,
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  CustomText(text: _experiences[index].getDescription),
                  MultiSelectChip(
                    listOf: skillsetOptions,
                    onHelper: onGettingValuesOfSkillset,
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  const CustomDivider(
                    isFullWidth: true,
                  ),
                ],
              );
            })
      ],
    );
  }

  Future<ExperienceModel?> openDialogHandleNewOne(ExperienceModel? project) =>
      showDialog<ExperienceModel>(
          context: context,
          builder: (context) {
            final tileProject = TextEditingController(
                text: project == null ? '' : project.getTile);
            final descriptionProject = TextEditingController(
                text: project == null ? '' : project.getDescription);
            //months
            final listBeginningMonths =
                List<String>.generate(12, (index) => '${index + 1}');
            final listEndMonths =
                List<String>.generate(12, (index) => '${index + 1}');
            //years
            final listBeginningYears = List<String>.generate(
                EducationUtil.numberOfYears(),
                (index) => '${DateTime.now().year - index}');
            final listEndYears = List<String>.generate(
                EducationUtil.numberOfYears(),
                (index) => '${DateTime.now().year - index}');
            //selectime

            String beginTime =
                listBeginningMonths.first + '/' + listBeginningYears.first;
            String endTime = listEndMonths.first + '/' + listEndYears.first;

            bool isDisabledSubmit = true;
            // List<String> multiSelectSkill = _multiSelectController.toString().split(' ');

            void onSubmitedToAddNewOne() {
              Navigator.of(context).pop(ExperienceModel(tileProject.text,
                  descriptionProject.text, beginTime, endTime, '', []));
            }

            void onGettingBeginningOfTime(String? time) {
              beginTime = time!;
            }

            void onGettingEndOfTime(String? time) {
              endTime = time!;
            }

            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text('Project'),
                content: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              isDisabledSubmit = tileProject.text.isEmpty;
                            });
                          },
                          controller: tileProject,
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: 'Enter your project'),
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              isDisabledSubmit =
                                  descriptionProject.text.isEmpty;
                            });
                          },
                          controller: descriptionProject,
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: 'Enter your description'),
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
                                  options: listBeginningMonths,
                                  onHelper: onGettingBeginningOfTime,
                                  initialSelection: project == null
                                      ? listBeginningMonths.first
                                      : project.getTimeStart,
                                ),
                              ),
                              Expanded(
                                child: CustomOption<String>(
                                  options: listBeginningYears,
                                  onHelper: onGettingBeginningOfTime,
                                  initialSelection: project == null
                                      ? listBeginningYears.first
                                      : '/' + project.getTimeStart,
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
                                  options: listEndMonths,
                                  onHelper: onGettingEndOfTime,
                                  initialSelection: project == null
                                      ? listEndMonths.first
                                      : project.getTimeEnd,
                                ),
                              ),
                              Expanded(
                                child: CustomOption<String>(
                                  options: listEndYears,
                                  onHelper: onGettingEndOfTime,
                                  initialSelection: project == null
                                      ? listEndYears.first
                                      : '/' + project.getTimeEnd,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                actions: [
                  CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop(ExperienceModel(
                          tileProject.text,
                          descriptionProject.text,
                          beginTime,
                          endTime,
                          '', []));
                    },
                    text: 'SUBMIT',
                    isDisabled: isDisabledSubmit,
                  )
                ],
              );
            });
          });
  Future<bool?> openDialogWarningRemoveItem(String experience) =>
      showDialog<bool>(
        context: context,
        builder: (context) {
          void onYes() {
            Navigator.of(context).pop(true);
          }

          return AlertDialog(
            title: const Text(
              'WARNING',
              style: TextStyle(color: Colors.red),
            ),
            content: Text('Are you sure to remove this "$experience"'),
            actions: [
              CustomButton(
                onPressed: onYes,
                text: 'YES',
              ),
            ],
          );
        },
      );
}
