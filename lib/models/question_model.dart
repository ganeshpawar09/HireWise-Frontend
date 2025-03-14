  class Question {
    final String id;
    final String topic;
    final String subTopic;
    final String level;
    final String questionText;
    final List<String> options;
    final int correctOptionIndex;
    final String explanation;

    Question({
      required this.id,
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
        id: json['_id'] as String,
        topic: json['topic'] as String,
        subTopic: json['subTopic'] as String,
        level: json['level'] as String,
        questionText: json['questionText'] as String,
        options: List<String>.from(json['options'] as List),
        correctOptionIndex: json['correctOptionIndex'] as int,
        explanation: json['explanation'] as String,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        '_id': id,
        'topic': topic,
        'subTopic': subTopic,
        'level': level,
        'questionText': questionText,
        'options': options,
        'correctOptionIndex': correctOptionIndex,
        'explanation': explanation,
      };
    }
  }
