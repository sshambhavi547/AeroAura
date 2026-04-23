import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HydrationRing extends StatelessWidget {
  final double progress;
  final int totalMl;
  final double goalMl;
  final Color color;

  const HydrationRing({
    super.key,
    required this.progress,
    required this.totalMl,
    required this.goalMl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 80.0,
      lineWidth: 14.0,
      percent: progress.clamp(0.0, 1.0),
      animation: true,
      animationDuration: 800,
      backgroundColor: Colors.white.withOpacity(0.1),
      progressColor: color,
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💧', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            '${(totalMl / 1000).toStringAsFixed(1)}L',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'of ${(goalMl / 1000).toStringAsFixed(1)}L',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}