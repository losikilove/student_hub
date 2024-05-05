import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_confirm.dart';
import 'package:student_hub/models/enums/enum_status_flag.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/models/proposal_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/services/proposal_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ApproveProjectScreen extends StatefulWidget {
  final ProposalStudent proposal;

  const ApproveProjectScreen({super.key, required this.proposal});

  @override
  State<ApproveProjectScreen> createState() => _ApproveProjectScreenState();
}

class _ApproveProjectScreenState extends State<ApproveProjectScreen> {
  bool _isLoadedProjectDetail = false;

  // approve the project
  Future<void> onApproved() async {
    final confirmApprovedProject = await popupConfirm(
      context: context,
      content: AppLocalizations.of(context)!.areYouSureToApproveThisProject,
    );

    if (confirmApprovedProject == false || confirmApprovedProject == null) {
      return;
    }

    // loading in progress
    showCircleProgress(context: context);
    final response = await ProposalService.approveProject(
      context: context,
      proposalId: widget.proposal.id,
    );
    Navigator.pop(context);

    // response is ok
    if (response.statusCode == StatusCode.ok.code) {
      setState(() {
        widget.proposal.statusFlag = EnumStatusFlag.hired.value;
      });

      return;
    }

    // expired token
    if (response.statusCode == StatusCode.unauthorized.code) {
      ApiUtil.handleExpiredToken(context: context);
      return;
    }

    // others
    ApiUtil.handleOtherStatusCode(context: context);
  }

  // initialize the project detail
  Future<ProjectModel> initializeDetailProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token;
    final response = await ProjectService.viewProjectDetail(
        id: widget.proposal.projectId, token: token!);

    if (response.statusCode == StatusCode.ok.code) {
      setState(() {
        _isLoadedProjectDetail = true;
      });
    }

    return ProjectModel.fromDetailResponse(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: AppLocalizations.of(context)!.approveProject,
        isBack: true,
        onPressed: () {},
        currentContext: context,
        iconButton: null,
      ),
      body: InitialBody(
        child: SingleChildScrollView(
          child: CustomFutureBuilder(
            future: initializeDetailProject(),
            widgetWithData: (snapshot) {
              final project = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Project: ${project.title}",
                    isBold: true,
                    size: 23,
                  ),
                  const CustomDivider(),
                  // desirements of student text
                  CustomText(
                    size: 18,
                    text: AppLocalizations.of(context)!.studentAreLookingFor,
                  ),
                  CustomBulletedList(
                    textSize: 18,
                    listItems: project.description.split(','),
                  ),
                  const CustomDivider(),
                  // scope of project
                  _projectRequirement(
                    Icons.alarm,
                    AppLocalizations.of(context)!.projectScope,
                    project.projectScopeFlag.name,
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  // Required students
                  _projectRequirement(
                    Icons.people_outline,
                    AppLocalizations.of(context)!.requiredStudents,
                    '${project.numberofStudent} students',
                  ),
                ],
              );
            },
            widgetWithError: (snapshot) {
              return CustomText(
                text: AppLocalizations.of(context)!.sorySomethingWentWrong,
                textColor: Colors.red,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 0,
        color: Theme.of(context).colorScheme.background,
        child: _isLoadedProjectDetail == false
            ? const Center()
            : CustomButton(
                size: CustomButtonSize.small,
                onPressed: onApproved,
                text: widget.proposal.statusFlag == EnumStatusFlag.offer.value
                    ? 'Approve'
                    : 'Approved',
                buttonColor: Theme.of(context).colorScheme.secondary,
                isDisabled:
                    widget.proposal.statusFlag != EnumStatusFlag.offer.value,
              ),
      ),
    );
  }

  Widget _projectRequirement(
      IconData icon, String title, String detailRequirement) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 42,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                size: 20,
              ),
              CustomBulletedList(
                textSize: 18,
                listItems: detailRequirement.split('\n'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
