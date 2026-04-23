import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/alert_banner.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = context.watch<WeatherProvider>().weather;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('🔔 Smart Alerts',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (weather == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('No weather data available',
                      style: TextStyle(color: Colors.white54)),
                ),
              )
            else ...[
              // Always visible alerts
              AlertBanner(
                icon: '🌡️',
                title: 'Current Temperature',
                message:
                    'It\'s ${weather.temperature.toStringAsFixed(1)}°C in ${weather.cityName}. ${_getTempAdvice(weather.temperature)}',
                color: const Color(0xFF2EC4B6),
              ),

              if (weather.isHeatwave) ...[
                AlertBanner(
                  icon: '🔥',
                  title: 'Heatwave Warning!',
                  message:
                      'Dangerous heat at ${weather.tempFormatted}. Stay indoors 12–4PM, drink 3–4L water, wear light cotton clothing.',
                  color: const Color(0xFFE05C2C),
                ),
                AlertBanner(
                  icon: '💊',
                  title: 'Dehydration Risk',
                  message:
                      'High temperatures increase dehydration risk. Consume electrolytes, avoid alcohol/coffee, eat water-rich fruits.',
                  color: const Color(0xFFFF6B35),
                ),
              ],

              if (weather.isRainy) ...[
                AlertBanner(
                  icon: '🌧️',
                  title: 'Rain Alert',
                  message:
                      'Rain expected in ${weather.cityName}. Carry an umbrella, avoid flooded roads, protect electronics.',
                  color: const Color(0xFF4A6FA5),
                ),
                AlertBanner(
                  icon: '🦠',
                  title: 'Monsoon Health Advisory',
                  message:
                      'Rainy season increases risk of waterborne diseases. Drink boiled/filtered water, avoid street food.',
                  color: const Color(0xFF6B8CAE),
                ),
              ],

              if (weather.isCold) ...[
                AlertBanner(
                  icon: '🥶',
                  title: 'Cold Weather Alert',
                  message:
                      'Temperature below 10°C. Layer up, protect extremities, and avoid long outdoor exposure.',
                  color: const Color(0xFF5E8FBF),
                ),
              ],

              if (weather.humidity > 80) ...[
                AlertBanner(
                  icon: '💦',
                  title: 'High Humidity Alert',
                  message:
                      'Humidity at ${weather.humidity}%. Choose breathable fabrics, dry your clothes thoroughly to prevent mold.',
                  color: const Color(0xFF3D9BE9),
                ),
              ],

              if (weather.windSpeed > 10) ...[
                AlertBanner(
                  icon: '💨',
                  title: 'High Wind Advisory',
                  message:
                      'Wind speed at ${weather.windSpeed.toStringAsFixed(1)} m/s. Secure loose items outdoors. Avoid using umbrella in strong wind.',
                  color: const Color(0xFF8B7FC7),
                ),
              ],

              // General tips
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡 General Daily Tips',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    ...[
                      ('🌅', 'Sun Protection', 'Apply SPF 30+ sunscreen 20 min before going outdoors, even on cloudy days.'),
                      ('🧘', 'Mindful Wellness', 'Take 10 deep breaths every 2 hours. Weather affects mood — stay grounded.'),
                      ('🥗', 'Eat Seasonal', 'Seasonal produce is fresher, more nutritious, and weather-appropriate.'),
                      ('🚶', 'Movement', 'Aim for 7,000–10,000 steps per day regardless of weather conditions.'),
                    ].map((tip) => AlertBanner(
                          icon: tip.$1,
                          title: tip.$2,
                          message: tip.$3,
                          color: const Color(0xFF6C7A89),
                        )),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getTempAdvice(double temp) {
    if (temp >= 38) return 'Extreme heat — take all precautions.';
    if (temp >= 30) return 'Hot day — stay hydrated.';
    if (temp >= 20) return 'Pleasant weather — enjoy the day!';
    if (temp >= 10) return 'Cool — dress in layers.';
    return 'Very cold — bundle up warmly.';
  }
}