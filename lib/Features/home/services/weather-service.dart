import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getWeatherData(double lat, double lon) async {
  String apiUrl =
      'http://api.weatherapi.com/v1/current.json?key=5e9c8153475d4c7d8ac214427231505&q=Tunisia&aqi=no';

  var response = await http.get(Uri.parse(apiUrl));
  print(response.body);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}
