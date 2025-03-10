import 'package:flutter/material.dart';
import 'package:hirewise/models/hackathon_model.dart';
import 'package:hirewise/server.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HackathonProvider with ChangeNotifier {
  List<Hackathon> _hackathon = [];
  List<Hackathon> _searchHackathon = [];

  bool _isLoading = false;
  String? _error;

  static const String baseUrl = '$server/hackathon';

  List<Hackathon> get hackathon => _hackathon;
  List<Hackathon> get searchedHackathon => _searchHackathon;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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

  Future<void> getHackathon(BuildContext context) async {
    _setLoading(true);
    _hackathon = [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-all'),
        headers: {'Content-Type': 'application/json'},
      );

      _handleError(context, response);

      // Decode the response
      final responseData = json.decode(response.body)['data'];
      print(responseData);

      if (responseData != null) {
        final allHackathon = responseData;

        _hackathon = (allHackathon as List)
            .map((hackathon) => Hackathon.fromJson(hackathon))
            .toList();
      } else {
        _showSnackBar(context, "No data found.");
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchHackathon(
    BuildContext context, {
    String? query,
  }) async {
    _setLoading(true);
    _searchHackathon = [];

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'query': query,
        }),
      );

      _handleError(context, response);

      final responseData = json.decode(response.body)['data'];
      print(responseData);
      _searchHackathon = (responseData as List)
          .map((hackathon) => Hackathon.fromJson(hackathon))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _hackathon = [];
    _searchHackathon = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
