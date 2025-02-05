import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/server.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const String baseUrl = '$server/user';
  static const String userKey = 'user_data';
  User? _user;
  String? _accessToken;
  String? _error;
  FeedbackModel? _userFeedback;

  User? get user => _user;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _user != null && _accessToken != null;
  FeedbackModel? get userFeedback => _userFeedback;
  void _showSnackBar(BuildContext context, String message, {Color? color}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Helper to handle errors
  void _handleError(BuildContext context, http.Response response) {
    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      _error = errorData['message'] ?? 'An error occurred';
      notifyListeners();
      _showSnackBar(context, _error!, color: Colors.black);
      throw Exception(_error);
    }
  }

  // Initialize provider by loading user from local storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);
    final token = prefs.getString('access_token');

    if (userData != null && token != null) {
      _user = User.fromJson(json.decode(userData));
      _accessToken = token;
      notifyListeners();
    }
  }

  Future<void> sendOTP(BuildContext context, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        body: json.encode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );
      _handleError(context, response);
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Failed to send OTP. Please try again.");
    }
  }

  // Verify OTP and handle user authentication
  Future<void> verifyOTP(BuildContext context, String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        body: json.encode({'email': email, 'otp': otp}),
        headers: {'Content-Type': 'application/json'},
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _user = User.fromJson(responseData['data']['user']);
        _accessToken = responseData['data']['accessToken'];
        await saveToLocal();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "OTP verification failed. Please try again.");
    }
  }

  Future<void> updateUserProfile(
      BuildContext context, Map<String, dynamic> updates) async {
    try {
      if (updates.containsKey('aptitudeAssessments')) {
        updates['aptitudeAssessments'] = updates['aptitudeAssessments']
            .map((assessment) => assessment.toJson())
            .toList();
      }
      print('Updates to be sent: $updates'); // Detailed logging

      if (_user == null || _accessToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/update-user'),
        body: json.encode({'userId': _user!.id, 'updates': updates}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(
            'Updated user data: ${responseData['data']['user']['aptitudeAssessments']}');

        _user = User.fromJson(responseData['data']['user']);
        await saveToLocal();
        notifyListeners();
      }
    } catch (e) {
      print('Detailed error: $e'); // Log the full error
      _error = e.toString();
      _showSnackBar(context, "Profile update failed: ${e.toString()}");
    }
  }

  Future<void> fetchLeetCodeProfile(BuildContext context) async {
    await _fetchUserProfile(context, '/fetch-leetcode-profile');
  }

  Future<void> fetchGitHubProfile(BuildContext context) async {
    await _fetchUserProfile(context, '/fetch-github-profile');
  }

  // Helper function to fetch profile from different sources
  Future<void> _fetchUserProfile(BuildContext context, String endpoint) async {
    try {
      if (_user == null || _accessToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        body: json.encode({'userId': _user!.id}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _user = User.fromJson(responseData['data']['user']);
        await saveToLocal();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Failed to fetch profile data. Please try again.");
    }
  }

  Future<void> buildUserProfileFromResume({
    required BuildContext context,
    required String userId,
    required String resumeContent,
    String? extraInfo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-user-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({
          "userId": userId,
          "resumeContent": resumeContent,
          "extraInfo": extraInfo ?? "",
        }),
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _user = User.fromJson(responseData['data']);
        notifyListeners();
      }
    } catch (e) {
      _showSnackBar(context, "Failed to update profile from resume.");
    }
  }

  Future<void> getUserFeedback({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      _userFeedback = null;
      notifyListeners();
      final response = await http.post(
        Uri.parse('$baseUrl/get-user-feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({"userId": userId}),
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _userFeedback =
            FeedbackModel.fromJson(responseData['data']['feedback']);
        notifyListeners();
      }
    } catch (e) {
      _showSnackBar(context, "Failed to fetch user feedback.");
    }
  }

  // Get Interview Questions
  Future<void> getInterviewQuestions({
    required BuildContext context,
    required String userId,
    required String companyName,
    required String role,
    required String interviewType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get-interview-question'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({
          "userId": userId,
          "companyName": companyName,
          "role": role,
          "interviewType": interviewType,
        }),
      );

      _handleError(context, response);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Assuming interview questions are in responseData['data']
        print("Interview Questions: ${responseData['data']}");
      }
    } catch (e) {
      _showSnackBar(context, "Failed to fetch interview questions.");
    }
  }

  Future<User?> getUserById(BuildContext context, String userId) async {
    try {
      print(userId);
      final response = await http.post(
        Uri.parse('$baseUrl/get-user'),
        body: json.encode({'userId': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      _handleError(context, response);
      print(response);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return User.fromJson(responseData['data']['user']);
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Failed to fetch user data.");
    }
    return null;
  }

  // Save user data to local storage
  Future<void> saveToLocal() async {
    if (_user != null && _accessToken != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(userKey, json.encode(_user!.toJson()));
      await prefs.setString('access_token', _accessToken!);
    }
  }
}

class FeedbackModel {
  final List<String> feedback;
  final List<String> tips;

  FeedbackModel({required this.feedback, required this.tips});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedback: List<String>.from(json["feedback"] ?? []),
      tips: List<String>.from(json["tips"] ?? []),
    );
  }
}
