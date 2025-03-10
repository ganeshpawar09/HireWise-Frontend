class Hackathon {
  String hackathonName;
  String description;
  DateTime startDate;
  DateTime endDate;
  int maxTeamSize;
  List<String> problemStatements;
  List<String> rules;
  String organizer;
  double prizeMoney;
  String location;
  String imageUrl;
  String registrationLink;

  Hackathon({
    required this.hackathonName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.maxTeamSize,
    required this.problemStatements,
    required this.rules,
    this.organizer = "",
    this.prizeMoney = 0.0,
    required this.location,
    required this.imageUrl,
    required this.registrationLink,
  });

  factory Hackathon.fromJson(Map<String, dynamic> json) {
    return Hackathon(
      hackathonName: json['hackathonName'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxTeamSize: json['maxTeamSize'],
      problemStatements: List<String>.from(json['problemStatements']),
      rules: List<String>.from(json['rules']),
      organizer: json['organizer'] ?? "",
      prizeMoney: (json['prizeMoney'] ?? 0).toDouble(),
      location: json['location'],
      imageUrl: json['imageUrl'],
      registrationLink: json['registrationLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hackathonName': hackathonName,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxTeamSize': maxTeamSize,
      'problemStatements': problemStatements,
      'rules': rules,
      'organizer': organizer,
      'prizeMoney': prizeMoney,
      'location': location,
      'imageUrl': imageUrl,
      'registrationLink': registrationLink,
    };
  }
}
