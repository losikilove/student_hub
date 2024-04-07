import 'package:flutter/material.dart';
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/enums/enum_numberpeople.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/student_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/models/company_model.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  UserModel? _user;

  // get token of user
  String? get token => _token;
  // get user
  UserModel? get user => _user;

  // sign in
  Future<void> signin(String token) async {
    _token = token;

    // get response from me-API
    final response = await AuthService.me(token: token);

    // get result of me-API response-body
    final result = ApiUtil.getResult(response);

    // save the user from me-API
    _user = UserModel.fromJson(result);

    notifyListeners();
  }

  // switch to rest role
  void changeToRestRole() {
    _user!.changeToRestRole();
    notifyListeners();
  }

  // create company profile
  void saveCompanyAfterCreatedCompanyProfile({
    required int id,
    required String companyName,
    required String website,
    required String description,
    required EnumNumberPeople size,
  }) {
    _user?.company = CompanyModel(
      id: id,
      companyName: companyName,
      website: website,
      size: size,
      description: description,
    );

    notifyListeners();
  }

  // update company profile
  void saveCompanyWhenUpdatedProfileCompany({
    required String companyName,
    required String website,
    required String description,
  }) {
    _user?.company = CompanyModel(
      id: _user!.company!.id,
      companyName: companyName,
      website: website,
      size: _user!.company!.size,
      description: description,
    );

    notifyListeners();
  }

  // create student profile
  void saveStudentAfterCreatedStudentProfile({
    required int id,
    required TechStackModel techStack,
    required List<SkillSetModel> skillSets,
  }) {
    _user?.student =
        StudentModel(id: id, techStack: techStack, skillSets: skillSets);
    notifyListeners();
  }

  // update student profile
  void saveStudentWhenUpdatedProfileStudent({
    TechStackModel? techStack,
    List<SkillSetModel>? skillSets,
    List<LanguageModel>? languages,
    List<EducationModel>? educations,
    List<ExperienceModel>? experiences,
    dynamic resume,
    dynamic transcript,
  }) {
    // update techstack of student
    if (techStack != null) {
      _user?.student?.techStack = techStack;
    }

    // update skillsets of student
    if (skillSets != null) {
      _user?.student?.skillSets = skillSets;
    }

    // update languages of student
    if (languages != null) {
      _user?.student?.languages = languages;
    }

    // update educations of student
    if (educations != null) {
      _user?.student?.educations = educations;
    }

    // update experiences of student
    if (experiences != null) {
      _user?.student?.experiences = experiences;
    }

    // update resume of student
    if (resume != null) {
      _user?.student?.resume = resume;
    }

    // update transcript of student
    if (transcript != null) {
      _user?.student?.transcript = transcript;
    }

    notifyListeners();
  }

  // sign out
  void signout() async {
    // call API logout
    await AuthService.signout(token: _token!);

    // set null for whole attributes
    _token = null;
    _user = null;
    notifyListeners();
  }
}
