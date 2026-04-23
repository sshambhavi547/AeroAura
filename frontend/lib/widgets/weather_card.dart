import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_theme.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback? onTap;

  const WeatherCard({super.key, required this.weather, this.onTap});

  @override
  Widget build(BuildContext context) {
    final gradient = WeatherTheme.getGradient(weather.condition, weather.temperature);
    final emoji = WeatherTheme.getWeatherEmoji(weather.condition);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location + emoji
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${weather.cityName}, ${weather.country}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      WeatherTheme.getTimeGreeting(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(emoji, style: const TextStyle(fontSize: 50)),
              ],
            ),

            const SizedBox(height: 20),

            // Temperature
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  weather.temperature.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 14),
                  child: Text(
                    '°C',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            Text(
              weather.description.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(icon: Icons.water_drop, label: '${weather.humidity}%', desc: 'Humidity'),
                _StatChip(icon: Icons.air, label: '${weather.windSpeed.toStringAsFixed(1)} m/s', desc: 'Wind'),
                _StatChip(icon: Icons.thermostat, label: weather.feelsLikeFormatted, desc: 'Feels Like'),
                _StatChip(icon: Icons.visibility, label: '${weather.visibility}km', desc: 'Visibility'),
              ],
            ),

            // Alerts
            if (weather.isHeatwave) ...[
              const SizedBox(height: 16),
              _AlertChip(
                icon: '🔥',
                message: 'Heatwave! Stay indoors & drink water',
                color: const Color(0xFFFF4500),
              ),
            ] else if (weather.isRainy) ...[
              const SizedBox(height: 16),
              _AlertChip(
                icon: '☂️',
                message: 'Rain detected — Carry an umbrella!',
                color: const Color(0xFF4A6FA5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;

  const _StatChip(
      {required this.icon, required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
        Text(desc,
            style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}

class _AlertChip extends StatelessWidget {
  final String icon;
  final String message;
  final Color color;

  const _AlertChip(
      {required this.icon, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}