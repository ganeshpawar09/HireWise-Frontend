import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/aptitude_test_result_model.dart';
import 'package:hirewise/pages/prepzone/test/aptitude/aptitude_result_page.dart';

class AptitudeDetailPage extends StatefulWidget {
  final String type;
  final List<AptitudeTestResult> assessments;

  const AptitudeDetailPage({
    required this.type,
    required this.assessments,
    super.key,
  });

  @override
  State<AptitudeDetailPage> createState() => _AptitudeDetailPageState();
}

class _AptitudeDetailPageState extends State<AptitudeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.type,
          style: AppStyles.mondaB.copyWith(fontSize: 25),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallProgressCard(),
            const SizedBox(height: 20),
            _buildPerformanceGraph(),
            const SizedBox(height: 20),
            _buildDetailedScoresSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgressCard() {
    double averageScore = _calculateAverageScore();
    return Card(
      color: cardBackgroundColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Overall Progress',
                  style: AppStyles.mondaB.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  '${averageScore.toStringAsFixed(1)}%',
                  'Average Score',
                  _getScoreColor(averageScore),
                  Icons.score,
                ),
                _buildStatCard(
                  widget.assessments.length.toString(),
                  'Tests Taken',
                  Colors.blue,
                  Icons.assignment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppStyles.mondaB.copyWith(
              fontSize: 24,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppStyles.mondaN.copyWith(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceGraph() {
    return Card(
      color: cardBackgroundColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.blue, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Performance Trend',
                  style: AppStyles.mondaB.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              value.toInt().toString(),
                              style: AppStyles.mondaN.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= widget.assessments.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              (value.toInt() + 1)
                                  .toString(), // Simply show numbers starting from 1
                              style: AppStyles.mondaN.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  minX: 0,
                  maxX: (widget.assessments.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSpots(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade900],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeColor: Colors.blue.shade400,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400.withOpacity(0.3),
                            Colors.blue.shade900.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final score = barSpot.y;
                          return LineTooltipItem(
                            '${score.toStringAsFixed(1)}%',
                            AppStyles.mondaB.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.assessments.length; i++) {
      spots.add(FlSpot(
        i.toDouble(),
        widget.assessments[i].overallScore,
      ));
    }
    return spots;
  }

  Widget _buildDetailedScoresSection() {
    return Card(
      color: cardBackgroundColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: Colors.blue, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Detailed Scores',
                  style: AppStyles.mondaB.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.assessments.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final assessment =
                    widget.assessments[widget.assessments.length - 1 - index];
                return _buildDetailedScoreCard(assessment);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedScoreCard(AptitudeTestResult assessment) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AptitudeResultPage(result: assessment),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getFormattedDate(assessment.testDate),
                    style: AppStyles.mondaN.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time taken: ${_formatDuration(assessment.totalTimeTaken)}',
                    style: AppStyles.mondaN.copyWith(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${assessment.overallScore.toStringAsFixed(1)}%',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 20,
                    color: _getScoreColor(assessment.overallScore),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} min';
  }

  double _calculateAverageScore() {
    if (widget.assessments.isEmpty) return 0;
    double total = widget.assessments.fold(
      0,
      (sum, assessment) => sum + assessment.overallScore,
    );
    return total / widget.assessments.length;
  }

  String _getFormattedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
