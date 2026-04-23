import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hydration_model.dart';
import '../utils/constants.dart';

class HydrationService {
  static Future<bool> addHydrationEntry(int amount, {String note = ''}) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.backendBaseUrl}/hydration'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'note': note}),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getTodayLogs() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.backendBaseUrl}/hydration/today'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['data'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<WeeklyData?> getWeeklyAnalytics() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.backendBaseUrl}/hydration/weekly'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>;
        final analyticsList = (data['analytics'] as List)
            .map((e) => DailyAnalytics.fromJson(e as Map<String, dynamic>))
            .toList();

        return WeeklyData(
          analytics: analyticsList,
          totalWeekly: data['totalWeekly'] as int,
          avgDaily: data['avgDaily'] as int,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}