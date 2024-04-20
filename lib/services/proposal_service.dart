import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/enums/enum_disable_flag.dart';
import 'package:student_hub/models/enums/enum_status_flag.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:http/http.dart' as http;

class ProposalService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/proposal';

  static Future<http.Response> getAllProjectMyStudent(
      {required BuildContext context}) {
    const String url = '$_baseUrl/project';
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    int? id = userProvider.user!.student!.id;
    final token = userProvider.token!;
    return http.get(
      Uri.parse("$url/$id"),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  static Future<http.Response> postProposal({
    required BuildContext context,
    required int projectId,
    required String coverLetter,
    required EnumStatusFlag statusFlag,
    EnumDisableFlag disableFlag = EnumDisableFlag.enable,
  }) {
    const String url = _baseUrl;
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;
    int studentId = userProvider.user!.student!.id;

    return http.post(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
      body: jsonEncode(<String, dynamic>{
        'projectId': projectId,
        'studentId': studentId,
        'coverLetter': coverLetter,
        'statusFlag': statusFlag.value,
        'disableFlag': disableFlag.value,
      }),
    );
  }

  static Future<http.Response> getProposalByProject(
      {required BuildContext context,
      required int projectId,
      String? q,
      int offset = 0,
      int limit = 100,
      String? order,
      EnumStatusFlag? statusFlag}) {
    String url =
        '$_baseUrl/getByProjectId/$projectId?${q == null ? '' : 'q=$q'}&offset=$offset&limit=$limit&${order == null ? '' : 'order=$order'}&${statusFlag == null ? '' : 'statusFlag=${statusFlag.value}'}';
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;

    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  static Future<http.Response> sendHiredForProposalStudent(
      {required BuildContext context, required int proposalId}) {
    String url = '$_baseUrl/$proposalId';

    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;

    return http.patch(
      Uri.parse(url),
      body: jsonEncode(
        <String, dynamic>{
          'statusFlag': EnumStatusFlag.offer.value,
          'disableFlag': EnumDisableFlag.enable.value,
        },
      ),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }
}
