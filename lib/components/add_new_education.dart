import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/utils/education_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class AddNewEducation extends StatefulWidget {
  final void Function(List<EducationModel> educations) onHelper;
  const AddNewEducation({super.key, required this.onHelper});

  @override
  State<AddNewEducation> createState() => _AddNewEducationState();
}

class _AddNewEducationState extends State<AddNewEducation> {
  final List<EducationModel> _educations = [];

  void onCreatedNewEducation() async {
    // get data after submit info of dialog
    final educationInfo = await openDialogHandleNewOne(null);

    // nothing happens when nothing is committed
    if (educationInfo == null) return;

    // add a new education to list of educations
    setState(() {
      _educations.add(educationInfo);
    });
    widget.onHelper(_educations);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // education title
            const CustomText(
              text: 'Educations',
              isBold: true,
            ),
            // add-new button
            IconButton(
              onPressed: onCreatedNewEducation,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        // show list of added educations
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _educations.length,
          itemBuilder: (BuildContext context, int index) {
            // edit this education
            void onEdited() async {
              // show alert which edits this education info
              final edittedEducation =
                  await openDialogHandleNewOne(_educations[index]);

              // do not want to edit this education
              if (edittedEducation == null) return;

              // after editing this education
              setState(() {
                _educations[index].setSchoolName =
                    edittedEducation.getSchoolName;
                _educations[index].setBeginningOfSchoolYear =
                    edittedEducation.getBeginningOfSchoolYear;
                _educations[index].setEndOfSchoolYear =
                    edittedEducation.getEndOfSchoolYear;
              });
              widget.onHelper(_educations);
            }

            // remove this education out of list
            void onRemoved() async {
              // show alert which confirms removed this education
              final decision = await openDialogWarningRemoveItem(
                  _educations[index].getSchoolName);

              // do not want to remove this education
              if (decision == null) return;

              // after confirm, remove this education
              setState(() {
                _educations.removeAt(index);
              });
              widget.onHelper(_educations);
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // school name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: CustomText(
                        text: _educations[index].getSchoolName,
                        size: 14.5,
                        isOverflow: true,
                      ),
                    ),
                    Text(
                      _educations[index].getSchoolYear,
                      style: const TextStyle(
                          fontSize: 14.5, fontStyle: FontStyle.italic),
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
            );
          },
        ),
      ],
    );
  }

  // Dialog add-new-one pop-up
  Future<EducationModel?> openDialogHandleNewOne(EducationModel? education) =>
      showDialog<EducationModel>(
        context: context,
        builder: (context) {
          final schoolNameController = TextEditingController(
              text: education == null ? '' : education.getSchoolName);
          final listYears = List<int>.generate(EducationUtil.numberOfYears(),
              (index) => DateTime.now().year - index);
          int selectedBeginningYear = education == null
              ? listYears.first
              : education.getBeginningOfSchoolYear;
          int selectedEndYear = education == null
              ? listYears.first
              : education.getEndOfSchoolYear;
          bool isDisabledSubmit = schoolNameController.text.isEmpty;

          void onSubmitedToAddNewOne() {
            Navigator.of(context).pop(EducationModel(
              null,
              schoolNameController.text,
              selectedBeginningYear,
              selectedEndYear,
            ));
          }

          void onGettingBeginningOfYear(int? year) {
            selectedBeginningYear = year!;
          }

          void onGettingEndOfYear(int? year) {
            selectedEndYear = year!;
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Education'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // fill school name
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          isDisabledSubmit = schoolNameController.text.isEmpty;
                        });
                      },
                      controller: schoolNameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your school name',
                      ),
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    // pick beginning of year up
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
                              options: listYears,
                              onHelper: onGettingBeginningOfYear,
                              initialSelection: selectedBeginningYear,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // pick end of year up
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 100,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Finish: ',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: CustomOption<int>(
                              options: listYears,
                              onHelper: onGettingEndOfYear,
                              initialSelection: selectedEndYear,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  CustomButton(
                    onPressed: onSubmitedToAddNewOne,
                    text: 'SUBMIT',
                    isDisabled: isDisabledSubmit,
                  )
                ],
              );
            },
          );
        },
      );

  // Dialog remove-one
  Future<bool?> openDialogWarningRemoveItem(String education) =>
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
            content: Text('Are you sure to remove this "$education"'),
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
