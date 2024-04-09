import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_expansion_tile.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/spacing_util.dart';

class StudentViewProfileScreen extends StatefulWidget {
  const StudentViewProfileScreen({super.key});

  @override
  State<StudentViewProfileScreen> createState() =>
      _StudentViewProfileScreenState();
}

class _StudentViewProfileScreenState extends State<StudentViewProfileScreen> {
  void onPressed() {}

  // switch to update-company-profile screen
  void onSwitchedToStudentUpdateProfile() {
    // TODO:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // update student button
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                size: CustomButtonSize.small,
                onPressed: onSwitchedToStudentUpdateProfile,
                text: 'Update',
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // title of screen
            const Center(
              child: CustomText(
                text: 'Your student profile',
                isBold: true,
                size: 25,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // info area
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final student = userProvider.user?.student;
                    return Column(
                      children: [
                        // techstack info
                        _expansionTile(
                          title: 'Techstack',
                          expandedChild: CustomText(
                            text: student?.techStack.name ?? '',
                            textColor:
                                Theme.of(context).colorScheme.onBackground,
                            isBold: true,
                          ),
                        ),
                        const SizedBox(
                          height: SpacingUtil.smallHeight,
                        ),
                        // skillsets info
                        _expansionTile(
                          title: 'Skill-set',
                          expandedChild: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: student?.skillSets.length ?? 0,
                              itemBuilder: (context, index) {
                                final skillset = student!.skillSets[index];
                                return CustomText(
                                  text: skillset.name,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  isBold: true,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: SpacingUtil.smallHeight,
                        ),
                        // languages info
                        _expansionTile(
                          title: 'Languages',
                          expandedChild: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: student?.languages.length ?? 0,
                              itemBuilder: (context, index) {
                                final language = student!.languages[index];
                                return CustomText(
                                  text: language.toString(),
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  isBold: true,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: SpacingUtil.smallHeight,
                        ),
                        // educations info
                        _expansionTile(
                          title: 'Educations',
                          expandedChild: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: student?.educations.length ?? 0,
                              itemBuilder: (context, index) {
                                final education = student!.educations[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomDivider(
                                      isFullWidth: true,
                                    ),
                                    // school name
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: CustomText(
                                        text: education.getSchoolName,
                                        size: 14.5,
                                        isOverflow: true,
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        isBold: true,
                                      ),
                                    ),
                                    // school year
                                    Text(
                                      education.getSchoolYear,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontStyle: FontStyle.italic,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: SpacingUtil.smallHeight,
                        ),
                        // experiences info
                        _expansionTile(
                          title: 'Experiences',
                          expandedChild: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: student?.experiences.length ?? 0,
                              itemBuilder: (context, index) {
                                final exp = student!.experiences[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomDivider(
                                      isFullWidth: true,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: CustomText(
                                                text: exp.getTile,
                                                size: 14.5,
                                                isOverflow: true,
                                                textColor: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                isBold: true,
                                              ),
                                            ),
                                            Text(
                                              exp.getDuration,
                                              style: TextStyle(
                                                fontSize: 14.5,
                                                fontStyle: FontStyle.italic,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    CustomText(
                                      text: exp.getDescription,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 22.0),
                                      child: CustomText(
                                        text: exp.getSkills
                                            .map((skill) => skill.name)
                                            .toList()
                                            .toString(),
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        isItalic: true,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: SpacingUtil.smallHeight,
                        ),
                        // resume info
                        _expansionTile(
                          title: 'Resume',
                          expandedChild: CustomText(
                            text: student?.resume == null
                                ? 'none'
                                : student!.resume.toString(),
                            textColor:
                                Theme.of(context).colorScheme.onBackground,
                            isBold: true,
                          ),
                        ),
                        const SizedBox(
                          height: SpacingUtil.smallHeight,
                        ),
                        // transcript info
                        _expansionTile(
                          title: 'Academic transcript',
                          expandedChild: CustomText(
                            text: student?.transcript == null
                                ? 'none'
                                : student!.transcript.toString(),
                            textColor:
                                Theme.of(context).colorScheme.onBackground,
                            isBold: true,
                          ),
                        ),
                        const SizedBox(
                          height: SpacingUtil.smallHeight,
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _expansionTile({
    required String title,
    required Widget expandedChild,
  }) {
    return CustomExpansionTile(
      context: context,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: 8,
          ),
          child: expandedChild,
        ),
      ],
    );
  }
}