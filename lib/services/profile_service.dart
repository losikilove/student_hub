import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/education_service.dart';
import 'package:student_hub/services/language_service.dart';
import 'package:student_hub/utils/api_util.dart';

class ProfileService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/profile';
  static const String _company = 'company';
  static const String _student = 'student';

  //create a company profile
  static Future<http.Response> createCompanyProfile({
    required String companyName,
    required int size,
    required String website,
    required String description,
    required String token,
  }) {
    const String url = '$_baseUrl/$_company';
    return http.post(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'companyName': companyName,
          'size': size,
          'website': website,
          'description': description,
        }));
  }

  //View the company profile
  static Future<http.Response> viewCompanyProfile({
    required String companyName,
    required String id,
    required String website,
    required String description,
    required String token,
  }) {
    String url = '$_baseUrl/$_company/$id';
    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  //update the company profile
  static Future<http.Response> updateCompanyProfile({
    required String companyName,
    required String id,
    required String website,
    required String description,
    required String token,
  }) {
    String url = '$_baseUrl/$_company/$id';
    return http.put(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'companyName': companyName,
          'website': website,
          'description': description,
        }));
  }

  // create student profile in step 1
  static Future<http.Response> createStudentProfileStep1({
    required TechStackModel techStack,
    required List<SkillSetModel> skills,
    required List<LanguageModel> languages,
    required List<EducationModel> educations,
    required BuildContext context,
  }) async {
    String url = '$_baseUrl/$_student';

    // get user provider to take data
    // get token
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;

    // POST tech-stack and skill set firstly
    final firstResponse = await http.post(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'techStackId': techStack.id,
          'skillSets': skills.map((skill) => skill.id).toList(),
        }));

    // created a new student not successfully
    // then return response
    if (firstResponse.statusCode != StatusCode.created.code) {
      return firstResponse;
    }

    // get student id
    Map<String, dynamic> result = ApiUtil.getResult(firstResponse);
    final studentId = result['id'] as int;

    // save result into the user provider
    userProvider.saveStudentAfterCreatedStudentProfile(
        id: studentId, techStack: techStack, skillSets: skills);

    // create languages for student
    final secondResponse = await LanguageService.couLanguage(
        token: token, studentId: result['id'], languages: languages);

    // created languages for student not successfully
    // then return response
    if (secondResponse.statusCode != StatusCode.ok.code) {
      return secondResponse;
    }

    // get info of language response
    List<LanguageModel> languagesReponse = LanguageModel.fromResponse(
      ApiUtil.getBody(secondResponse)['result'] as List<dynamic>,
    );

    // save the languages into user provider
    userProvider.saveStudentWhenUpdatedProfileStudent(
      languages: languagesReponse,
    );

    // create educations for student
    final thirdResponse = await EducationService.couEducation(
        token: token, studentId: studentId, educations: educations);

    // created educations for student not successfully
    // then return response
    if (thirdResponse.statusCode != StatusCode.ok.code) {
      return thirdResponse;
    }

    // get info of education response
    List<EducationModel> educationsReponse = EducationModel.fromResponse(
      ApiUtil.getBody(thirdResponse)['result'] as List<dynamic>,
    );

    // save the languages into user provider
    userProvider.saveStudentWhenUpdatedProfileStudent(
      educations: educationsReponse,
    );

    // last but not least, return the first reponse
    return firstResponse;
  }

  // create student profile step 3
  static Future<http.Response> createStudentProfileStep3(
      {required BuildContext context,
      required String resumeFilePath,
      required String transcriptFilePath}) async {
    // get token and student id
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;
    final studentId = userProvider.user!.student!.id;

    // PUT api resume
    final responseResume = await couResumeStudent(
      token: token!,
      studentId: studentId,
      filePath: resumeFilePath,
    );

    // if cannot PUT resume, return response
    if (responseResume.statusCode != StatusCode.ok.code) {
      return responseResume;
    }

    // save the resume into the user provider
    userProvider.saveStudentWhenUpdatedProfileStudent(
      resume: ApiUtil.getResult(responseResume)['resume'],
    );

    // PUT api transcript
    final responseTranscript = await couTranscriptStudent(
      token: token,
      studentId: studentId,
      filePath: transcriptFilePath,
    );

    // if cannot PUT transcript, return response
    if (responseTranscript.statusCode != StatusCode.ok.code) {
      return responseTranscript;
    }

    // save the transcript into the user provider
    userProvider.saveStudentWhenUpdatedProfileStudent(
      transcript: ApiUtil.getResult(responseResume)['transcript'],
    );

    return responseTranscript;
  }

  // cou (create or update) resume of student
  static Future<http.Response> couResumeStudent(
      {required String token,
      required int studentId,
      required String filePath}) async {
    final String url = '$_baseUrl/$_student/$studentId/resume';

    http.MultipartRequest request =
        http.MultipartRequest('PUT', Uri.parse(url));
    http.MultipartFile resumeFile =
        await http.MultipartFile.fromPath('file', filePath);
    request.files.add(resumeFile);
    request.headers.addAll(ApiUtil.getHeadersWithToken(token));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  // cout (create or update) transcript of student
  static Future<http.Response> couTranscriptStudent(
      {required String token,
      required int studentId,
      required String filePath}) async {
    final String url = '$_baseUrl/$_student/$studentId/transcript';

    http.MultipartRequest request =
        http.MultipartRequest('PUT', Uri.parse(url));
    http.MultipartFile resumeFile =
        await http.MultipartFile.fromPath('file', filePath);
    request.files.add(resumeFile);
    request.headers.addAll(ApiUtil.getHeadersWithToken(token));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response;
  }
}
