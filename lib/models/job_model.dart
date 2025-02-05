class Job {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String jobType;
  final String experience;
  final List<String> requiredSkills;
  final String description;
  final double salaryRangeMin;
  final double salaryRangeMax;
  final List<String> responsibilities;
  final List<String> qualifications;
  final DateTime postingDate;
  final DateTime deadline;
  final String jobLink;
  final String companyDescription;
  final String companyIndustry;
  final int companySize;
  final List<dynamic> applicants;
  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.jobType,
    required this.experience,
    required this.requiredSkills,
    required this.description,
    required this.salaryRangeMin,
    required this.salaryRangeMax,
    required this.responsibilities,
    required this.qualifications,
    required this.postingDate,
    required this.deadline,
    required this.jobLink,
    required this.companyDescription,
    required this.companyIndustry,
    required this.companySize,
    required this.applicants,
  });

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'companyName': companyName,
        'location': location,
        'jobType': jobType,
        'experience': experience,
        'requiredSkills': requiredSkills,
        'description': description,
        'salaryRangeMin': salaryRangeMin,
        'salaryRangeMax': salaryRangeMax,
        'responsibilities': responsibilities,
        'qualifications': qualifications,
        'postingDate': postingDate.toIso8601String(),
        'deadline': deadline.toIso8601String(),
        'jobLink': jobLink,
        'companyDescription': companyDescription,
        'companyIndustry': companyIndustry,
        'companySize': companySize,
        'applicants': applicants
      };

  factory Job.fromJson(Map<String, dynamic> json) {
    try {
      return Job(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        companyName: json['companyName'] ?? '',
        location: json['location'] ?? '',
        jobType: json['jobType'] ?? '',
        experience: json['experience'] ?? '',
        requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
        description: json['description'] ?? '',
        salaryRangeMin: (json['salaryRangeMin'] ?? 0).toDouble(),
        salaryRangeMax: (json['salaryRangeMax'] ?? 0).toDouble(),
        responsibilities: List<String>.from(json['responsibilities'] ?? []),
        qualifications: List<String>.from(json['qualifications'] ?? []),
        postingDate: DateTime.parse(
            json['postingDate'] ?? DateTime.now().toIso8601String()),
        deadline: DateTime.parse(
            json['deadline'] ?? DateTime.now().toIso8601String()),
        jobLink: json['jobLink'] ?? '',
        companyDescription: json['companyDescription'] ?? '',
        companyIndustry: json['companyIndustry'] ?? '',
        companySize: json['companySize'] ?? 0,
        applicants: json['applicants'] ?? [],
      );
    } catch (e) {
      print('Error parsing Job: $e');
      rethrow;
    }
  } 
}
