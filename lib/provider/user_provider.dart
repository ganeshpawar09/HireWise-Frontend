import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hirewise/models/mock_interview_result_model.dart';
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
  List<String> _questions = [];
  List<String> get questions => _questions;

  User? get user => _user;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _user != null && _accessToken != null;
  FeedbackModel? get userFeedback => _userFeedback;
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Helper to handle errors
  void _handleError(BuildContext context, http.Response response) {
    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      _error = errorData['message'] ?? 'An error occurred';
      notifyListeners();
      _showSnackBar(context, _error!);
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

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners(); // Notify UI of the change
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
        _user = User.fromJson(responseData['data']['user']);

        saveToLocal();
        notifyListeners();
      }
    } catch (e) {
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
        Uri.parse('$baseUrl/build-user-profile-resume'),
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
        _user = User.fromJson(responseData['data']['user']);
        saveToLocal();
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
        Uri.parse('$baseUrl/get-feedback-tips'),
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
    required String companyName,
    required String role,
    required String interviewType,
    required String experienceLevel,
    required int numberOfQuestions,
    String jobDescription = "",
  }) async {
    try {
      _questions = [];
      notifyListeners();
      final response = await http.post(
        Uri.parse('$baseUrl/get-interview-questions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_accessToken',
        },
        body: json.encode({
          "userId": user!.id,
          "companyName": companyName,
          "role": role,
          "interviewType": interviewType,
          "experienceLevel": experienceLevel,
          "jobDescription": jobDescription,
          "numberOfQuestions": numberOfQuestions
        }),
      );

      // Handle any non-200 HTTP status codes.
      _handleError(context, response);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Explicitly cast List<dynamic> to List<String>
        final List<dynamic> rawQuestions =
            responseData['data']['interviewQuestions'];
        _questions = rawQuestions.cast<String>();
        notifyListeners();
      } else {
        _showSnackBar(context, "Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      _showSnackBar(context, "Failed to fetch interview questions: $e");
    }
  }

  Future<User?> getUserById(BuildContext context, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get-user'),
        body: json.encode({'userId': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      _handleError(context, response);
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

  Future<String?> uploadVideo({
    required BuildContext context,
    required File file,
  }) async {
    try {
      if (_accessToken == null) {
        throw Exception('User not authenticated');
      }

      final uri = Uri.parse('$server/mockInterview/upload-video');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers['Authorization'] = 'Bearer $_accessToken';

      // Add the single file to the request
      request.files.add(await http.MultipartFile.fromPath('video', file.path));

      // Send the request
      final response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseData);
        final videoUrl = decodedResponse['data']['videoUrl'];
        _showSnackBar(context, "File uploaded successfully.");
        return videoUrl;
      } else {
        final responseData = await response.stream.bytesToString();
        _showSnackBar(
          context,
          "File upload failed: ${response.statusCode} $responseData",
        );
        throw Exception('File upload failed');
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Failed to upload video. Please try again.");
      return null;
    }
  }

  Future<MockInterviewResult?> processVideo({
    required BuildContext context,
    required String question,
    required String videoUrl,
  }) async {
    try {
      if (_accessToken == null) {
        throw Exception('User not authenticated');
      }

      final uri = Uri.parse('$server/mockInterview/process-video');
      final response = await http.post(
        uri,
        body: json.encode(
            {'userId': user!.id, "question": question, "videoUrl": videoUrl}),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);
      // Handle response
      if (response.statusCode == 200) {
        final result = MockInterviewResult.fromJson(
            responseData['data']['mockInterviewResult']);
        _showSnackBar(context, "We got result.");
        user!.mockInterviewResult.add(result);

        await saveToLocal();
        return result;
      } else {
        final responseData = json.decode(response.body);
        _showSnackBar(
          context,
          "Video Processing failed: ${response.statusCode} ${responseData['data']['message']}",
        );
        throw Exception('Video Processing failed');
      }
    } catch (e) {
      _error = e.toString();
      _showSnackBar(context, "Video Processing failed. Please try again.");
      return null;
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
