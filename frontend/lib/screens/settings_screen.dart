import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hydration_provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _weight = 70.0;

  @override
  void initState() {
    super.initState();
    _weight = context.read<HydrationProvider>().userWeight;
  }

  @override
  Widget build(BuildContext context) {
    final weather = context.watch<WeatherProvider>().weather;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('👤 Profile & Settings',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A4D68), Color(0xFF088395)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🌤️', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AeroAura User',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      if (weather != null)
                        Text(
                          '📍 ${weather.cityName}, ${weather.country}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Weight setting
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1F2937)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⚖️ Body Weight',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    'Used to calculate your daily water intake goal',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '${_weight.toStringAsFixed(0)} kg',
                        style: const TextStyle(
                            color: Color(0xFF2EC4B6),
                            fontSize: 24,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Slider(
                    value: _weight,
                    min: 30,
                    max: 150,
                    divisions: 120,
                    activeColor: const Color(0xFF2EC4B6),
                    inactiveColor: Colors.white.withOpacity(0.1),
                    onChanged: (val) => setState(() => _weight = val),
                    onChangeEnd: (val) {
                      final prov = context.read<HydrationProvider>();
                      prov.saveWeight(val);
                      if (weather != null) {
                        prov.updateGoalForWeather(weather.temperature);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info tiles
            _InfoTile(
              icon: '💧',
              title: 'Daily Hydration Goal',
              value: '${(context.watch<HydrationProvider>().goalMl / 1000).toStringAsFixed(1)}L',
              color: const Color(0xFF2EC4B6),
            ),
            const SizedBox(height: 10),
            if (weather != null)
              _InfoTile(
                icon: '🌡️',
                title: 'Current Temperature',
                value: weather.tempFormatted,
                color: const Color(0xFFF4A261),
              ),
            const SizedBox(height: 10),
            _InfoTile(
              icon: '📱',
              title: 'App Version',
              value: 'AeroAura v1.0.0',
              color: const Color(0xFFB57BFF),
            ),

            const SizedBox(height: 24),

            // About
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1F2937)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About AeroAura',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text(
                    'AeroAura is an AI-powered weather lifestyle assistant that helps you adapt your daily habits — food, clothing, hydration, and wellness — based on real-time weather conditions. Built as a Software Engineering project.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 13,
                        height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color color;

  const _InfoTile(
      {required this.icon,
      required this.title,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}