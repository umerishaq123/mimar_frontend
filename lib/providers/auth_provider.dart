import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mimar/utils/constant.dart';
import 'package:mimar/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;
  String? _userId;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userId => _userId;
  String? get errorMessage => _errorMessage;

 
  AuthProvider() {
    _checkLoginStatus();
  }

  // Check if the user is already logged in
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token != null) {
      _token = token;
      _userId = prefs.getString('userId');
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  // Login function - currently with static data
 Future<bool> login(String email, String password, BuildContext context) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final url = Uri.parse("$baseurl/api/auth/login"); // removed double slashes
    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print(":::: Login Response Body: ${response.body}");
    print(":::: Login Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userId = data['user']?['id']; // Safely access nested data

      if (token != null && userId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', userId);

        _token = token;
        _userId = userId;

        SnackbarUtils.showCustomSnackbar(
          context: context,
          title: "Success",
          message: "User logged in successfully",
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Login successful, but token or user ID missing.";
        SnackbarUtils.showCustomSnackbar(
          context: context,
          title: "Warning",
          message: _errorMessage!,
          backgroundColor: Colors.orange,
          icon: Icons.warning,
        );
      }
    } else {
      final data = jsonDecode(response.body);
      _errorMessage = data['message'] ?? 'Login failed. Please try again.';
      SnackbarUtils.showCustomSnackbar(
        context: context,
        title: "Error",
        message: _errorMessage!,
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  } catch (e) {
    print("Exception during login: $e");
    _errorMessage = 'An error occurred. Please try again.';
    SnackbarUtils.showCustomSnackbar(
      context: context,
      title: "Error",
      message: _errorMessage!,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  _isLoading = false;
  notifyListeners();
  return false;
}


Future<bool> signup(String name, String email, String password,BuildContext context) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final url = Uri.parse("https://mimar-backend-rr9t.vercel.app/api/auth/signup");

    final body = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      SnackbarUtils.showCustomSnackbar(context: context, title: "success", message: "user created successful");


      

     
    } else {
      final data = jsonDecode(response.body);
      _errorMessage = data['message'] ?? 'Signup failed. Please try again.';
           SnackbarUtils.showCustomSnackbar(context: context, title: "error", message: "user created failed");
    }
  } catch (e) {
    print("Error during signup: $e");
    _errorMessage = 'An error occurred during signup. Please try again.';
  }

  _isLoading = false;
  notifyListeners();
  return false;
}


  // Logout function
  Future<void> logout() async {
    _isLoggedIn = false;
    _token = null;
    _userId = null;
    
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    
    notifyListeners();
  }

  // Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}