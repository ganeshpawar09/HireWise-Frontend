import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/mock_interview_result_model.dart';
import 'package:fl_chart/fl_chart.dart';

class MockInterviewResultPage extends StatefulWidget {
  final MockInterviewResult result;

  const MockInterviewResultPage({super.key, required this.result});

  @override
  State<MockInterviewResultPage> createState() =>
      _MockInterviewResultPageState();
}

class _MockInterviewResultPageState extends State<MockInterviewResultPage> {
  bool _showTranscript = false;
  bool _showEnhancedResponse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          'Interview Analysis',
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.close, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestionCard(),
              const SizedBox(height: 24),
              _buildPerformanceCharts(),
              const SizedBox(height: 24),
              _buildGrammarAnalysis(),
              const SizedBox(height: 24),
              _buildTranscriptionCard(),
              if (widget.result.grammar.enhancedResponse != null)
                const SizedBox(height: 24),
              if (widget.result.grammar.enhancedResponse != null)
                _buildEnhancedResponseCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentPurple.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentPurple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accentPurple),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.question_answer,
                      color: accentPurple,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'INTERVIEW QUESTION',
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 12,
                        color: accentPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.result.question,
            style: AppStyles.mondaB.copyWith(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCharts() {
    return Container(
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
            'Performance Analysis',
            style: AppStyles.mondaB.copyWith(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How you performed throughout the interview',
            style: AppStyles.mondaN.copyWith(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),

          // Video confidence chart
          _buildLineChart(
            'Visual Confidence',
            widget.result.videoConfidence,
            accentBlue,
          ),
          const SizedBox(height: 24),

          // Audio confidence chart
          _buildLineChart(
            'Voice Confidence',
            widget.result.audioConfidence,
            accentOrange,
          ),
          const SizedBox(height: 24),

          // Fluency percentage chart
          _buildLineChart(
            'Speech Fluency',
            widget.result.fluencyPercentage,
            accentGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(String title, List<double> data, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              title,
              style: AppStyles.mondaB.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              // Convert 0-1 value to percentage string
              '${data.isEmpty ? "0.0" : (data.reduce((a, b) => a + b) / data.length * 100).toStringAsFixed(1)}%',
              style: AppStyles.mondaB.copyWith(
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 0.25, // Changed to work with 0-1 range
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
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 0.25,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value * 100).toInt()}',
                        style: AppStyles.mondaN.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      );
                    },
                    reservedSize: 28,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: data.length.toDouble() - 1,
              minY: 0,
              maxY: 1,
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(data.length, (index) {
                    return FlSpot(
                        index.toDouble(), data[index]); // Using raw 0-1 values
                  }),
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(
                    show: false,
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrammarAnalysis() {
    final accuracy =
        double.parse(widget.result.grammar.grammarAccuracy.replaceAll('%', ''));

    return Container(
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
            'Grammar Analysis',
            style: AppStyles.mondaB.copyWith(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your language accuracy',
            style: AppStyles.mondaN.copyWith(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: accentGreen, width: 3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.result.grammar.grammarAccuracy,
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Accuracy',
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Response',
                style: AppStyles.mondaB.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  _showTranscript
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _showTranscript = !_showTranscript;
                  });
                },
              ),
            ],
          ),
          if (_showTranscript) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.result.transcription,
                style: AppStyles.mondaN.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEnhancedResponseCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enhanced Response',
                style: AppStyles.mondaB.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(
                  _showEnhancedResponse
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _showEnhancedResponse = !_showEnhancedResponse;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'A polished version of your answer',
            style: AppStyles.mondaN.copyWith(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          if (_showEnhancedResponse &&
              widget.result.grammar.enhancedResponse != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentGreen.withOpacity(0.2)),
              ),
              child: Text(
                widget.result.grammar.enhancedResponse!,
                style: AppStyles.mondaN.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
