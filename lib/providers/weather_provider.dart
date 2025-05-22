import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mimar/utils/constant.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherProvider with ChangeNotifier {
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


 


  Future<void> fetchWeatherData(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse("$baseurl/api/weather/$city");
      final response = await http.get(url);

      print(":::: Response of weather API: ${response.body}");

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        WeatherModel data = WeatherModel.fromJson(jsonMap);
        _weather = data;
      } else {
        print(":::: Failed to fetch weather updates. Status: ${response.statusCode}");
        _errorMessage = 'Failed to load weather data.';
      }
    } catch (e) {
      print(":::: Error: $e");
      _errorMessage = 'Failed to fetch weather data. Please try again.';
    } finally {
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
