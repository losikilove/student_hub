import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/education_model.dart';

class AddNewEducation extends StatefulWidget {
  final void Function(List<EducationModel> educations) onHelper;
  const AddNewEducation({super.key, required this.onHelper});

  @override
  State<AddNewEducation> createState() => _AddNewEducationState();
}

class _AddNewEducationState extends State<AddNewEducation> {
  final List<EducationModel> _educations = [
    EducationModel('Le Hong Phong Highschool', 2008, 2010),
    EducationModel('Ho Chi Minh University of Sciences', 2010, 2014),
  ];

  void onCreatedNewEducation() async {
    // get data after submit info of dialog
    final educationInfo = await openDialogHandleNewOne(null);

    // nothing happens when nothing is committed
    if (educationInfo == null) return;

    // add a new education to list of educations
    setState(() {
      _educations.add(educationInfo);
    });
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
              final edittededucation =
                  await openDialogHandleNewOne(_educations[index]);

              // do not want to edit this education
              if (edittededucation == null) return;

              // after editing this education
              setState(() {
                _educations[index].seteducation = edittededucation.geteducation;
                _educations[index].setLevel = edittededucation.getLevel;
              });
            }

            // remove this education out of list
            void onRemoved() async {
              // show alert which confirms removed this education
              final decision = await openDialogWarningRemoveItem(
                  _educations[index].geteducation);

              // do not want to remove this education
              if (decision == null || decision == false) return;

              // after confirm, remove this education
              setState(() {
                _educations.removeAt(index);
              });
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomText(
                    text: _educations[index].toString(),
                    size: 14.5,
                  ),
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
          bool isDisabledSubmit = true;

          void onSubmitedToAddNewOne() {
            Navigator.of(context).pop(
                EducationModel(educationController.text, levelController.text));
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('education'),
                content: Column(
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
                          hintText: 'Enter your school name'),
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
