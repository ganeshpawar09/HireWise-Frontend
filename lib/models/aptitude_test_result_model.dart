import 'package:hirewise/models/question_model.dart';

class AptitudeTestResult {
  final Map<Question, int> selectedOptions;
  final int totalTimeTaken;
  final DateTime testDate;
  final double overallScore;

  AptitudeTestResult({
    required this.selectedOptions,
    required this.totalTimeTaken,
    required this.testDate,
    required this.overallScore,
  });

  factory AptitudeTestResult.fromJson(Map<String, dynamic> json) {
    // Parse selectedOptions as a list of objects
    final selectedOptionsList = (json['selectedOptions'] as List).map((item) {
      final question =
          Question.fromJson(item['question'] as Map<String, dynamic>);
      final option = item['option'] as int;
      return MapEntry(question, option);
    }).toList();

    return AptitudeTestResult(
      selectedOptions: Map.fromEntries(selectedOptionsList),
      totalTimeTaken: json['totalTimeTaken'] as int,
      testDate: DateTime.parse(json['testDate'] as String),
      overallScore: (json['overallScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedOptions': selectedOptions.entries
          .map((entry) => {
                'question': entry.key.toJson(),
                'option': entry.value,
              })
          .toList(),
      'totalTimeTaken': totalTimeTaken,
      'testDate': testDate.toIso8601String(),
      'overallScore': overallScore,
    };
  }
}
