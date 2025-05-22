import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mimar/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


   Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final url=  Uri.parse( "${ baseurl}/api/users/allusers");
      final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
     url ,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _users = data.map((json) => UserModel.fromJson(json)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load users. Status: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}