import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
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
    required String token,
    required int studentId,
  }) async {
    String url = '$_baseUrl/$_student';

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

    // create languages for student
    final secondResponse = await LanguageService.couEducation(
        studentId: studentId, languages: languages);

    // created languages for student not successfully
    // then return response
    if (secondResponse.statusCode != StatusCode.ok.code) {
      return secondResponse;
    }

    // create educations for student
    return EducationService.couEducation(
        studentId: studentId, educations: educations);
  }
}
