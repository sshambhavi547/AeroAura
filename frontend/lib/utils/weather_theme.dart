import 'package:flutter/material.dart';

class WeatherTheme {
  static Color getPrimaryColor(String condition, double temp) {
    final c = condition.toLowerCase();
    if (c.contains('rain') || c.contains('drizzle')) {
      return const Color(0xFF4A6FA5);
    } else if (c.contains('thunder')) {
      return const Color(0xFF2D2D4E);
    } else if (c.contains('snow')) {
      return const Color(0xFF7ECEF4);
    } else if (c.contains('cloud')) {
      return const Color(0xFF6B8CAE);
    } else if (c.contains('mist') || c.contains('fog') || c.contains('haze')) {
      return const Color(0xFF8B9BB4);
    } else if (temp >= 38) {
      return const Color(0xFFE05C2C);
    } else if (temp >= 30) {
      return const Color(0xFFF4A261);
    } else if (temp <= 10) {
      return const Color(0xFF5E8FBF);
    } else {
      return const Color(0xFF2EC4B6);
    }
  }

  static List<Color> getGradient(String condition, double temp) {
    final c = condition.toLowerCase();
    if (c.contains('rain') || c.contains('drizzle')) {
      return [const Color(0xFF1C3A5E), const Color(0xFF4A6FA5), const Color(0xFF7BA3C4)];
    } else if (c.contains('thunder')) {
      return [const Color(0xFF1A1A2E), const Color(0xFF2D2D4E), const Color(0xFF45456B)];
    } else if (c.contains('snow')) {
      return [const Color(0xFF5BB8E2), const Color(0xFF9DD8F0), const Color(0xFFDEF3FC)];
    } else if (c.contains('cloud')) {
      return [const Color(0xFF3D6B8E), const Color(0xFF6B8CAE), const Color(0xFF9DB8CC)];
    } else if (c.contains('mist') || c.contains('fog') || c.contains('haze')) {
      return [const Color(0xFF5A6F84), const Color(0xFF8B9BB4), const Color(0xFFB8C4D0)];
    } else if (temp >= 38) {
      return [const Color(0xFF7B1F0A), const Color(0xFFD44000), const Color(0xFFF07241)];
    } else if (temp >= 30) {
      return [const Color(0xFFB5451B), const Color(0xFFE07040), const Color(0xFFF4A261)];
    } else if (temp <= 10) {
      return [const Color(0xFF1A3A5C), const Color(0xFF2E5F8A), const Color(0xFF5E8FBF)];
    } else {
      // Clear/Pleasant
      return [const Color(0xFF0A4D68), const Color(0xFF088395), const Color(0xFF2EC4B6)];
    }
  }

  static String getWeatherEmoji(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('thunder')) return '⛈️';
    if (c.contains('rain')) return '🌧️';
    if (c.contains('drizzle')) return '🌦️';
    if (c.contains('snow')) return '❄️';
    if (c.contains('mist') || c.contains('fog') || c.contains('haze')) return '🌫️';
    if (c.contains('cloud')) return '⛅';
    if (c.contains('clear')) return '☀️';
    return '🌤️';
  }

  static String getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}