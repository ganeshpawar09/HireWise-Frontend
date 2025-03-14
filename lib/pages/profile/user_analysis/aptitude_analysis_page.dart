import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';

class AptitudeAnalysisPage extends StatelessWidget {
  final User user;
  const AptitudeAnalysisPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return (user.aptitudeTestResult.isEmpty)
        ? Container()
        : Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aptitude Test Analysis',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your performance across different topics',
                  style: AppStyles.mondaN.copyWith(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTopicWiseScoreChart(),
              ],
            ),
          );
  }

  Widget _buildTopicWiseScoreChart() {
    // Group questions by topic and calculate scores
    final Map<String, List<double>> topicScores = {};

    for (final result in user.aptitudeTestResult) {
      for (final entry in result.selectedOptions.entries) {
        final topic = entry.key.topic;
        final isCorrect = entry.value == entry.key.correctOptionIndex;

        if (!topicScores.containsKey(topic)) {
          topicScores[topic] = [];
        }

        topicScores[topic]!.add(isCorrect ? 1.0 : 0.0);
      }
    }

    // Calculate average score per topic
    final Map<String, double> topicAverages = {};
    topicScores.forEach((topic, scores) {
      topicAverages[topic] = scores.reduce((a, b) => a + b) / scores.length;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topic Performance',
          style: AppStyles.mondaB.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1,
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 0.2 == 0,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
                drawVerticalLine: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final topics = topicAverages.keys.toList();
                      if (value >= 0 && value < topics.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            topics[value.toInt()],
                            style: AppStyles.mondaN.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value * 100).toInt()}%',
                        style: AppStyles.mondaN.copyWith(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(
                topicAverages.length,
                (index) {
                  final topic = topicAverages.keys.elementAt(index);
                  final score = topicAverages[topic]!;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: score,
                        width: 20,
                        color: _getScoreColor(score),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 1,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score < 0.5) return Colors.redAccent;
    if (score < 0.75) return accentOrange;
    return accentGreen;
  }
}
