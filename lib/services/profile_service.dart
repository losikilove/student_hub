import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/utils/api_util.dart';

class ProfileService{
  static const String _baseUrl = '${ApiUtil.baseUrl}/profile';

  //create a company profile
  static Future<http.Response> createCompanyProfile({
    required String companyName,
    required int size,
    required String website,
    required String description,
    required String token,

  }){
    const String url = '$_baseUrl/company';
    return http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'companyName': companyName,
        'size': size,
        'website': website,
        'description': description,
      })
    );
  }
  //View the company profile
  static Future<http.Response> viewCompanyProfile({
    required String companyName,
    required String id,
    required String website,
    required String description,
    required String token,

  }){
    String url = '$_baseUrl/company/$id';
    return http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }
  //update the company profile 
  static Future<http.Response> updateCompanyProfile({
    required String companyName,
    required String id,
    required String website,
    required String description,
    required String token,

  }){
    String url = '$_baseUrl/company/$id';
    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'companyName': companyName,
        'website': website,
        'description': description,
      })
    );
  }
}