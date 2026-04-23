class AppConstants {
  // ⚠️ REPLACE WITH YOUR OPENWEATHERMAP API KEY
  static const String weatherApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // ⚠️ REPLACE WITH YOUR BACKEND URL (use 10.0.2.2 for Android emulator)
  static const String backendBaseUrl = 'http://10.0.2.2:5000/api';

  // Hydration goal (ml)
  static const double defaultHydrationGoal = 2500;

  // Temperature thresholds
  static const double heatwaveThreshold = 38.0; // °C
  static const double coldThreshold = 10.0; // °C
}