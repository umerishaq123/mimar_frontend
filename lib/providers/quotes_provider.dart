import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mimar/models/quotes_model.dart';
import 'package:mimar/utils/constant.dart'; // Make sure this path is correct

class QuoteProvider with ChangeNotifier {
  QuoteData? _quote ;
  bool _isLoading = false;
  String? _errorMessage;

  QuoteData? get quote => _quote;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;



  // Fetch a random quote from the API

Future<void> fetchRandomQuote() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    final response = await http.get(Uri.parse("$baseurl/api/quote"));
    print("Quote API Response: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

   
      final quoteModel = QuoteModel.fromJson(jsonData);

   
      _quote = quoteModel.data;
    } else {
      _errorMessage = 'Failed to fetch quote. Status code: ${response.statusCode}';
    }
  } catch (e) {
    print("Error fetching quote: $e");
    _errorMessage = 'Error fetching quote.';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}



 
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
