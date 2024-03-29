import 'package:student_hub/models/enums/enum_user.dart';

abstract class AccountModel {
  final int id;
  String fullname;
  EnumUser role;

  AccountModel({required this.id, required this.fullname, required this.role});
}
