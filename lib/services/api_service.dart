// =================== lib/services/api_service.dart ===================

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/car.dart';

class ApiService {
  final String apiUrl =
      'https://example.com/api/cars'; // Replace with your external API

  Future<List<Car>> fetchExternalCars() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Car.fromMap(item, '')).toList();
      } else {
        throw Exception('Failed to load external cars');
      }
    } catch (e) {
      print('Error fetching external cars: $e');
      return [];
    }
  }
}

// =============================================================
