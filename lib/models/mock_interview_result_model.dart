class MockInterviewResult {
  final String question;
  final double videoConfidence;
  final double audioConfidence;
  final double fluencyPercentage;
  final Transcription transcription;
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
      question: json['question'],
      videoConfidence: (json['video_confidence'] as num).toDouble(),
      audioConfidence: (json['audio_confidence'] as num).toDouble(),
      fluencyPercentage: (json['fluency_percentage'] as num).toDouble(),
      transcription: Transcription.fromJson(json['transcription']),
      grammar: Grammar.fromJson(json['grammar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'video_confidence': videoConfidence,
      'audio_confidence': audioConfidence,
      'fluency_percentage': fluencyPercentage,
      'transcription': transcription.toJson(),
      'grammar': grammar.toJson(),
    };
  }
}

class Transcription {
  final String transcription;
  final Map<String, int> fillerWords;
  final int totalFillers;

  Transcription({
    required this.transcription,
    required this.fillerWords,
    required this.totalFillers,
  });

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      transcription: json['transcription'],
      fillerWords: Map<String, int>.from(json['filler_words'] ?? {}),
      totalFillers: json['total_fillers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transcription': transcription,
      'filler_words': fillerWords,
      'total_fillers': totalFillers,
    };
  }
}

class Grammar {
  final List<String> grammarMistakes;
  final String? enhancedResponse;
  final List<String> feedback;

  Grammar({
    required this.grammarMistakes,
    this.enhancedResponse,
    required this.feedback,
  });

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      grammarMistakes: List<String>.from(json['grammar_mistakes'] ?? []),
      enhancedResponse: json['enhanced_response'],
      feedback: List<String>.from(json['feedback'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grammar_mistakes': grammarMistakes,
      'enhanced_response': enhancedResponse,
      'feedback': feedback,
    };
  }
}
