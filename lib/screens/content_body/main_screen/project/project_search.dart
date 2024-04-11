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
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
class ProjectBodySearchPart extends StatefulWidget {
  final BuildContext parentContext;
  final String search;
  String? projectScopeFlag;
  String? proposalsLessThan;
  String? numberOfStudents;
  ProjectBodySearchPart(
      {super.key,
      required this.parentContext,
      required this.search,
      this.projectScopeFlag,
      this.numberOfStudents,
      this.proposalsLessThan
    });

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

  Future<List<ProjectModel>> initializeProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    String? token = userProvider.token;
    final response = await ProjectService.searchProject(search: widget.search,token: token!);
    return ProjectModel.fromResponse(response);
  }

  @override
  void dispose() {
    // dispose the search controller
    _searchController.dispose();

    super.dispose();
  }

  Future<dynamic> onOpenedFilter(BuildContext context) {
    EnumProjectLenght? enumProjectLenght =
        EnumProjectLenght.less_than_one_month;
    TextEditingController studentNeededController = TextEditingController();
    TextEditingController proposalsLessThanController = TextEditingController();

    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void changeProjectLength(EnumProjectLenght? value) {
              setModalState(() {
                enumProjectLenght = value;
              });
            }
            
             void submitFilter() {
              setModalState(() {
                widget.numberOfStudents = studentNeededController.text;
                widget.proposalsLessThan = proposalsLessThanController.text;
                widget.projectScopeFlag = enumProjectLenght?.value.toString();
                NavigationUtil.toProjectFilterScreen(context, widget.search,widget.proposalsLessThan, widget.projectScopeFlag,widget.numberOfStudents);
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
              child: Container(
                height:MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(8.0),
                color: Theme.of(context).colorScheme.onBackground,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Filter by",
                          size: 20,
                          isBold: true,
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const CustomText(text: 'Project length',size:18,),
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
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    const CustomText(text: 'Student needed',size:18,),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Container(
                      decoration: BoxDecoration(
                         border: Border.all(width: 1.0, color: Theme.of(context).colorScheme.onPrimary)
   
                      ),
                      height: 35,
                      child: TextField(
                        controller: studentNeededController,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary),
                        textAlign: TextAlign.start,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    const CustomText(text: 'Proposals less than',size:18,),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Theme.of(context).colorScheme.onPrimary)
                      ),
                      height: 35,
                      child: TextField(
                        controller: proposalsLessThanController,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary),
                       
                        textAlign: TextAlign.start,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(onPressed: (){
                          studentNeededController.clear();
                          proposalsLessThanController.clear();
                          changeProjectLength(EnumProjectLenght.less_than_one_month);
                        }, text: 'Clear filter'),
                        const SizedBox(
                          width: SpacingUtil.smallHeight,
                        ),
                        CustomButton(onPressed: (){
                          Navigator.pop(context);
                          submitFilter();
                        }, text: 'Apply')
                      ],
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                  ],
                ),
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
        onPressed: (){},
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
            CustomFutureBuilder<List<ProjectModel>>(
              future: initializeProject(),
              widgetWithData: (snapshot) =>
                  ListViewProjectItems(projects: snapshot.data!),
              widgetWithError: (snapshot) {
                return CustomText(
                  text: snapshot.toString(),
                  textColor: Colors.red,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
