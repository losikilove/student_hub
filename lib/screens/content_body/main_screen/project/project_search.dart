import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/listview_project_items.dart';
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProjectBodySearchPart extends StatefulWidget {
  final BuildContext parentContext;
  final String search;
  final List<ProjectModel> projects;
  const ProjectBodySearchPart(
      {super.key,
      required this.parentContext,
      required this.search,
      required this.projects});

  @override
  State<ProjectBodySearchPart> createState() => _ProjectBodySearchPartState();
}

class _ProjectBodySearchPartState extends State<ProjectBodySearchPart> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // initialize the search controller
    _searchController = TextEditingController(text: widget.search);
  }

  @override
  void dispose() {
    // dispose the search controller
    _searchController.dispose();

    super.dispose();
  }

  void onPressed() {}

  Future<dynamic> onOpenedFilter(BuildContext context) {
    EnumProjectLenght? enumProjectLenght =
        EnumProjectLenght.less_than_one_month;
    TextEditingController studentNeededController = TextEditingController();
    TextEditingController proposalsLessThanController = TextEditingController();

    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void changeProjectLength(EnumProjectLenght? value) {
              setModalState(() {
                enumProjectLenght = value;
              });
            }

            Widget chooseLenght(EnumProjectLenght projectLenght, String text) {
              return Row(
                children: [
                  Radio(
                      activeColor: Theme.of(context).colorScheme.onPrimary,
                      value: projectLenght,
                      groupValue: enumProjectLenght,
                      onChanged: changeProjectLength),
                  CustomText(
                    text: text,
                    size: 15,
                  )
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const CustomText(
                        text: "Filter by",
                        size: 17,
                        isBold: true,
                      ),
                    ],
                  ),
                  const CustomText(text: 'Project length'),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chooseLenght(EnumProjectLenght.less_than_one_month,
                            "Less than one month"),
                        chooseLenght(EnumProjectLenght.one_to_three_month,
                            "1 to 3 months"),
                        chooseLenght(EnumProjectLenght.three_to_six_month,
                            "3 to 6 months"),
                        chooseLenght(EnumProjectLenght.more_than_six_month,
                            "more than 6 months"),
                      ]),
                  const CustomText(text: 'Student needed'),
                  SizedBox(
                    width: 200,
                    height: 25,
                    child: TextField(
                      controller: studentNeededController,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      )),
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  const CustomText(text: 'Proposals less than'),
                  SizedBox(
                    width: 200,
                    height: 25,
                    child: TextField(
                      controller: proposalsLessThanController,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      )),
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(onPressed: onPressed, text: 'Clear filter'),
                      const SizedBox(
                        width: SpacingUtil.smallHeight,
                      ),
                      CustomButton(onPressed: onPressed, text: 'Apply')
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Project search',
        isBack: true,
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // search bar
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextfield(
                    prefixIcon: Icons.search,
                    controller: _searchController,
                    hintText: 'Search for projects',
                  ),
                ),
                // filter list
                IconButton(
                  onPressed: () {
                    onOpenedFilter(context);
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingUtil.smallHeight),
            // filter list of projects
            ListViewProjectItems(projects: widget.projects),
          ],
        ),
      ),
    );
  }
}
