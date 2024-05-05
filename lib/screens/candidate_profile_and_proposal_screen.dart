import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/enums/enum_status_flag.dart';
import 'package:student_hub/models/proposal_and_candidate_model.dart';
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components//custom_future_builder.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/proposal_service.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CandidateProfileAndProposalScreen extends StatefulWidget {
  final String studentName;
  final String proposalName;
  final String proposalId;
  const CandidateProfileAndProposalScreen(
    {
      super.key, 
      required this.proposalId,
      required this.studentName,
      required this.proposalName
    });

  @override
  State<CandidateProfileAndProposalScreen> createState() => _CandidateProfileAndProposalScreenState();
}
  
    //view candidate profile screen
 
class _CandidateProfileAndProposalScreenState extends State<CandidateProfileAndProposalScreen> {
  Future<ProposalAndCandidateModel> initializeProfile() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token;
    final response = await ProposalService.getProposalAndProfileCandidate(
      proposalId: widget.proposalId, token: token!);
    return ProposalAndCandidateModel.fromJson(response);
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: AppLocalizations.of(context)!.studentProfileAndProposal,
        isBack: true,
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
          child: SingleChildScrollView(
              child: CustomFutureBuilder(
        future: initializeProfile(),
        widgetWithData: (snapshot) {
          return profileItem(snapshot.data!);
        },
        widgetWithError: (snapshot) {
          return CustomText(
            text: '${snapshot.error}',
            textColor: Colors.red,
          );
        },
      ))),
    );
  }

  Column profileItem(ProposalAndCandidateModel proposalAndCandidate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const CustomText(text: "Proposal Detail", isBold: true, size: 25),
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     CustomText(text: "Proposal Detail", isBold: true, size: 25),
        //   ],
        // ),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.proposalName,
                    isBold: true,
                    size: 23,
                  ),
                  CustomText(
                    text: "${AppLocalizations.of(context)!.status}: ${EnumStatusFlag.toStatusFlag(proposalAndCandidate.statusFlag).name}",
                    size: 18,
                  ),
                  CustomText(
                    text: "Project id: ${proposalAndCandidate.projectId}",
                    size: 18,
                  ),
                  CustomText(
                    text: "Time created: ${DateFormat('dd-MM-yyyy').format(
                      DateTime.parse(proposalAndCandidate.createdDate), )}",
                    size: 18,
                  ),
        
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
                color: Colors.white,
                child: const Icon(
                  Icons.business_center,
                  size: 90,
                  color: Colors.black,
                )),    
          ],
        ),
        const CustomDivider(),
        CustomText(text: AppLocalizations.of(context)!.candidateProfile, isBold: true, size: 20),
        const SizedBox(
          height: SpacingUtil.smallHeight,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                color: Colors.white,
                child: const Icon(
                  Icons.person,
                  size: 90,
                  color: Colors.black,
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.studentName,
                    isBold: true,
                    size: 22,
                  ),
                  CustomText(
                    text: proposalAndCandidate.techStack.name,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CustomText(
          text: AppLocalizations.of(context)!.educations,
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 2,
        ),
        Container(
          height: proposalAndCandidate.education.isNotEmpty
              ? proposalAndCandidate.education.length * 65.0
              : 10,
          decoration: decoration(),
          child: ListView.builder(
            itemCount: proposalAndCandidate.education.length,
            itemBuilder: (context, index) {
              EducationModel education = proposalAndCandidate.education[index];
              return ListTile(
                title: Text(
                  education.getSchoolName,
                  style: textStyleTitle(),
                ),
                subtitle: Text(
                  "${education.getBeginningOfSchoolYear} - ${education.getEndOfSchoolYear}",
                  style: textStyleSubtitle(),
                ),
                leading: iconLeading(),
              );
            },
          ),
        ),
        const SizedBox(
          height:SpacingUtil.mediumHeight,
        ),
       
        CustomText(
          text: AppLocalizations.of(context)!.resume,
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.all(7.0),
          decoration: decoration(),
          child: Row(
            children: [
              Flexible(
                  child: Text(
                proposalAndCandidate.resume,  
                style: textStyleTitle(),
              )),
            ],
          ),
        ),
        const SizedBox(
          height:SpacingUtil.mediumHeight,
        ),
        CustomText(
          text: AppLocalizations.of(context)!.coverLetter,
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.all(7.0),
          decoration: decoration(),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  proposalAndCandidate.coverLetter,  
                  style: textStyleTitle(),
              )),
            ],
          ),
        ),
        const SizedBox(
           height:SpacingUtil.mediumHeight,
        ),
        CustomText(
          text: AppLocalizations.of(context)!.transcript,
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.all(7.0),
          decoration: decoration(),
          child: Row(
            children: [
              Flexible(
                  child: Text(
                proposalAndCandidate.transcript,
                style: textStyleTitle(),
              )),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle textStyleSubtitle() =>
      const TextStyle(fontSize: 17, color: Colors.black);

  TextStyle textStyleTitle() => const TextStyle(
      color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500);

  Icon iconLeading() => const Icon(Icons.arrow_circle_right_outlined,
      size: 19, color: Colors.black);

  BoxDecoration decoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
    );
  }
}
