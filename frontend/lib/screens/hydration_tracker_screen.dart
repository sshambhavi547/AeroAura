import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/hydration_provider.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_theme.dart';
import '../utils/recommendation_engine.dart';
import '../widgets/recipe_card.dart';

class HydrationTrackerScreen extends StatelessWidget {
  const HydrationTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hydration = context.watch<HydrationProvider>();
    final weather = context.watch<WeatherProvider>().weather;
    final color = weather != null
        ? WeatherTheme.getPrimaryColor(weather.condition, weather.temperature)
        : const Color(0xFF2EC4B6);
    final temp = weather?.temperature ?? 25.0;
    final recipes = RecommendationEngine.getHydrationRecipes(temp);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('💧 Hydration Tracker',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Main progress ring
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF1F2937)),
              ),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 16,
                    percent: hydration.progress,
                    animation: true,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    progressColor: color,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('💧', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 6),
                        Text(
                          '${(hydration.todayTotal / 1000).toStringAsFixed(2)}L',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'of ${(hydration.goalMl / 1000).toStringAsFixed(1)}L goal',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (hydration.goalReached)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.green.withOpacity(0.5)),
                      ),
                      child: const Text('🎉 Daily Goal Achieved! Great job!',
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.w700)),
                    )
                  else
                    Text(
                      '${((hydration.goalMl - hydration.todayTotal) / 1000).toStringAsFixed(2)}L more to reach your goal',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Add Buttons
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Quick Add',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [150, 250, 350, 500, 750, 1000].map((ml) {
                return GestureDetector(
                  onTap: () async {
                    final ok = await hydration.addWater(ml);
                    if (ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ Added ${ml}ml'),
                          backgroundColor: color,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('💧', style: TextStyle(fontSize: 22)),
                        Text('${ml}ml',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Today's Log
            if (hydration.todayLogs.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Today's Log",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 12),
              ...hydration.todayLogs.reversed.map((log) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1F2937)),
                    ),
                    child: Row(
                      children: [
                        const Text('💧', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Text(
                          '${log.amount}ml',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(log.timestamp),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  )),
            ],

            const SizedBox(height: 20),

            // Hydration Recipes
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('🫗 Hydration Recipes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 360,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: recipes
                    .map((r) => RecipeCard(recipe: r, color: color))
                    .toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}