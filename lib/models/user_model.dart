import 'package:hirewise/models/aptitude_test_result_model.dart';
import 'package:hirewise/models/job_model.dart';
import 'package:hirewise/models/mock_interview_result_model.dart';

class User {
  final String id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? name;
  final String? gender;
  final String? dateOfBirth;
  final bool? differentlyAbled;
  final String? location;
  final String email;
  final String? phoneNumber;
  final String? lastUpdatedDate;
  final bool? fresher;
  final String? profileHeadline;
  final String? profileSummary;
  final bool? careerBreak;
  final List<String> keySkills;
  final List<String> achievements;
  final List<Education> education;
  final List<Experience> experience;
  final List<Project> projects;
  final List<Job> appliedJobs;
  final List<AptitudeTestResult> aptitudeTestResult;
  final List<MockInterviewResult> mockInterviewResult;
  final GitHubData? gitHubData;
  final LeetCodeData? leetCodeData;
  final String? linkedin;
  final String? leetcode;
  final String? github;
  final String? portfolio;

  User({
    required this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.differentlyAbled,
    this.location,
    required this.email,
    this.phoneNumber,
    this.linkedin,
    this.portfolio,
    this.github,
    this.leetcode,
    this.lastUpdatedDate,
    this.fresher,
    this.profileHeadline,
    this.profileSummary,
    this.careerBreak,
    this.gitHubData,
    this.leetCodeData,
    List<String>? keySkills,
    List<String>? achievements,
    List<String>? targetCompanies,
    List<Education>? education,
    List<Experience>? experience,
    List<Project>? projects,
    List<Job>? appliedJobs,
    List<AptitudeTestResult>? aptitudeTestResult,
    List<MockInterviewResult>? mockInterviewResult,
  })  : keySkills = keySkills ?? [],
        achievements = achievements ?? [],
        education = education ?? [],
        experience = experience ?? [],
        projects = projects ?? [],
        appliedJobs = appliedJobs ?? [],
        aptitudeTestResult = aptitudeTestResult ?? [],
        mockInterviewResult = mockInterviewResult ?? [];

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }

    return User(
      id: json['_id'] as String? ?? '',
      firstName: json['firstName'] as String?,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      differentlyAbled: json['differentlyAbled'] as bool?,
      location: json['location'] as String?,
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      lastUpdatedDate: json['lastUpdatedDate'] as String?,
      fresher: json['fresher'] as bool?,
      profileHeadline: json['profileHeadline'] as String?,
      leetcode: json['leetcode'] as String?,
      linkedin: json['linkedin'] as String?,
      github: json['github'] as String?,
      portfolio: json['portfolio'] as String?,
      profileSummary: json['profileSummary'] as String?,
      careerBreak: json['careerBreak'] as bool?,
      keySkills: _parseStringList(json['keySkills']),
      achievements: _parseStringList(json['achievements']),
      targetCompanies: _parseStringList(json['targetCompanies']),
      education: _parseList(
        json['education'],
        (item) => Education.fromJson(item as Map<String, dynamic>),
      ),
      experience: _parseList(
        json['experience'],
        (item) => Experience.fromJson(item as Map<String, dynamic>),
      ),
      projects: _parseList(
        json['projects'],
        (item) => Project.fromJson(item as Map<String, dynamic>),
      ),
      appliedJobs: _parseList(
        json['appliedJobs'],
        (item) => Job.fromJson(item as Map<String, dynamic>),
      ),
      aptitudeTestResult: _parseList(
        json['aptitudeTestResult'],
        (item) => AptitudeTestResult.fromJson(item as Map<String, dynamic>),
      ),
      mockInterviewResult: _parseList(
        json['mockInterviewResult'],
        (item) => MockInterviewResult.fromJson(item as Map<String, dynamic>),
      ),
      gitHubData: json['gitHubData'] != null
          ? GitHubData.fromJson(json['gitHubData'] as Map<String, dynamic>)
          : null,
      leetCodeData: json['leetCodeData'] != null
          ? LeetCodeData.fromJson(json['leetCodeData'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'name': name,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'differentlyAbled': differentlyAbled,
      'location': location,
      'email': email,
      'phoneNumber': phoneNumber,
      'leetcode': leetcode,
      'github': github,
      'linkedin': linkedin,
      'portfolio': portfolio,
      'lastUpdatedDate': lastUpdatedDate,
      'fresher': fresher,
      'profileHeadline': profileHeadline,
      'profileSummary': profileSummary,
      'careerBreak': careerBreak,
      'keySkills': keySkills,
      'achievements': achievements,
      'education': education.map((e) => e.toJson()).toList(),
      'experience': experience.map((e) => e.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'appliedJobs': appliedJobs.map((j) => j.toJson()).toList(),
      'aptitudeTestResult': aptitudeTestResult.map((j) => j.toJson()).toList(),
      'mockInterviewResult':
          mockInterviewResult.map((j) => j.toJson()).toList(),
      'gitHubData': gitHubData?.toJson(),
      'leetCodeData': leetCodeData?.toJson(),
    };
  }

  // Helper methods for parsing
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').toList();
    }
    return [];
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(dynamic) fromJson,
  ) {
    if (value == null) return [];
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map((item) => fromJson(item))
          .toList();
    }
    return [];
  }
}

