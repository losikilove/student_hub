import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ProposalAndCandidateModel{
  final int id;
  final int projectId;
  final int studentId;
  final String coverLetter;
  final int statusFlag;
  final int disableFlag;
  final String resume;
  final String createdDate;
  final String transcript;
  final TechStackModel techStack;
  final List<EducationModel> education;

  ProposalAndCandidateModel({
    required this.id,
    required this.projectId,
    required this.studentId,
    required this.resume,
    required this.transcript,
    required this.coverLetter,
    required this.statusFlag,
    required this.createdDate,
    required this.disableFlag,
    required this.education,
    required this.techStack,
  });
  static ProposalAndCandidateModel fromJson(http.Response response){
      final Map<String, dynamic> profileBody = json.decode(response.body);
    final Map<String, dynamic> profileData = profileBody['result'];
    String getResumes = profileData['student']['resume'] ?? 'Resume not uploaded yet';
    String getTranscripts = profileData['student']['transcript'] ?? 'Transcript not uploaded yet';
     String getCoverLetter = profileData['coverLetter'] ?? 'CoverLetter not uploaded yet';
    return ProposalAndCandidateModel(
      id: profileData['id'],
      studentId: profileData['studentId'],
      coverLetter: getCoverLetter,
      createdDate: profileData['createdAt'],
      projectId: profileData['projectId'],
      statusFlag: profileData['statusFlag'],
      disableFlag: profileData['disableFlag'],
      resume: getResumes,
      transcript: getTranscripts,
      education: EducationModel.fromResponse(profileData['student']['educations']),
      techStack: TechStackModel.fromJson(profileData['student']['techStack']),
    );
  }

}