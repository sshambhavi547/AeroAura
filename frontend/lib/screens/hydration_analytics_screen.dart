import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/hydration_provider.dart';

class HydrationAnalyticsScreen extends StatefulWidget {
  const HydrationAnalyticsScreen({super.key});

  @override
  State<HydrationAnalyticsScreen> createState() =>
      _HydrationAnalyticsScreenState();
}

class _HydrationAnalyticsScreenState extends State<HydrationAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HydrationProvider>().fetchWeeklyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hydration = context.watch<HydrationProvider>();
    final weekly = hydration.weeklyData;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E1A),
        title: const Text('📊 Hydration Analytics',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
      ),
      body: hydration.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2EC4B6)))
          : weekly == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📉', style: TextStyle(fontSize: 60)),
                      const SizedBox(height: 16),
                      const Text('No data available',
                          style: TextStyle(color: Colors.white54)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => hydration.fetchWeeklyData(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2EC4B6)),
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Summary cards
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Weekly Total',
                              value:
                                  '${(weekly.totalWeekly / 1000).toStringAsFixed(1)}L',
                              icon: '🗓️',
                              color: const Color(0xFF2EC4B6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Daily Average',
                              value:
                                  '${(weekly.avgDaily / 1000).toStringAsFixed(1)}L',
                              icon: '📈',
                              color: const Color(0xFFB57BFF),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Bar Chart
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Weekly Intake',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 220,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111827),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF1F2937)),
                        ),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: (weekly.analytics
                                        .map((d) => d.total)
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.2)
                                .toDouble(),
                            barGroups: weekly.analytics
                                .asMap()
                                .entries
                                .map((entry) {
                              final idx = entry.key;
                              final d = entry.value;
                              return BarChartGroupData(
                                x: idx,
                                barRods: [
                                  BarChartRodData(
                                    toY: d.total.toDouble(),
                                    color: const Color(0xFF2EC4B6),
                                    width: 22,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8)),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: (weekly.analytics
                                                  .map((d) => d.total)
                                                  .reduce(
                                                      (a, b) => a > b ? a : b) *
                                              1.2)
                                          .toDouble(),
                                      color:
                                          Colors.white.withOpacity(0.04),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (val, _) {
                                    final days = [
                                      'M', 'T', 'W', 'T', 'F', 'S', 'S'
                                    ];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        days[val.toInt() % 7],
                                        style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (val, _) => Text(
                                    '${(val / 1000).toStringAsFixed(1)}L',
                                    style: const TextStyle(
                                        color: Colors.white38, fontSize: 10),
                                  ),
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (_) => FlLine(
                                color: Colors.white.withOpacity(0.05),
                                strokeWidth: 1,
                              ),
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Daily breakdown
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Daily Breakdown',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(height: 12),
                      ...weekly.analytics.reversed.map((day) {
                        final pct = (day.total / hydration.goalMl).clamp(0.0, 1.0);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111827),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF1F2937)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(day.date,
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13)),
                                  Text(
                                    '${(day.total / 1000).toStringAsFixed(2)}L',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.08),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF2EC4B6)),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;

  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 24, fontWeight: FontWeight.w800)),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}