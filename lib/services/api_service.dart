// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/car.dart';

// class ApiService {
//   final String apiKey = "8bbb3c78179ada9cd0e955c5f88a55dc";

//   Future<List<Car>> fetchCars() async {
//     final url =
//         Uri.parse("https://api.auto-data.net/v1/car-list?api_key=$apiKey");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List carsList = data['cars'];

//       return carsList.map((json) => Car.fromApi(json)).toList();
//     } else {
//       throw Exception("Failed to fetch cars from API");
//     }
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/car.dart';

// class ApiService {
//   final String apiKey = "8bbb3c78179ada9cd0e955c5f88a55dc"; // your key

//   Future<List<Car>> fetchCars() async {
//     final url = Uri.parse(
//         "https://api.auto-data.net/v1/car-list"); // No API key in URL!

//     final response = await http.get(
//       url,
//       headers: {
//         "Authorization": "Token $apiKey",
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List carsList = data['cars'];

//       return carsList.map((json) => Car.fromApi(json)).toList();
//     } else {
//       print('Error: ${response.body}'); // debug log
//       throw Exception("Failed to fetch cars from API");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class ApiService {
  final String apiKey =
      "XqskErMyTAV7o67n+CT54w==I4pRbsFxjwTNPaX5"; // ✅ Your API Key

  Future<List<Car>> fetchCars() async {
    final url = Uri.parse("https://api.api-ninjas.com/v1/cars?limit=10");

    final response = await http.get(
      url,
      headers: {
        "X-Api-Key": apiKey,
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map((json) => Car(
                id: json['model'].toString(),
                title: "${json['make']} ${json['model']}",
                imageUrl:
                    "https://source.unsplash.com/600x400/?${json['make']}+${json['model']}", // smart random image
                price: 20000, // fake price for now
                location: "Unknown",
                isFromFirebase: false,
              ))
          .toList();
    } else {
      print('Error: ${response.body}');
      throw Exception("Failed to fetch cars from API");
    }
  }
}