class GitHubData {
  final int repositories;
  final int stars;
  final int followers;
  final int following;
  final Map<String, double> languageDistribution;

  GitHubData({
    required this.repositories,
    required this.stars,
    required this.followers,
    required this.following,
    required this.languageDistribution,
  });

  Map<String, dynamic> toJson() => {
        'repositories': repositories,
        'stars': stars,
        'followers': followers,
        'following': following,
        'languageDistribution': languageDistribution,
      };

  factory GitHubData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }

    return GitHubData(
      repositories: json['repositories'] as int? ?? 0,
      stars: json['stars'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      languageDistribution:
          (json['languageDistribution'] as Map<String, dynamic>?)?.map(
                  (key, value) =>
                      MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ??
              {},
    );
  }
}

class LeetCodeData {
  final List<double> ratingHistory;
  final Map<String, int> problemStats;
  final Map<String, int> languageUsage;
  final Map<String, int> skillStats;
  final SubmissionStats submissionStats;

  LeetCodeData({
    List<double>? ratingHistory,
    Map<String, int>? problemStats,
    Map<String, int>? languageUsage,
    Map<String, int>? skillStats,
    required this.submissionStats,
  })  : ratingHistory = ratingHistory ?? [],
        problemStats = problemStats ?? {},
        languageUsage = languageUsage ?? {},
        skillStats = skillStats ?? {};

  Map<String, dynamic> toJson() => {
        'ratingHistory': ratingHistory,
        'problemStats': problemStats,
        'languageUsage': languageUsage,
        'skillStats': skillStats,
        'submissionStats': submissionStats.toJson(),
      };

  factory LeetCodeData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }

    return LeetCodeData(
      ratingHistory: _parseDoubleList(json['ratingHistory']),
      problemStats: _parseIntMap(json['problemStats']),
      languageUsage: _parseIntMap(json['languageUsage']),
      skillStats: _parseIntMap(json['skillStats']),
      submissionStats: SubmissionStats.fromJson(
          json['submissionStats'] as Map<String, dynamic>? ?? {}),
    );
  }

  static List<double> _parseDoubleList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => (e as num?)?.toDouble() ?? 0.0).toList();
    }
    return [];
  }

  static Map<String, int> _parseIntMap(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      return value.map((key, value) =>
          MapEntry(key.toString(), (value as num?)?.toInt() ?? 0));
    }
    return {};
  }
}

class SubmissionStats {
  final int activeDays;
  final int maxStreak;

  SubmissionStats({
    this.activeDays = 0,
    this.maxStreak = 0,
  });

  Map<String, dynamic> toJson() => {
        'activeDays': activeDays,
        'maxStreak': maxStreak,
      };

  factory SubmissionStats.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubmissionStats();

    return SubmissionStats(
      activeDays: json['activeDays'] as int? ?? 0,
      maxStreak: json['maxStreak'] as int? ?? 0,
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String startYear;
  final String endYear;

  Education({
    required this.institution,
    required this.degree,
    required this.startYear,
    required this.endYear,
  });

  Map<String, dynamic> toJson() => {
        'institution': institution,
        'degree': degree,
        'startYear': startYear,
        'endYear': endYear,
      };

  factory Education.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }

    return Education(
      institution: json['institution'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      startYear: json['startYear'] as String? ?? '',
      endYear: json['endYear'] as String? ?? '',
    );
  }
}

class Project {
  final String title;
  final String description;
  final String technologyUsed;
  final String projectLink;

  Project({
    required this.title,
    required this.description,
    required this.technologyUsed,
    required this.projectLink,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'technologyUsed': technologyUsed,
        'projectLink': projectLink,
      };

  factory Project.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }

    return Project(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      technologyUsed: json['technologyUsed'] as String? ?? '',
      projectLink: json['projectLink'] as String? ?? '',
    );
  }
}

class Experience {
  final String companyName;
  final String jobTitle;
  final String startDate;
  final String endDate;

  Experience({
    required this.companyName,
    required this.jobTitle,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'jobTitle': jobTitle,
        'startDate': startDate,
        'endDate': endDate,
      };

  factory Experience.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }

    return Experience(
      companyName: json['companyName'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
    );
  }
}
