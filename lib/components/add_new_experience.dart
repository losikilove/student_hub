import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/mutliselect_chip.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/utils/education_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class AddNewExperience extends StatefulWidget {
  final void Function(List<ExperienceModel> projects) onHelper;
  final List<SkillSetModel> skills;
  const AddNewExperience(
      {super.key, required this.skills, required this.onHelper});

  @override
  State<AddNewExperience> createState() => _AddNewExperienceState();
}

class _AddNewExperienceState extends State<AddNewExperience> {
  final List<ExperienceModel> _experiences = [];

  void onCreateNewExperience() async {
    final experienceInfo = await openDialogHandleNewOne(null);
    if (experienceInfo == null) return;

    setState(() {
      _experiences.add(experienceInfo);
    });
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
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _experiences.length,
                itemBuilder: (BuildContext context, int index) {
                  ExperienceModel currentExperience = _experiences[index];

                  void onEdited() async {
                    final editedExperience =
                        await openDialogHandleNewOne(currentExperience);
                    if (editedExperience == null) return;

                    setState(() {
                      currentExperience.setTile = editedExperience.getTile;
                      currentExperience.setDescription =
                          editedExperience.getDescription;
                      currentExperience.setYearStart =
                          editedExperience.getYearStart;
                      currentExperience.setYearEnd =
                          editedExperience.getYearEnd;
                      currentExperience.setMonthStart =
                          editedExperience.getMonthStart;
                      currentExperience.setMonthEnd =
                          editedExperience.getMonthEnd;
                    });
                    widget.onHelper(_experiences);
                  }

                  // remove this education out of list
                  void onRemoved() async {
                    // show alert which confirms removed this education
                    final decision = await openDialogWarningRemoveItem(
                        currentExperience.getTile);

                    // do not want to remove this education
                    if (decision == null) return;

                    // after confirm, remove this education
                    setState(() {
                      _experiences.removeAt(index);
                    });
                    widget.onHelper(_experiences);
                  }

                  // get values from skillset list
                  void onGettingValuesOfSkillset(List<SkillSetModel> skills) {
                    currentExperience.setSkills = skills;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: CustomText(
                                  text: currentExperience.getTile,
                                  size: 14.5,
                                  isOverflow: true,
                                ),
                              ),
                              Text(
                                currentExperience.getDuration,
                                style: const TextStyle(
                                    fontSize: 14.5,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // update this education
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
                        ],
                      ),
                      CustomText(text: currentExperience.getDescription),
                      MultiSelectChip<SkillSetModel>(
                        listOf: widget.skills,
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
                }),
          ),
        )
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
            final listMonths = List<int>.generate(12, (index) => index + 1);
            //years
            final listYears = List<int>.generate(EducationUtil.numberOfYears(),
                (index) => DateTime.now().year - index);

            //selec time
            int beginMonth =
                project == null ? listMonths.first : project.getMonthStart;
            int endMonth =
                project == null ? listMonths.first : project.getMonthEnd;
            int beginYear =
                project == null ? listYears.first : project.getYearStart;
            int endYear =
                project == null ? listYears.first : project.getYearEnd;

            // flags mange the button
            bool isFilledTitle = tileProject.text.isNotEmpty;
            bool isFilledDescription = descriptionProject.text.isNotEmpty;

            void onSubmitedToAddNewOne() {
              Navigator.of(context).pop(ExperienceModel(
                  tileProject.text,
                  descriptionProject.text,
                  beginYear,
                  endYear,
                  beginMonth,
                  endMonth, []));
            }

            void onGettingBeginningOfMonth(int? time) {
              beginMonth = time!;
            }

            void onGettingBeginningOfYear(int? time) {
              beginYear = time!;
            }

            void onGettingEndOfMonth(int? time) {
              endMonth = time!;
            }

            void onGettingEndOfYear(int? time) {
              endYear = time!;
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
                              isFilledTitle = value.isNotEmpty;
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
                              isFilledDescription = value.isNotEmpty;
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
                                child: CustomOption<int>(
                                  options: listMonths,
                                  onHelper: onGettingBeginningOfMonth,
                                  initialSelection: beginMonth,
                                ),
                              ),
                              Expanded(
                                child: CustomOption<int>(
                                  options: listYears,
                                  onHelper: onGettingBeginningOfYear,
                                  initialSelection: beginYear,
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
                                child: CustomOption<int>(
                                  options: listMonths,
                                  onHelper: onGettingEndOfMonth,
                                  initialSelection: endMonth,
                                ),
                              ),
                              Expanded(
                                child: CustomOption<int>(
                                  options: listYears,
                                  onHelper: onGettingEndOfYear,
                                  initialSelection: endYear,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                actions: [
                  CustomButton(
                    onPressed: onSubmitedToAddNewOne,
                    text: 'SUBMIT',
                    isDisabled: !isFilledTitle || !isFilledDescription,
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
