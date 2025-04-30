// EXTERNAL API SERVICE
import 'package:car_plaza/models/car_history_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://api.carhistory.com/v1';
  static const String _apiKey = 'your_api_key_here';

  Future<CarHistoryReport> getCarHistory(String vin) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/reports?vin=$vin'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode == 200) {
        return CarHistoryReport.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load car history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("API Error: $e");
      rethrow;
    }
  }

  Future<bool> checkVinValidity(String vin) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/validate?vin=$vin'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['isValid'];
      } else {
        throw Exception('Failed to validate VIN: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("API Error: $e");
      return false;
    }
  }
}
