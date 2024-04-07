import 'package:student_hub/models/account_model.dart';
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';

class StudentModel extends AccountModel {
  TechStackModel techStack;
  List<SkillSetModel> skillSets;
  List<LanguageModel> languages;
  List<EducationModel> educations;
  List<ExperienceModel> experiences;
  dynamic resume;
  dynamic transcript;

  StudentModel({
    required super.id,
    super.role = EnumUser.student,
    required this.techStack,
    required this.skillSets,
    this.languages = const [],
    this.educations = const [],
    this.experiences = const [],
    this.resume,
    this.transcript,
  });

  factory StudentModel.fromJson(Map<String, dynamic> jsonStudent) {
    return StudentModel(
      id: jsonStudent['id'],
      techStack: TechStackModel(jsonStudent['techStack']['id'] as int,
          jsonStudent['techStack']['name'] as String),
      skillSets: (jsonStudent['skillSets'] as List<dynamic>)
          .map(
            (element) => SkillSetModel(
              element['id'] as int,
              element['name'] as String,
            ),
          )
          .toList(),
      languages: (jsonStudent['languages'] as List<dynamic>)
          .map(
            (element) => LanguageModel(
              element['id'] as int,
              element['language'] as String,
              element['level'] as String,
            ),
          )
          .toList(),
      educations: (jsonStudent['educations'] as List<dynamic>)
          .map(
            (element) => EducationModel(
              element['id'] as int,
              element['schoolName'] as String,
              element['startYear'] as int,
              element['endYear'] as int,
            ),
          )
          .toList(),
      experiences: ExperienceModel.fromResponse(
          jsonStudent['experiences'] as List<dynamic>),
      resume: jsonStudent['resume'],
      transcript: jsonStudent['transcript'],
    );
  }
}
