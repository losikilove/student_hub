import 'package:student_hub/models/account_model.dart';
import 'package:student_hub/models/enums/enum_user.dart';

class CompanyModel extends AccountModel {
  CompanyModel({
    required super.id,
    required super.fullname,
    super.role = EnumUser.company,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> jsonCompany) {
    return CompanyModel(
      id: jsonCompany['id'],
      fullname: jsonCompany['fullname'],
    );
  }
}
