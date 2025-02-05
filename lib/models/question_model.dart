class Question {
  final String topic;
  final String subTopic;
  final String level;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  Question({
    required this.topic,
    required this.subTopic,
    required this.level,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      topic: json['topic'],
      subTopic: json['subTopic'],
      level: json['level'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
      explanation: json['explanation'],
    );
  }
}
