class MockInterviewResult {
  final String question;
  final List<double> videoConfidence;
  final List<double> audioConfidence;
  final List<double> fluencyPercentage;
  final String transcription;
  final Grammar grammar;

  MockInterviewResult({
    required this.question,
    required this.videoConfidence,
    required this.audioConfidence,
    required this.fluencyPercentage,
    required this.transcription,
    required this.grammar,
  });

  factory MockInterviewResult.fromJson(Map<String, dynamic> json) {
    return MockInterviewResult(
      question: json['question'] ?? '',
      videoConfidence: List<double>.from(
          json['video_confidence']?.map((e) => (e as num).toDouble()) ?? []),
      audioConfidence: List<double>.from(
          json['audio_confidence']?.map((e) => (e as num).toDouble()) ?? []),
      fluencyPercentage: List<double>.from(
          json['fluency_percentage']?.map((e) => (e as num).toDouble()) ?? []),
      transcription: json['transcription'] ?? '',
      grammar: Grammar.fromJson(json['grammar'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'video_confidence': videoConfidence,
      'audio_confidence': audioConfidence,
      'fluency_percentage': fluencyPercentage,
      'transcription': transcription,
      'grammar': grammar.toJson(),
    };
  }
}

class Grammar {
  final String grammarAccuracy;
  final String? enhancedResponse;

  Grammar({
    required this.grammarAccuracy,
    this.enhancedResponse,
  });

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      grammarAccuracy: json['grammar_accuracy'] ?? 'Unknown',
      enhancedResponse: json['enhanced_response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grammar_accuracy': grammarAccuracy,
      'enhanced_response': enhancedResponse,
    };
  }
}

class Mistake {
  final String incorrect;
  final String correct;
  final String type;

  Mistake({
    required this.incorrect,
    required this.correct,
    required this.type,
  });

  factory Mistake.fromJson(Map<String, dynamic> json) {
    return Mistake(
      incorrect: json['incorrect'] ?? '',
      correct: json['correct'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'incorrect': incorrect,
      'correct': correct,
      'type': type,
    };
  }
}
