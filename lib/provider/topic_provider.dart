import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hirewise/models/aptitude_test_result_model.dart';
import 'package:hirewise/models/question_model.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:hirewise/server.dart';

class TopicProvider extends ChangeNotifier {
  final UserProvider userProvider;
  TopicProvider({required this.userProvider});

  static const String baseUrl = '$server/topic';
  Map<String, List<String>>? _topics;
  List<Question>? _questions;
  String? _error;
  bool _isLoading = false; // ✅ Made mutable

  Map<String, List<String>>? get topics => _topics;
  List<Question>? get questions => _questions;
  String? get error => _error;
  bool get isLoading => _isLoading;

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleError(BuildContext context, http.Response response) {
    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      _error = errorData['message'] ?? 'An error occurred';
      notifyListeners();
      _showSnackBar(context, _error!);
      throw Exception(_error);
    }
  }

  // Fetch all topics structure
  Future<void> fetchTopicsStructure(BuildContext context) async {
    _isLoading = true; // ✅ Set loading to true
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get'),
        headers: {'Content-Type': 'application/json'},
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final topicsData = responseData['data'];

        _topics = {
          for (var topic in topicsData)
            topic['topic'] as String: List<String>.from(topic['subtopics'])
        };
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Failed to fetch topics. Please try again.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch questions by subtopics
  Future<void> fetchQuestionsBySubTopic(
    BuildContext context, {
    required List<String> subTopics,
    required int numberOfQuestions,
  }) async {
    _isLoading = true; // ✅ Set loading to true
    notifyListeners();

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
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Failed to fetch questions. Please try again.");
    } finally {
      _isLoading = false; // ✅ Reset loading after completion
      notifyListeners();
    }
  }

  Future<bool> updateAptitudeResult(
      BuildContext context, AptitudeTestResult aptitudeResult) async {
    _isLoading = true; // ✅ Set loading to true
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/upload-result'),
        body: json.encode({
          "userId": userProvider.user!.id,
          "overallScore": aptitudeResult.overallScore,
          "totalTimeTaken": aptitudeResult.totalTimeTaken,
          "testDate": aptitudeResult.testDate.toIso8601String(),
          "selectedOptions":
              aptitudeResult.selectedOptions.entries.map((entry) {
            return {
              "question": entry.key.id,
              "option": entry.value,
            };
          }).toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        userProvider.user!.aptitudeTestResult.add(aptitudeResult);
        await userProvider.saveToLocal();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      _showSnackBar(
          context, "Failed to update test results. Please try again.");
      return false;
    } finally {
      _isLoading = false; // ✅ Reset loading after completion
      notifyListeners();
    }
  }

  // Clear questions (useful when navigating away from quiz screen)
  void clearQuestions() {
    _questions = null;
    notifyListeners();
  }
}
