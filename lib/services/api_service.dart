import 'package:car_plaza/models/car_history_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String _baseUrl = 'https://api.carhistory.com/v1';
  static const String _apiKey =
      'your_api_key_here'; // Replace with your actual API key

  Future<CarHistoryReport> getCarHistory(String vin) async {
    try {
      if (vin.isEmpty || vin.length != 17) {
        throw Exception('Invalid VIN: Must be 17 characters');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/reports?vin=$vin'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CarHistoryReport.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('No history found for this VIN');
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Car History API Error: $e");
      rethrow;
    }
  }

  Future<bool> checkVinValidity(String vin) async {
    try {
      if (vin.isEmpty || vin.length != 17) return false;

      final response = await http.get(
        Uri.parse('$_baseUrl/validate?vin=$vin'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body)['isValid'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint("VIN Validation Error: $e");
      return false;
    }
  }

  // Optional: Add caching mechanism
  static final Map<String, CarHistoryReport> _cache = {};

  Future<CarHistoryReport> getCachedCarHistory(String vin) async {
    if (_cache.containsKey(vin)) {
      return _cache[vin]!;
    }
    final report = await getCarHistory(vin);
    _cache[vin] = report;
    return report;
  }
}
