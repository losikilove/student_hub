import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/listview_project_items.dart';
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ProjectBodySearchPart extends StatefulWidget {
  final BuildContext parentContext;
  final String search;
  String? projectScopeFlag;
  String? proposalsLessThan;
  String? numberOfStudents;
  bool isFilter = false;
  ProjectBodySearchPart(
      {super.key,
      required this.parentContext,
      required this.search,
      this.projectScopeFlag,
      this.numberOfStudents,
      this.proposalsLessThan,
      this.isFilter = false});

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
  bool isFound = true;
  int page = 1;
  Future<List<ProjectModel>> initializeProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    String? token = userProvider.token;
    if (!widget.isFilter) {
      final response = await ProjectService.searchProject(
          search: widget.search, token: token!,page:  page);
      if(response.statusCode == 404){
        isFound = false;
        return [];
      }else{
        isFound = true;
        return ProjectModel.fromResponse(response);
      }
    } else {
      final response = await ProjectService.filterProject(
          search: widget.search,
          projectScopeFlag: widget.projectScopeFlag,
          numberOfStudents: widget.numberOfStudents,
          proposalsLessThan: widget.proposalsLessThan,
          token: token!);
      return ProjectModel.fromResponse(response);
    }
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
      
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                Navigator.pop(context);
                setState(() {
                  widget.isFilter = true;
                });
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
                padding: const EdgeInsets.all(8.0),
                color: Theme.of(context).colorScheme.onSecondary,
                child: ConstrainedBox(constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,),
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
                        CustomText(
                          text: AppLocalizations.of(context)!.filterBy,
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
                    CustomText(
                      text: AppLocalizations.of(context)!.projectLength,
                      size: 18,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chooseLenght(EnumProjectLenght.less_than_one_month,
                              AppLocalizations.of(context)!.lessThanOneMonth),
                          chooseLenght(EnumProjectLenght.one_to_three_month,
                              AppLocalizations.of(context)!.oneToThreeMonths),
                          chooseLenght(EnumProjectLenght.three_to_six_month,
                              AppLocalizations.of(context)!.threeToSixMonths),
                          chooseLenght(EnumProjectLenght.more_than_six_month,
                              AppLocalizations.of(context)!.moreThanSixMonths),
                        ]),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    CustomText(
                      text: AppLocalizations.of(context)!.studentNeeded,
                      size: 18,
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      height: 35,
                      child: TextField(
                        controller: studentNeededController,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary),
                        textAlign: TextAlign.start,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    CustomText(
                      text: AppLocalizations.of(context)!.proposalLessThan,
                      size: 18,
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Theme.of(context).colorScheme.onPrimary)),
                      height: 35,
                      child: TextField(
                        controller: proposalsLessThanController,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary),
                        textAlign: TextAlign.start,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                        CustomButton(
                            onPressed: () {
                              studentNeededController.clear();
                              proposalsLessThanController.clear();
                              changeProjectLength(
                                  EnumProjectLenght.less_than_one_month);
                            },
                            text: AppLocalizations.of(context)!.clearFilter),
                        const SizedBox(
                          width: SpacingUtil.smallHeight,
                        ),
                        CustomButton(
                            onPressed: () {
                              submitFilter();
                            },
                            text: AppLocalizations.of(context)!.apply)
                      ],
                    ),
                    const SizedBox(
                      height: SpacingUtil.smallHeight,
                    ),
                  ],
                ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  IconButton forwardPage(BuildContext context) {
    return IconButton(
      iconSize: 22,
      onPressed:!isFound ? null:  (){
        setState(() {
          page++;
       });
      }, 
      icon: Icon(
        Icons.double_arrow_outlined,size:17,
        color: !isFound ? Colors.grey : Theme.of(context).colorScheme.onPrimary,
      )
    );
  }

  IconButton backwardPage(BuildContext context) {
    return IconButton(
      iconSize: 22,
      onPressed: page == 1 ? null : (){
        setState(() {
          page--;
        });
      }, 
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
          size: 17,
          color:page == 1 ?Colors.grey : Theme.of(context).colorScheme.onPrimary,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Project search',
        isBack: true,
        onPressed: () {},
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
                    readOnly: true,
                    prefixIcon: Icons.search,
                    controller: _searchController,
                    hintText: AppLocalizations.of(context)!.searchForProject,
                  ),
                ),
                // filter list
                IconButton(
                  onPressed: () {
                    onOpenedFilter(widget.parentContext);
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingUtil.smallHeight),
            const CustomDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                backwardPage(context),
                const SizedBox(width: 5,),
                CustomText(text: "Page: $page",size: 17,),
                const SizedBox(width: 5,),
                forwardPage(context),
            ],),
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
