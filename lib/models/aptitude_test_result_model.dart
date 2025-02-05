class AptitudeTestResult {
  final TestAnalytics analytics;
  final int timePerQuestion;
  final int totalTimeTaken;
  final DateTime date;

  AptitudeTestResult({
    required this.analytics,
    required this.timePerQuestion,
    required this.totalTimeTaken,
    required this.date,
  });

  factory AptitudeTestResult.fromJson(Map<String, dynamic> json) {
    return AptitudeTestResult(
      analytics: TestAnalytics.fromJson(json['analytics']),
      timePerQuestion: json['timePerQuestion'],
      totalTimeTaken: json['totalTimeTaken'],
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analytics': analytics.toJson(),
      'timePerQuestion': timePerQuestion,
      'totalTimeTaken': totalTimeTaken,
      'date': date.toIso8601String(),
    };
  }
}

class TestAnalytics {
  final int totalQuestions;
  final int correctAnswers;
  final double averageTimePerQuestion;
  final int totalTimeTaken;
  final Map<String, TopicAnalysis> topicWiseAnalysis;
  final double overallScore;

  TestAnalytics({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.averageTimePerQuestion,
    required this.totalTimeTaken,
    required this.topicWiseAnalysis,
    required this.overallScore,
  });

  factory TestAnalytics.fromJson(Map<String, dynamic> json) {
    return TestAnalytics(
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      averageTimePerQuestion:
          (json['averageTimePerQuestion'] as num).toDouble(),
      totalTimeTaken: json['totalTimeTaken'],
      topicWiseAnalysis:
          (json['topicWiseAnalysis'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, TopicAnalysis.fromJson(value)),
      ),
      overallScore: (json['overallScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'averageTimePerQuestion': averageTimePerQuestion,
      'totalTimeTaken': totalTimeTaken,
      'topicWiseAnalysis':
          topicWiseAnalysis.map((key, value) => MapEntry(key, value.toJson())),
      'overallScore': overallScore,
    };
  }
}

class TopicAnalysis {
  final String topic;
  final int totalQuestions;
  final int correctAnswers;
  final Map<String, SubTopicAnalysis> subTopics;
  final double score;

  TopicAnalysis({
    required this.topic,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.subTopics,
    required this.score,
  });

  factory TopicAnalysis.fromJson(Map<String, dynamic> json) {
    return TopicAnalysis(
      topic: json['topic'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      subTopics: (json['subTopics'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, SubTopicAnalysis.fromJson(value)),
      ),
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'subTopics': subTopics.map((key, value) => MapEntry(key, value.toJson())),
      'score': score,
    };
  }
}

class SubTopicAnalysis {
  final String subTopic;
  final int totalQuestions;
  final int correctAnswers;
  final double score;

  SubTopicAnalysis({
    required this.subTopic,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
  });

  factory SubTopicAnalysis.fromJson(Map<String, dynamic> json) {
    return SubTopicAnalysis(
      subTopic: json['subTopic'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subTopic': subTopic,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'score': score,
    };
  }
}
