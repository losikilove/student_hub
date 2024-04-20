import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components//custom_future_builder.dart';
import 'package:student_hub/models/candidate_profile_model.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';

class CandidateProfileScreen extends StatefulWidget {
  final String studentId;
  const CandidateProfileScreen({super.key, required this.studentId});

  @override
  State<CandidateProfileScreen> createState() => _CandidateProfileScreenState();
}

class _CandidateProfileScreenState extends State<CandidateProfileScreen> {
  Future<StudentProfile> initializeProfile() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token;
    final response = await ProfileService.getProfileCandidate(
        studentId: widget.studentId, token: token!);
    return StudentProfile.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Student profile',
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

  Column profileItem(StudentProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: profile.fullname,
                    isBold: true,
                    size: 25,
                  ),
                  CustomText(
                    text: profile.techStack.name,
                    size: 22,
                  ),
                ],
              ),
            ),
          ],
        ),
        const CustomDivider(),
        const CustomText(
          text: "Communications",
          isBold: true,
          size: 19,
        ),
        CustomText(
          text: 'gmail: ${profile.email}',
          size: 15,
        ),
        const CustomDivider(),
        const CustomText(
          text: "Skills",
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: profile.skillSets.isNotEmpty
              ? profile.skillSets.length * 58.0
              : 20,
          decoration: decoration(),
          child: ListView.builder(
            itemCount: profile.skillSets.length,
            itemBuilder: (context, index) {
              SkillSetModel skillset = profile.skillSets[index];
              return ListTile(
                title: Text(
                  skillset.name,
                  style: textStyleTitle(),
                ),
                leading: iconLeading(),
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const CustomText(
          text: "Educations",
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: profile.educations.isNotEmpty
              ? profile.educations.length * 80.0
              : 10,
          decoration: decoration(),
          child: ListView.builder(
            itemCount: profile.educations.length,
            itemBuilder: (context, index) {
              EducationModel education = profile.educations[index];
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
          height: 20,
        ),
        const CustomText(
          text: "Experience",
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(7.0),
          height: profile.experiences.isNotEmpty
              ? profile.experiences.length * 250.0
              : 10,
          decoration: decoration(),
          child: ListView.builder(
            itemCount: profile.experiences.length,
            itemBuilder: (context, index) {
              ExperienceModel experience = profile.experiences[index];
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 7,
                      color: Colors.black,
                      thickness: 1,
                      indent: 10,
                      endIndent: 12,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Title: ${experience.getTile}",
                      style: textStyleTitle(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Start: ${experience.getMonthStart}-${experience.getYearStart}",
                      style: textStyleSubtitle(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "End:${experience.getMonthEnd}-${experience.getYearEnd}",
                      style: textStyleSubtitle(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Descriptions: ${experience.getDescription}",
                      style: textStyleSubtitle(),
                      softWrap: true,
                    ),
                    ExpansionTile(
                      title: Text(
                        "Show skills",
                        style: textStyleTitle(),
                      ),
                      iconColor: Colors.black,
                      collapsedIconColor: Colors.black,
                      children: [
                        Container(
                          height: experience.getSkills.isNotEmpty
                              ? experience.getSkills.length * 50.0
                              : 10,
                          decoration: decoration(),
                          child: ListView.builder(
                            itemCount: experience.getSkills.length,
                            itemBuilder: (context, index) {
                              SkillSetModel skillset =
                                  experience.getSkills[index];
                              return ListTile(
                                title: Text(
                                  skillset.name,
                                  style: textStyleTitle(),
                                ),
                                leading: iconLeading(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ]);
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const CustomText(
          text: "Language",
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: profile.languages.isNotEmpty
              ? profile.languages.length * 68.0
              : 10,
          decoration: decoration(),
          child: ListView.builder(
            itemCount: profile.languages.length,
            itemBuilder: (context, index) {
              LanguageModel language = profile.languages[index];
              return ListTile(
                title: Text(
                  language.getLanguage,
                  style: textStyleTitle(),
                ),
                subtitle: Text(
                  language.getLevel,
                  style: textStyleSubtitle(),
                ),
                leading: iconLeading(),
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomText(
          text: "Resume",
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(7.0),
          height: 90,
          decoration: decoration(),
          child: Row(
            children: [
              Flexible(
                  child: Text(
                profile.resume,
                style: textStyleTitle(),
              )),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const CustomText(
          text: "Transcript",
          isBold: true,
          size: 19,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(7.0),
          height: 90,
          decoration: decoration(),
          child: Row(
            children: [
              Flexible(
                  child: Text(
                profile.transcript,
                style: textStyleTitle(),
              )),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
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
