import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  WeatherState _state = WeatherState.initial;
  WeatherModel? _weather;
  String _errorMessage = '';

  WeatherState get state => _state;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == WeatherState.loading;

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final position = await LocationService.getCurrentPosition();

      if (position != null) {
        final data = await WeatherService.fetchWeatherByCoords(
            position.latitude, position.longitude);

        if (data != null) {
          _weather = data;
          _state = WeatherState.loaded;
          _triggerAlerts(data);
        } else {
          _errorMessage = 'Could not fetch weather data.';
          _state = WeatherState.error;
        }
      } else {
        // Fallback to default city
        final data = await WeatherService.fetchWeatherByCity('New Delhi');
        if (data != null) {
          _weather = data;
          _state = WeatherState.loaded;
          _triggerAlerts(data);
        } else {
          _errorMessage = 'Location unavailable. Please check permissions.';
          _state = WeatherState.error;
        }
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      _state = WeatherState.error;
    }

    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String city) async {
    _state = WeatherState.loading;
    notifyListeners();

    final data = await WeatherService.fetchWeatherByCity(city);
    if (data != null) {
      _weather = data;
      _state = WeatherState.loaded;
      _triggerAlerts(data);
    } else {
      _errorMessage = 'City not found.';
      _state = WeatherState.error;
    }
    notifyListeners();
  }

  void _triggerAlerts(WeatherModel weather) {
    if (weather.isRainy) {
      NotificationService.showRainAlert(
          'Rain detected in ${weather.cityName}. Carry an umbrella!');
    }
    if (weather.isHeatwave) {
      NotificationService.showHeatwaveAlert(
          'Extreme heat in ${weather.cityName}! Stay hydrated and cool.');
    }
  }
}