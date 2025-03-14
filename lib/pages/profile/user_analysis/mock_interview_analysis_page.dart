import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';

class MockInterviewAnalysisPage extends StatelessWidget {
  final User user;
  const MockInterviewAnalysisPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return (user.mockInterviewResult.isEmpty)
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
                  'Mock Interview Analysis',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your interview performance metrics',
                  style: AppStyles.mondaN.copyWith(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInterviewConfidenceTrend(),
                const SizedBox(height: 24),
                _buildFluencyGrammarQuadrant(),
              ],
            ),
          );
  }

  Widget _buildInterviewConfidenceTrend() {
    // Prepare data for line chart
    final videoSpots = <FlSpot>[];
    final audioSpots = <FlSpot>[];

    // Use only the last 5 interviews to keep the chart readable
    final recentInterviews = user.mockInterviewResult.length > 5
        ? user.mockInterviewResult.sublist(user.mockInterviewResult.length - 5)
        : user.mockInterviewResult;

    for (int i = 0; i < recentInterviews.length; i++) {
      final interview = recentInterviews[i];

      // Average confidence scores
      final avgVideoConf = interview.videoConfidence.isNotEmpty
          ? interview.videoConfidence.reduce((a, b) => a + b) /
              interview.videoConfidence.length
          : 0.0;

      final avgAudioConf = interview.audioConfidence.isNotEmpty
          ? interview.audioConfidence.reduce((a, b) => a + b) /
              interview.audioConfidence.length
          : 0.0;

      videoSpots.add(FlSpot(i.toDouble(), avgVideoConf));
      audioSpots.add(FlSpot(i.toDouble(), avgAudioConf));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confidence Trend',
          style: AppStyles.mondaB.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 0.2,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < recentInterviews.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Int ${value.toInt() + 1}',
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
                    interval: 0.2,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value * 100).toInt()}',
                        style: AppStyles.mondaN.copyWith(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: recentInterviews.length.toDouble() - 1,
              minY: 0,
              maxY: 1,
              lineBarsData: [
                LineChartBarData(
                  spots: videoSpots,
                  isCurved: true,
                  color: accentBlue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, xPercentage, bar, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: accentBlue,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: accentBlue.withOpacity(0.1),
                  ),
                ),
                LineChartBarData(
                  spots: audioSpots,
                  isCurved: true,
                  color: accentOrange,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, xPercentage, bar, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: accentOrange,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: accentOrange.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(accentBlue, 'Visual Confidence'),
            const SizedBox(width: 24),
            _buildLegendItem(accentOrange, 'Voice Confidence'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppStyles.mondaN.copyWith(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFluencyGrammarQuadrant() {
    // Process all interviews to calculate fluency and grammar scores
    final List<ScatterSpot> spots = [];

    for (final interview in user.mockInterviewResult) {
      // Calculate average fluency
      final avgFluency = interview.fluencyPercentage.isNotEmpty
          ? interview.fluencyPercentage.reduce((a, b) => a + b) /
              interview.fluencyPercentage.length
          : 0.0;

      // Parse grammar accuracy as a decimal
      final grammarAccuracy = double.tryParse(
              interview.grammar.grammarAccuracy.replaceAll('%', '')) ??
          0.0;

      spots.add(ScatterSpot(
        avgFluency,
        grammarAccuracy / 100, // Convert to 0-1 scale
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fluency vs Grammar',
          style: AppStyles.mondaB.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Quadrant analysis of your communication skills',
          style: AppStyles.mondaN.copyWith(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ScatterChart(
            ScatterChartData(
              scatterSpots: spots,
              minX: 0,
              maxX: 1,
              minY: 0,
              maxY: 1,
              backgroundColor: Colors.transparent,
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                      color: Colors.white.withOpacity(0.2), width: 1),
                  left: BorderSide(
                      color: Colors.white.withOpacity(0.2), width: 1),
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value == 0.5,
                checkToShowVerticalLine: (value) => value == 0.5,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.white.withOpacity(0.2),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Fluency',
                    style: AppStyles.mondaN.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  axisNameSize: 25,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.25,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${(value * 100).toInt()}%',
                          style: AppStyles.mondaN.copyWith(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Grammar',
                    style: AppStyles.mondaN.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  axisNameSize: 25,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.25,
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
              scatterTouchData: ScatterTouchData(
                enabled: true,
                touchTooltipData: ScatterTouchTooltipData(
                  getTooltipItems: (ScatterSpot spot) {
                    // Accepts a single spot
                    return ScatterTooltipItem(
                      'Time: ${(spot.x * 60).toInt()} mins\nAccuracy: ${(spot.y * 100).toInt()}%',
                      textStyle: AppStyles.mondaN.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildQuadrantLegend(),
      ],
    );
  }

  Color _getQuadrantColor(double fluency, double grammar) {
    if (fluency >= 0.5 && grammar >= 0.5) {
      return accentGreen; // High fluency, high grammar
    } else if (fluency >= 0.5 && grammar < 0.5) {
      return accentOrange; // High fluency, low grammar
    } else if (fluency < 0.5 && grammar >= 0.5) {
      return accentBlue; // Low fluency, high grammar
    } else {
      return Colors.redAccent; // Low fluency, low grammar
    }
  }

  Widget _buildQuadrantLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quadrant Analysis',
          style: AppStyles.mondaN.copyWith(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuadrantLegendItem(
              accentGreen,
              'Professional',
              'High fluency, high grammar',
            ),
            _buildQuadrantLegendItem(
              accentOrange,
              'Conversational',
              'High fluency, needs grammar work',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuadrantLegendItem(
              accentBlue,
              'Technical',
              'Good grammar, needs fluency work',
            ),
            _buildQuadrantLegendItem(
              Colors.redAccent,
              'Developing',
              'Needs improvement in both areas',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuadrantLegendItem(
      Color color, String title, String description) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppStyles.mondaB.copyWith(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppStyles.mondaN.copyWith(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
