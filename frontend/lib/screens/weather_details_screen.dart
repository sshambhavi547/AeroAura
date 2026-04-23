import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_theme.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final gradient = WeatherTheme.getGradient(weather.condition, weather.temperature);
    final emoji = WeatherTheme.getWeatherEmoji(weather.condition);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: gradient.first,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(emoji, style: const TextStyle(fontSize: 80)),
                      Text(
                        weather.tempFormatted,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${weather.cityName}, ${weather.country}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 18),
                      ),
                      Text(
                        weather.description,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weather Details',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [
                        _DetailTile(icon: '🌡️', label: 'Feels Like', value: weather.feelsLikeFormatted),
                        _DetailTile(icon: '💧', label: 'Humidity', value: '${weather.humidity}%'),
                        _DetailTile(icon: '💨', label: 'Wind Speed', value: '${weather.windSpeed.toStringAsFixed(1)} m/s'),
                        _DetailTile(icon: '👁️', label: 'Visibility', value: '${weather.visibility} km'),
                        _DetailTile(icon: '📊', label: 'Pressure', value: '${weather.pressure} hPa'),
                        _DetailTile(icon: '☁️', label: 'Condition', value: weather.condition),
                      ],
                    ),

                    if (weather.isHeatwave) ...[
                      const SizedBox(height: 20),
                      _AlertSection(
                        icon: '🔥',
                        title: 'Heatwave Warning',
                        message: 'Temperature is dangerously high at ${weather.tempFormatted}. Stay indoors during peak hours (12PM-4PM). Drink at least 3-4 liters of water. Avoid direct sun exposure. Wear light, breathable clothing.',
                        color: const Color(0xFFE05C2C),
                      ),
                    ] else if (weather.isRainy) ...[
                      const SizedBox(height: 20),
                      _AlertSection(
                        icon: '🌧️',
                        title: 'Rain Alert',
                        message: 'Rain is expected in your area. Carry an umbrella or raincoat. Avoid waterlogged areas. Drive carefully and keep your electronics protected.',
                        color: const Color(0xFF4A6FA5),
                      ),
                    ] else if (weather.isCold) ...[
                      const SizedBox(height: 20),
                      _AlertSection(
                        icon: '🥶',
                        title: 'Cold Weather Advisory',
                        message: 'Temperature is very low at ${weather.tempFormatted}. Layer up with warm clothing. Keep extremities covered with gloves, socks, and beanie.',
                        color: const Color(0xFF5E8FBF),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _DetailTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}

class _AlertSection extends StatelessWidget {
  final String icon;
  final String title;
  final String message;
  final Color color;

  const _AlertSection(
      {required this.icon,
      required this.title,
      required this.message,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Text(title,
                  style: TextStyle(
                      color: color, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Text(message,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 13, height: 1.6)),
        ],
      ),
    );
  }
}