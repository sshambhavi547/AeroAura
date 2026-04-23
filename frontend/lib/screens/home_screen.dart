import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/hydration_provider.dart';
import '../utils/weather_theme.dart';
import '../widgets/weather_card.dart';
import '../widgets/hydration_ring.dart';
import '../widgets/recommendation_card.dart';
import '../utils/recommendation_engine.dart';
import 'weather_details_screen.dart';
import 'hydration_tracker_screen.dart';
import 'hydration_analytics_screen.dart';
import 'alerts_screen.dart';
import 'lifestyle_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeContent(),
    HydrationTrackerScreen(),
    HydrationAnalyticsScreen(),
    AlertsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111827),
          border: Border(
            top: BorderSide(color: Color(0xFF1F2937), width: 1),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF2EC4B6).withOpacity(0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xFF2EC4B6)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.water_drop_outlined),
              selectedIcon: Icon(Icons.water_drop, color: Color(0xFF2EC4B6)),
              label: 'Hydrate',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics, color: Color(0xFF2EC4B6)),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon:
                  Icon(Icons.notifications, color: Color(0xFF2EC4B6)),
              label: 'Alerts',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: Color(0xFF2EC4B6)),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final weatherProv = context.watch<WeatherProvider>();
    final hydrationProv = context.watch<HydrationProvider>();
    final weather = weatherProv.weather;
    final color = weather != null
        ? WeatherTheme.getPrimaryColor(weather.condition, weather.temperature)
        : const Color(0xFF2EC4B6);

    return RefreshIndicator(
      onRefresh: () => weatherProv.fetchWeatherByLocation(),
      color: color,
      backgroundColor: const Color(0xFF111827),
      child: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 0,
            backgroundColor: const Color(0xFF0A0E1A),
            pinned: true,
            title: const Text(
              'AeroAura 🌤️',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white70),
                onPressed: () => _showCitySearch(context, weatherProv),
              ),
              IconButton(
                icon:
                    const Icon(Icons.auto_awesome, color: Color(0xFF2EC4B6)),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LifestyleScreen()),
                ),
              ),
            ],
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),

              // Weather Card
              if (weatherProv.isLoading)
                const _LoadingCard()
              else if (weather != null)
                WeatherCard(
                  weather: weather,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeatherDetailsScreen(weather: weather),
                    ),
                  ),
                )
              else
                _ErrorCard(
                    message: weatherProv.errorMessage,
                    onRetry: () => weatherProv.fetchWeatherByLocation()),

              const SizedBox(height: 16),

              // Hydration Quick Card
              _SectionHeader(title: '💧 Today\'s Hydration', actionLabel: 'Details', onTap: () {}),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: const Color(0xFF1F2937), width: 1),
                ),
                child: Row(
                  children: [
                    HydrationRing(
                      progress: hydrationProv.progress,
                      totalMl: hydrationProv.todayTotal,
                      goalMl: hydrationProv.goalMl,
                      color: color,
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hydrationProv.goalReached
                                ? '🎉 Goal Reached!'
                                : '${((hydrationProv.goalMl - hydrationProv.todayTotal) / 1000).toStringAsFixed(1)}L remaining',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Daily goal: ${(hydrationProv.goalMl / 1000).toStringAsFixed(1)}L',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => _showAddWaterDialog(
                                context, hydrationProv),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add Water',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Food Recommendations
              if (weather != null) ...[
                _SectionHeader(
                    title: '🍽️ Eat Today',
                    actionLabel: 'All Tips',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LifestyleScreen()))),
                SizedBox(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    children: RecommendationEngine.getFoodRecommendations(
                            weather.condition, weather.temperature)
                        .take(6)
                        .map((item) => RecommendationCard(
                              emoji: item['icon'] as String,
                              title: item['name'] as String,
                              subtitle: item['reason'] as String,
                              color: color,
                            ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Clothing
                _SectionHeader(title: '👗 Wear Today', actionLabel: 'More', onTap: () {}),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    children: RecommendationEngine.getClothingRecommendations(
                            weather.condition, weather.temperature)
                        .map((item) => RecommendationCard(
                              emoji: item['icon'] as String,
                              title: item['name'] as String,
                              subtitle: item['detail'] as String,
                              color: const Color(0xFFB57BFF),
                            ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Color palette
                _SectionHeader(title: '🎨 Colors for Today', actionLabel: '', onTap: () {}),
                Container(
                  height: 72,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: RecommendationEngine.getColorRecommendations(
                            weather.condition, weather.temperature)
                        .map((c) => _ColorDot(
                              colorVal: c['color'] as int,
                              name: c['name'] as String,
                              mood: c['mood'] as String,
                            ))
                        .toList(),
                  ),
                ),
              ],

              const SizedBox(height: 100),
            ]),
          ),
        ],
      ),
    );
  }

  void _showCitySearch(BuildContext ctx, WeatherProvider prov) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Search City',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1F2937),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white38),
              ),
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  prov.fetchWeatherByCity(val);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWaterDialog(BuildContext ctx, HydrationProvider prov) {
    final amounts = [150, 250, 350, 500, 750, 1000];
    showModalBottomSheet(
      context: ctx,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Water Intake',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: amounts.map((ml) {
                return GestureDetector(
                  onTap: () {
                    prov.addWater(ml);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text('Added ${ml}ml 💧'),
                        backgroundColor: const Color(0xFF2EC4B6),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF2EC4B6).withOpacity(0.3)),
                    ),
                    child: Text(
                      '${ml}ml',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final int colorVal;
  final String name;
  final String mood;

  const _ColorDot(
      {required this.colorVal, required this.name, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(colorVal),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Color(colorVal).withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(name,
              style: const TextStyle(color: Colors.white70, fontSize: 9)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  const _SectionHeader(
      {required this.title,
      required this.actionLabel,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          if (actionLabel.isNotEmpty)
            GestureDetector(
              onTap: onTap,
              child: Text(actionLabel,
                  style: const TextStyle(
                      color: Color(0xFF2EC4B6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2EC4B6), strokeWidth: 2),
            SizedBox(height: 12),
            Text('Fetching weather...',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(message.isEmpty ? 'Weather unavailable' : message,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC4B6)),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}