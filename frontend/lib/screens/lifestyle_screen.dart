import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_theme.dart';
import '../utils/recommendation_engine.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = context.watch<WeatherProvider>().weather;
    final color = weather != null
        ? WeatherTheme.getPrimaryColor(weather.condition, weather.temperature)
        : const Color(0xFF2EC4B6);
    final condition = weather?.condition ?? 'Clear';
    final temp = weather?.temperature ?? 25.0;

    final foods = RecommendationEngine.getFoodRecommendations(condition, temp);
    final clothing =
        RecommendationEngine.getClothingRecommendations(condition, temp);
    final colors =
        RecommendationEngine.getColorRecommendations(condition, temp);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('✨ AI Lifestyle Tips',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (weather != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: WeatherTheme.getGradient(condition, temp),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(WeatherTheme.getWeatherEmoji(condition),
                        style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${weather.tempFormatted} · ${weather.cityName}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        Text(weather.description,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Food
            _SectionTitle(emoji: '🍽️', title: 'What to Eat Today'),
            const SizedBox(height: 12),
            ...foods.map((f) => _TipTile(
                  emoji: f['icon'] as String,
                  title: f['name'] as String,
                  subtitle: f['reason'] as String,
                  color: color,
                )),

            const SizedBox(height: 24),

            // Clothing
            _SectionTitle(emoji: '👗', title: 'What to Wear Today'),
            const SizedBox(height: 12),
            ...clothing.map((c) => _TipTile(
                  emoji: c['icon'] as String,
                  title: c['name'] as String,
                  subtitle: c['detail'] as String,
                  color: const Color(0xFFB57BFF),
                )),

            const SizedBox(height: 24),

            // Colors
            _SectionTitle(emoji: '🎨', title: 'Colors for Today\'s Mood'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1F2937)),
              ),
              child: Column(
                children: colors.map((c) {
                  final cColor = Color(c['color'] as int);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: cColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: cColor.withOpacity(0.4),
                                  blurRadius: 8)
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name'] as String,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                              Text(c['mood'] as String,
                                  style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // Water intake advice
            const SizedBox(height: 24),
            _SectionTitle(emoji: '💧', title: 'Water Intake Recommendation'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended: ${(RecommendationEngine.calculateWaterIntake(temp, 70) / 1000).toStringAsFixed(1)}L today',
                    style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    temp >= 38
                        ? '🔥 Extreme heat — hydrate every 20 minutes. Add electrolytes.'
                        : temp >= 30
                            ? '☀️ Hot day — drink regularly throughout the day.'
                            : temp <= 10
                                ? '❄️ Cold weather — still need hydration even if not thirsty.'
                                : '✅ Moderate weather — drink water consistently.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
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

class _SectionTitle extends StatelessWidget {
  final String emoji;
  final String title;

  const _SectionTitle({required this.emoji, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _TipTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _TipTile(
      {required this.emoji,
      required this.title,
      required this.subtitle,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}