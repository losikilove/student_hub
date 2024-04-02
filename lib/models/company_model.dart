import 'package:student_hub/models/account_model.dart';
import 'package:student_hub/models/enums/enum_numberpeople.dart';
import 'package:student_hub/models/enums/enum_user.dart';

class CompanyModel extends AccountModel {
  String companyName;
  String website;
  EnumNumberPeople size;
  String description;

  CompanyModel({
    required super.id,
    super.role = EnumUser.company,
    required this.companyName,
    required this.website,
    required this.size,
    required this.description,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> jsonCompany) {
    return CompanyModel(
      id: jsonCompany['id'],
      companyName: jsonCompany['companyName'],
      website: jsonCompany['website'],
      size: EnumNumberPeople.toNumberPeople(jsonCompany['size']),
      description: jsonCompany['description'],
    );
  }
}
