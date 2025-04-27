import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class ApiService {
  final String apiKey = "8bbb3c78179ada9cd0e955c5f88a55dc";

  Future<List<Car>> fetchCars() async {
    final url =
        Uri.parse("https://api.auto-data.net/v1/car-list?api_key=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List carsList = data['cars'];

      return carsList.map((json) => Car.fromApi(json)).toList();
    } else {
      throw Exception("Failed to fetch cars from API");
    }
  }
}
