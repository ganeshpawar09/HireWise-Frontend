import 'package:flutter/material.dart';
import 'package:hirewise/models/job_model.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:hirewise/server.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JobProvider with ChangeNotifier {
  final UserProvider userProvider;
  JobProvider({required this.userProvider});

  List<Job> _searchJobs = [];
  List<Job> _recommendedJobs = [];
  List<Job> _appliedJobs = [];
  bool _isLoading = false;
  String? _error;

  static const String baseUrl = '$server/job';

  List<Job> get jobs => _searchJobs;
  List<Job> get recommendedJobs => _recommendedJobs;
  List<Job> get appliedJobs => _appliedJobs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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

  // Apply for a job by sending jobId and userId through the request body
  Future<void> applyForJob(BuildContext context, String jobId, int page) async {
    final userId = userProvider.user?.id;
    if (userId == null) {
      _showSnackBar(context, "User ID not found. Please log in.",
          color: Colors.black);
      throw Exception("User ID not found. Please log in.");
    }

    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apply'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'jobId': jobId, 'userId': userId}),
      );

      _handleError(context, response);

      Job? appliedJob;

      switch (page) {
        case 1:
          appliedJob = _removeJobFromList(_recommendedJobs, jobId);
          break;

        case 2:
          appliedJob = _removeJobFromList(_searchJobs, jobId);
          break;
        default:
          throw Exception("Invalid page number: $page");
      }

      if (appliedJob != null) {
        _appliedJobs.add(appliedJob);
        _showSnackBar(context, "Successfully applied for the job!",
            color: Colors.green);
      } else {
        _showSnackBar(context, "Job not found in the list.",
            color: Colors.orange);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

// Helper method to remove a job by ID from a list and return the job
  Job? _removeJobFromList(List<Job> jobList, String jobId) {
    final index = jobList.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      return jobList.removeAt(index);
    }
    return null;
  }

  // Fetch recommended jobs based on the user's data
  Future<void> getRecommendedJobs(BuildContext context) async {
    final userId = userProvider.user?.id;
    print(userId);
    if (userId == null) {
      _showSnackBar(context, "User ID not found. Please log in.",
          color: Colors.black);
      throw Exception("User ID not found. Please log in.");
    }

    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recommended'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      _handleError(context, response);

      final responseData = json.decode(response.body)['data'];
      _recommendedJobs =
          (responseData as List).map((job) => Job.fromJson(job)).toList();
      print(_recommendedJobs.length);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Fetch applied jobs list
  Future<void> getAppliedJobs(BuildContext context,
      {String? sortBy, String? order}) async {
    final userId = userProvider.user?.id;
    if (userId == null) {
      _showSnackBar(context, "User ID not found. Please log in.",
          color: Colors.black);
      throw Exception("User ID not found. Please log in.");
    }

    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/applied'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          if (sortBy != null) 'sortBy': sortBy,
          if (order != null) 'order': order,
        }),
      );

      _handleError(context, response);

      final responseData = json.decode(response.body)['data'];
      _appliedJobs =
          (responseData as List).map((job) => Job.fromJson(job)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Search for jobs based on filters, using a POST request and sending filters in the body
  Future<void> searchJobs(
    BuildContext context, {
    String? role,
  }) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'role': role,
        }),
      );

      _handleError(context, response);

      final responseData = json.decode(response.body)['data'];
      _searchJobs =
          (responseData as List).map((job) => Job.fromJson(job)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Reset and clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _searchJobs = [];
    _recommendedJobs = [];
    _appliedJobs = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
