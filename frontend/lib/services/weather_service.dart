import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/constants.dart';

class WeatherService {
  static Future<WeatherModel?> fetchWeatherByCoords(
      double lat, double lon) async {
    try {
      final url =
          '${AppConstants.weatherBaseUrl}/weather?lat=$lat&lon=$lon&appid=${AppConstants.weatherApiKey}';
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<WeatherModel?> fetchWeatherByCity(String city) async {
    try {
      final url =
          '${AppConstants.weatherBaseUrl}/weather?q=$city&appid=${AppConstants.weatherApiKey}';
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}