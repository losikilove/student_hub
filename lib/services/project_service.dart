import 'dart:convert';
import 'package:student_hub/models/enums/enum_like_project.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/api_util.dart';

class ProjectService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/project';

  //View the all project
  static Future<http.Response> viewProject({required String token}) {
    const String url = _baseUrl;
    return http.get(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token));
  }

  static Future<http.Response> viewProjectFavorite(
      {required int studentId, required String token}) {
    String url = '${ApiUtil.baseUrl}/favoriteProject/$studentId';
    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  static Future<http.Response> likeProject(
      {required int studentId,
      required int projectID,
      required EnumLikeProject likedProject,
      required String token}) {
    String url = '${ApiUtil.baseUrl}/favoriteProject/$studentId';
    return http.patch(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
      body: jsonEncode(<String, dynamic>{
        'projectId': projectID,
        'disableFlag': likedProject.value,
      }),
    );
  }

  static Future<http.Response> viewProjectDetail(
      {required int id, required String token}) {
    String url = '$_baseUrl/$id';
    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  static Future<http.Response> searchProject(
      {required String search, required String token}) {
    String url = '$_baseUrl?title=$search';
    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  //company project - My compnay project or student join project
  static Future<http.Response> createProject({
    required ProjectCompanyModel project,
    required BuildContext context,
  }) async {
    const String url = _baseUrl;
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    int? id = userProvider.user?.company!.id;
    final token = userProvider.token!;
    return http.post(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          "companyId": id,
          "projectScopeFlag": project.projectScopeFlag,
          "title": project.title,
          "numberOfStudents": project.numberofStudent,
          "description": project.description,
          "typeFlag": 0
        }));
  }
}
