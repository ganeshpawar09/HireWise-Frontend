import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hirewise/models/question_model.dart';
import 'package:http/http.dart' as http;
import 'package:hirewise/server.dart';

class TopicProvider extends ChangeNotifier {
  static const String baseUrl = '$server/topic';
  Map<String, List<String>>? _topics;
  List<Question>? _questions;
  String? _error;
  final bool _isLoading = false;

  Map<String, List<String>>? get topics => _topics;
  List<Question>? get questions => _questions;
  String? get error => _error;
  bool get isLoading => _isLoading;

  void _showSnackBar(BuildContext context, String message, {Color? color}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleError(BuildContext context, http.Response response) {
    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      _error = errorData['message'] ?? 'An error occurred';
      notifyListeners();
      _showSnackBar(context, _error!, color: Colors.red);
      throw Exception(_error);
    }
  }

  // Fetch all topics structure
  Future<void> fetchTopicsStructure(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get'),
        headers: {'Content-Type': 'application/json'},
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final topicsData = responseData['data'];

        // Parse topics and subtopics
        _topics = {
          for (var topic in topicsData)
            topic['topic'] as String: List<String>.from(topic['subtopics'])
        };

        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Failed to fetch topics. Please try again.");
      notifyListeners();
    }
  }

  // Fetch questions by subtopics
  Future<void> fetchQuestionsBySubTopic(
    BuildContext context, {
    required List<String> subTopics,
    required int numberOfQuestions,
  }) async {
    try {
      _questions = [];
      final response = await http.post(
        Uri.parse('$baseUrl/get-question'),
        body: json.encode({
          'subTopic': subTopics,
          'numberOfQuestions': numberOfQuestions,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final questionsData = responseData['data']['questions'];

        _questions = List<Question>.from(
          questionsData.map((question) => Question.fromJson(question)),
        );
        print(_questions);

        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(
        context,
        "Failed to fetch questions. Please try again.",
      );
      notifyListeners();
    }
  }

  // Clear questions (useful when navigating away from quiz screen)
  void clearQuestions() {
    _questions = null;
    notifyListeners();
  }
}
