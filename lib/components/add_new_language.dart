import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/language_model.dart';

class AddNewLanguage extends StatefulWidget {
  final void Function(List<LanguageModel> languages) onHelper;
  const AddNewLanguage({super.key, required this.onHelper});

  @override
  State<AddNewLanguage> createState() => _AddNewLanguageState();
}

class _AddNewLanguageState extends State<AddNewLanguage> {
  final List<LanguageModel> _languages = [
    LanguageModel('English', 'Native or Bilingual'),
    LanguageModel('French', 'B2'),
  ];

  void onCreatedNewLanguage() async {
    // get data after submit info of dialog
    final languageInfo = await openDialogHandleNewOne(null);

    // nothing happens when nothing is committed
    if (languageInfo == null) return;

    // add a new language to list of languages
    setState(() {
      _languages.add(languageInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // language title
            const CustomText(
              text: 'Languages',
              isBold: true,
            ),
            // add-new button
            IconButton(
              onPressed: onCreatedNewLanguage,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        // show list of added languages
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _languages.length,
          itemBuilder: (BuildContext context, int index) {
            // edit this language
            void onEdited() async {
              // show alert which edits this language info
              final edittedLanguage =
                  await openDialogHandleNewOne(_languages[index]);

              // do not want to edit this language
              if (edittedLanguage == null) return;

              // after editing this language
              setState(() {
                _languages[index].setLanguage = edittedLanguage.getLanguage;
                _languages[index].setLevel = edittedLanguage.getLevel;
              });
            }

            // remove this language out of list
            void onRemoved() async {
              // show alert which confirms removed this language
              final decision = await openDialogWarningRemoveItem(
                  _languages[index].getLanguage);

              // do not want to remove this language
              if (decision == null || decision == false) return;

              // after confirm, remove this language
              setState(() {
                _languages.removeAt(index);
              });
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: CustomText(
                    text: _languages[index].toString(),
                    size: 14.5,
                    isOverflow: true,
                  ),
                ),
                Row(
                  children: [
                    // update this language
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
  Future<LanguageModel?> openDialogHandleNewOne(LanguageModel? language) =>
      showDialog<LanguageModel>(
        context: context,
        builder: (context) {
          final languageController = TextEditingController(
              text: language == null ? '' : language.getLanguage);
          final levelController = TextEditingController(
              text: language == null ? '' : language.getLevel);
          bool isDisabledSubmit = true;

          void onSubmitedToAddNewOne() {
            Navigator.of(context).pop(
                LanguageModel(languageController.text, levelController.text));
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Language'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // fill name of language
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          isDisabledSubmit = languageController.text.isEmpty ||
                              levelController.text.isEmpty;
                        });
                      },
                      controller: languageController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          hintText: 'Enter your language'),
                    ),
                    // fill level of language
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          isDisabledSubmit = languageController.text.isEmpty ||
                              levelController.text.isEmpty;
                        });
                      },
                      controller: levelController,
                      decoration:
                          const InputDecoration(hintText: 'Enter your level'),
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
  Future<bool?> openDialogWarningRemoveItem(String language) =>
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
            content: Text('Are you sure to remove this "$language"'),
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
