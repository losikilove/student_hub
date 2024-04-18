import 'dart:convert';

import 'package:http/http.dart' as http;

class TechStack {
  final int id;
  final String name;

  TechStack({
    required this.id,
    required this.name,
  });

  factory TechStack.fromJson(Map<String, dynamic> json) {
    return TechStack(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Language {
  final int id;
  final String languageName;
  final String level;

  Language({
    required this.id,
    required this.languageName,
    required this.level,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      languageName: json['languageName'],
      level: json['level'],
    );
  }
}

class Education {
  final int id;
  final String schoolName;
  final int startYear;
  final int endYear;

  Education({
    required this.id,
    required this.schoolName,
    required this.startYear,
    required this.endYear,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      schoolName: json['schoolName'],
      startYear: json['startYear'],
      endYear: json['endYear'],
    );
  }
}

class Skillset {
  final int id;
  final String skillSetname;
  

  Skillset({
    required this.id,
    required this.skillSetname,
 
  });

  factory Skillset.fromJson(Map<String, dynamic> json) {
    return Skillset(
      id: json['id'],
      skillSetname: json['name'],
    );
  }
}

class Experience {
  final int id;
  final String title;
  final String startMonth;
  final String endMonth;
  final String description;
  final List<Skillset> skillSets; 

  Experience({
    required this.id,
    required this.title,
    required this.startMonth,
    required this.endMonth,
    required this.description,
    required this.skillSets,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      title: json['title'],
      startMonth: json['startMonth'],
      endMonth: json['endMonth'],
      description: json['description'],
      skillSets: (json['skillSets'] as List<dynamic>)
          .map((skillJson) => Skillset.fromJson(skillJson))
          .toList(),
    );
  }
}

class StudentProfile {
  final int id;
  final int studentProfileId;
  final String email;
  final String fullname;
  final String resume;
  final String transcript;
  final TechStack techStack;
  final List<Skillset> skillSets; 
  final List<Language> languages;
  final List<Education> educations;
  final List<Experience> experiences; 

  StudentProfile({
    required this.id,
    required this.studentProfileId,
    required this.email,
    required this.resume,
    required this.transcript,
    required this.fullname,
    required this.techStack,
    required this.skillSets,
    required this.languages,
    required this.educations,
    required this.experiences,
  });

  static StudentProfile fromJson(http.Response response) {
   final Map<String, dynamic> profileBody = json.decode(response.body);
    final Map<String, dynamic> profileData = profileBody['result'];
    String getResumes = profileData['resume'] ?? 'Not uploaded yet';
    String getTranscripts = profileData['transcript'] ?? 'Not uploaded yet';
    return StudentProfile(
      id: profileData['id'],
      studentProfileId: profileData['userId'],
      email: profileData['email'],
      fullname: profileData['fullname'],
      techStack: TechStack.fromJson(profileData['techStack']),
      resume: getResumes,
      transcript: getTranscripts,
      skillSets: (profileData['skillSets'] as List<dynamic>)
           .map((skillJson) => Skillset.fromJson(skillJson))
           .toList(),
      languages: (profileData['languages'] as List<dynamic>)
          .map((languageJson) => Language.fromJson(languageJson))
          .toList(),
      educations: (profileData['educations'] as List<dynamic>)
          .map((educationJson) => Education.fromJson(educationJson))
          .toList(),
      experiences: (profileData['experiences'] as List<dynamic>)
          .map((experienceJson) => Experience.fromJson(experienceJson))
          .toList(),
    );
  }
}