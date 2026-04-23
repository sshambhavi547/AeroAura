import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hydration_model.dart';
import '../services/hydration_service.dart';
import '../utils/constants.dart';
import '../utils/recommendation_engine.dart';

class HydrationProvider extends ChangeNotifier {
  int _todayTotal = 0;
  List<HydrationEntry> _todayLogs = [];
  WeeklyData? _weeklyData;
  bool _isLoading = false;
  double _goalMl = AppConstants.defaultHydrationGoal;
  double _userWeight = 70.0; // default kg

  int get todayTotal => _todayTotal;
  List<HydrationEntry> get todayLogs => _todayLogs;
  WeeklyData? get weeklyData => _weeklyData;
  bool get isLoading => _isLoading;
  double get goalMl => _goalMl;
  double get userWeight => _userWeight;
  double get progress => (_todayTotal / _goalMl).clamp(0.0, 1.0);
  bool get goalReached => _todayTotal >= _goalMl;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _userWeight = prefs.getDouble('userWeight') ?? 70.0;
    notifyListeners();
  }

  void updateGoalForWeather(double temperature) {
    _goalMl = RecommendationEngine.calculateWaterIntake(temperature, _userWeight);
    notifyListeners();
  }

  Future<void> fetchTodayLogs() async {
    _isLoading = true;
    notifyListeners();

    final data = await HydrationService.getTodayLogs();
    if (data != null) {
      _todayTotal = data['totalAmount'] as int? ?? 0;
      final rawLogs = data['logs'] as List? ?? [];
      _todayLogs = rawLogs
          .map((e) => HydrationEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addWater(int amount) async {
    final success = await HydrationService.addHydrationEntry(amount);
    if (success) {
      _todayTotal += amount;
      notifyListeners();
      await fetchTodayLogs(); // Refresh logs
    }
    return success;
  }

  Future<void> fetchWeeklyData() async {
    _isLoading = true;
    notifyListeners();

    _weeklyData = await HydrationService.getWeeklyAnalytics();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveWeight(double weight) async {
    _userWeight = weight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('userWeight', weight);
    notifyListeners();
  }
}