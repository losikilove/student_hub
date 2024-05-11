import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_project_status_flag.dart';
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/utils/text_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProjectScreen extends StatefulWidget {
  final ProjectMyCompanyModel projectCModel;
  const UpdateProjectScreen({super.key, required this.projectCModel});

  @override
  State<UpdateProjectScreen> createState() => _UpdateProjectScreenState();
}

class _UpdateProjectScreenState extends State<UpdateProjectScreen> {
  late EnumProjectLenght _projectDuration;
  late TextEditingController controllerTile;
  late TextEditingController controllerNumberOfStudent;
  late TextEditingController controllerDescription;

  void onSelectedDuration(EnumProjectLenght? duration) {
    setState(() {
      _projectDuration = duration!;
    });
  }

  //closed project
  void closeProject() async {
    final confirmedCloseProject = await _showDialogConfirmCloseProject();

    if (confirmedCloseProject == null || confirmedCloseProject == false) return;

    final confirmedKindOfClosedProject =
        await _showDialogWhichKindOfClosedProject();

    if (confirmedKindOfClosedProject == null) return;

    final response = await ProjectService.closeProject(
      project: widget.projectCModel,
      status: confirmedKindOfClosedProject == true
          ? EnumProjectStatusFlag.success
          : EnumProjectStatusFlag.fail,
      context: context,
    );

    if (response.statusCode == StatusCode.ok.code) {
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: AppLocalizations.of(context)!.close,
        textSubmit: 'Ok',
        submit: null,
      );

      NavigationUtil.toMainScreen(context, MainScreenIndex.dashboard);
      return;
    }

    // when expired token
    if (response.statusCode == StatusCode.unauthorized.code) {
      ApiUtil.handleExpiredToken(context: context);
      return;
    }

    //others
    ApiUtil.handleOtherStatusCode(context: context);
  }

  Future<bool?> _showDialogConfirmCloseProject() => showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'WARNING',
            style: TextStyle(color: Colors.red),
          ),
          content: CustomText(
            text: AppLocalizations.of(context)!.areYouSureToCloseThisProject,
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: 'Yes',
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: 'No',
            ),
          ],
        );
      });

  Future<void> updateProject() async {
    final confirmedUpdatedProject = await _showDialogConfirmUpdatedCProject();

    if (confirmedUpdatedProject == null || confirmedUpdatedProject == false)
      return;

    widget.projectCModel.title = controllerTile.text;
    widget.projectCModel.numberofStudent =
        int.parse(controllerNumberOfStudent.text);
    widget.projectCModel.description = controllerDescription.text;
    widget.projectCModel.projectScopeFlag = _projectDuration;

    final response = await ProjectService.updateProject(
      project: widget.projectCModel,
      context: context,
    );

    if (response.statusCode == StatusCode.ok.code) {
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: 'Update project success',
        textSubmit: 'Ok',
        submit: null,
      );

      NavigationUtil.toMainScreen(context, MainScreenIndex.dashboard);
      return;
    }

    // when expired token
    if (response.statusCode == StatusCode.unauthorized.code) {
      ApiUtil.handleExpiredToken(context: context);
      return;
    }

    //others
    ApiUtil.handleOtherStatusCode(context: context);
  }

  @override
  void initState() {
    super.initState();
    _projectDuration = EnumProjectLenght.toProjectLenght(
        widget.projectCModel.projectScopeFlag.value);
    controllerTile = TextEditingController(text: widget.projectCModel.title);
    controllerNumberOfStudent = TextEditingController(
        text: widget.projectCModel.numberofStudent.toString());
    controllerDescription =
        TextEditingController(text: widget.projectCModel.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          onPressed: () {},
          currentContext: context,
          title: AppLocalizations.of(context)!.updateProject,
        ),
        body: InitialBody(
          left: 0,
          top: 0,
          right: 0,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomButton(
                    onPressed: closeProject,
                    text: AppLocalizations.of(context)!.closeProject,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                      CustomText(
                        text: AppLocalizations.of(context)!.updateProject,
                        isBold: true,
                        size: TextUtil.textSize,
                      ),
                      const SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                      TextField(
                        controller: controllerTile,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.projectName,
                          hintText: AppLocalizations.of(context)!.projectName,
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hoverColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),

                      TextField(
                        controller: controllerNumberOfStudent,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.numberOfStudent,
                          hintText:
                              AppLocalizations.of(context)!.numberOfStudent,
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hoverColor: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      CustomText(
                        text: AppLocalizations.of(context)!
                            .howLongWillYourProjectTake,
                        isBold: true,
                      ),
                      // select duration radio
                      ListTile(
                        horizontalTitleGap: 0.0,
                        contentPadding: const EdgeInsets.only(),
                        title: CustomText(
                            text: EnumProjectLenght.less_than_one_month.name),
                        leading: Radio<EnumProjectLenght>(
                          activeColor: Theme.of(context).colorScheme.onPrimary,
                          value: EnumProjectLenght.less_than_one_month,
                          groupValue: _projectDuration,
                          onChanged: onSelectedDuration,
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: 0.0,
                        contentPadding: const EdgeInsets.only(),
                        title: CustomText(
                            text: EnumProjectLenght.one_to_three_month.name),
                        leading: Radio<EnumProjectLenght>(
                          activeColor: Theme.of(context).colorScheme.onPrimary,
                          value: EnumProjectLenght.one_to_three_month,
                          groupValue: _projectDuration,
                          onChanged: onSelectedDuration,
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: 0.0,
                        contentPadding: const EdgeInsets.only(),
                        title: CustomText(
                            text: EnumProjectLenght.three_to_six_month.name),
                        leading: Radio<EnumProjectLenght>(
                          activeColor: Theme.of(context).colorScheme.onPrimary,
                          value: EnumProjectLenght.three_to_six_month,
                          groupValue: _projectDuration,
                          onChanged: onSelectedDuration,
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: 0.0,
                        contentPadding: const EdgeInsets.only(),
                        title: CustomText(
                            text: EnumProjectLenght.more_than_six_month.name),
                        leading: Radio<EnumProjectLenght>(
                          activeColor: Theme.of(context).colorScheme.onPrimary,
                          value: EnumProjectLenght.more_than_six_month,
                          groupValue: _projectDuration,
                          onChanged: onSelectedDuration,
                        ),
                      ),
                      const SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                      TextField(
                        controller: controllerDescription,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.description,
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hoverColor: Colors.black,
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: AppLocalizations.of(context)!.cancel,
              ),
            ),
            Expanded(
              child: CustomButton(
                onPressed: updateProject,
                text: AppLocalizations.of(context)!.update,
              ),
            ),
          ],
        ));
  }

  Future<bool?> _showDialogConfirmUpdatedCProject() => showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'WARNING',
            style: TextStyle(color: Colors.red),
          ),
          content: CustomText(
            text: AppLocalizations.of(context)!.areYouSureToUpdateThisProject,
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: AppLocalizations.of(context)!.yes,
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: AppLocalizations.of(context)!.no,
            ),
          ],
        );
      });

  Future<bool?> _showDialogWhichKindOfClosedProject() => showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.closedProjectPopupTitle,
            style: TextStyle(color: Colors.red),
          ),
          content: CustomText(
            text: AppLocalizations.of(context)!.closedProjectPopupContent,
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: AppLocalizations.of(context)!.closedFailureProject,
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: AppLocalizations.of(context)!.closedSuccessProject,
            ),
          ],
        );
      });
}
