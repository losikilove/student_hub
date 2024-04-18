import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
class StudentProfile {
  final int id;
  final int studentProfileId;
  final String email;
  final String fullname;
  final String resume;
  final String transcript;
  final TechStackModel techStack;
  final List<SkillSetModel> skillSets; 
  final List<LanguageModel> languages;
  final List<EducationModel> educations;
  final List<ExperienceModel> experiences; 

  StudentProfile({
    required this.id,
    required this.studentProfileId,
    required this.email,
    required this.resume,
    required this.transcript,
    required this.fullname,
    required this.techStack,
    required this.skillSets,
    required this.languages,
    required this.educations,
    required this.experiences,
  });

  static StudentProfile fromJson(http.Response response) {
   final Map<String, dynamic> profileBody = json.decode(response.body);
    final Map<String, dynamic> profileData = profileBody['result'];
    String getResumes = profileData['resume'] ?? 'Not uploaded yet';
    String getTranscripts = profileData['transcript'] ?? 'Not uploaded yet';
    return StudentProfile(
      id: profileData['id'],
      studentProfileId: profileData['userId'],
      email: profileData['email'],
      fullname: profileData['fullname'],
      techStack: TechStackModel.fromJson(profileData['techStack']),
      resume: getResumes,
      transcript: getTranscripts,
      skillSets: SkillSetModel.fromResponse(profileData['skillSets']),
      languages: LanguageModel.fromResponse(profileData['languages']),
      educations: EducationModel.fromResponse(profileData['educations']),
      experiences: ExperienceModel.fromResponse(profileData['experiences']),
    );
  }
}
