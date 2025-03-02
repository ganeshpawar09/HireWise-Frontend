import 'package:flutter/material.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/aptitude_test_result_model.dart';
import 'package:hirewise/models/question_model.dart';

class AptitudeResultPage extends StatefulWidget {
  final AptitudeTestResult result;

  const AptitudeResultPage({super.key, required this.result});

  @override
  State<AptitudeResultPage> createState() => _AptitudeResultPageState();
}

class _AptitudeResultPageState extends State<AptitudeResultPage> {
  // Track which explanations are expanded
  final Map<Question, bool> _expandedExplanations = {};

  String duration(Duration time) {
    String timeText;
    if (time.inHours > 0) {
      timeText = '${time.inHours}h ${time.inMinutes.remainder(60)}m';
    } else if (time.inMinutes > 0) {
      timeText = '${time.inMinutes}m ${time.inSeconds.remainder(60)}s';
    } else {
      timeText = '${time.inSeconds}s';
    }

    return timeText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          'Aptitude Test Result',
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
              _buildOverallPerformance(),
              const SizedBox(height: 24),
              _buildQuestionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallPerformance() {
    final score = widget.result.overallScore;
    final scoreColor = score >= 80
        ? Colors.green
        : score >= 60
            ? Colors.orange
            : Colors.red;

    final correctAnswers = widget.result.selectedOptions.entries
        .where((entry) => entry.value == entry.key.correctOptionIndex)
        .length;
    final totalQuestions = widget.result.selectedOptions.length;
    final unansweredQuestions = widget.result.selectedOptions.entries
        .where((entry) => entry.value == -1)
        .length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scoreColor.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scoreColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Performance',
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep pushing forward!',
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              _buildScoreCircle(score, scoreColor),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Questions',
                '$totalQuestions',
                Icons.question_answer,
                Colors.blue,
              ),
              _buildStatItem(
                'Correct',
                '$correctAnswers',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatItem(
                'Unanswered',
                '$unansweredQuestions',
                Icons.remove_circle_outline,
                Colors.amber,
              ),
              _buildStatItem(
                'Time',
                duration(Duration(seconds: widget.result.totalTimeTaken)),
                Icons.timer,
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCircle(double score, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 12,
            backgroundColor: color.withOpacity(0.1),
            color: color,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${score.round()}%',
              style: AppStyles.mondaB.copyWith(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            Text(
              'Score',
              style: AppStyles.mondaN.copyWith(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppStyles.mondaB.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
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

  Widget _buildQuestionsList() {
    // Sort questions by topic and subtopic for better organization
    final questionEntries = widget.result.selectedOptions.entries.toList();
    questionEntries.sort((a, b) {
      int topicCompare = a.key.topic.compareTo(b.key.topic);
      if (topicCompare != 0) return topicCompare;
      return a.key.subTopic.compareTo(b.key.subTopic);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question Analysis',
          style: AppStyles.mondaB.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...questionEntries.map((entry) {
          final question = entry.key;
          final selectedOption = entry.value;
          final isUnanswered = selectedOption == -1;
          final isCorrect = !isUnanswered && selectedOption == question.correctOptionIndex;

          return _buildQuestionCard(question, selectedOption, isCorrect, isUnanswered);
        }).toList(),
      ],
    );
  }

  Widget _buildQuestionCard(
      Question question, int selectedOption, bool isCorrect, bool isUnanswered) {
    // Initialize expansion state if not already set
    _expandedExplanations[question] ??= false;

    // Determine card color based on answer status
    Color cardColor;
    if (isUnanswered) {
      cardColor = Colors.amber; // Yellow for unanswered
    } else {
      cardColor = isCorrect ? Colors.green : Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cardColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUnanswered 
                              ? Icons.remove_circle_outline
                              : (isCorrect ? Icons.check_circle : Icons.cancel),
                            color: cardColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isUnanswered 
                              ? 'Unanswered'
                              : (isCorrect ? 'Correct' : 'Incorrect'),
                            style: AppStyles.mondaB.copyWith(
                              fontSize: 12,
                              color: cardColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getDifficultyLabel(question.level),
                        style: AppStyles.mondaN.copyWith(
                          fontSize: 12,
                          color: _getDifficultyColor(question.level),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  question.questionText,
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildOptionsGrid(question, selectedOption),
                const SizedBox(height: 12),
                _buildTopicSubtopicRow(question),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      _expandedExplanations[question] =
                          !_expandedExplanations[question]!;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        _expandedExplanations[question]!
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Explanation',
                        style: AppStyles.mondaB.copyWith(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Explanation section (expandable)
          if (_expandedExplanations[question]!)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                question.explanation,
                style: AppStyles.mondaN.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid(Question question, int selectedOption) {
    return Column(
      children: List.generate(
        question.options.length,
        (index) {
          final isSelected = selectedOption == index;
          final isCorrect = question.correctOptionIndex == index;
          final isUnanswered = selectedOption == -1;

          Color backgroundColor;
          Color borderColor;

          if (isUnanswered) {
            if (isCorrect) {
              // Correct answer but question was unanswered
              backgroundColor = Colors.amber.withOpacity(0.1);
              borderColor = Colors.amber.withOpacity(0.5);
            } else {
              // Not the correct answer and question was unanswered
              backgroundColor = Colors.white.withOpacity(0.05);
              borderColor = Colors.white.withOpacity(0.1);
            }
          } else if (isSelected && isCorrect) {
            // Correct answer selected
            backgroundColor = Colors.green.withOpacity(0.2);
            borderColor = Colors.green;
          } else if (isSelected && !isCorrect) {
            // Wrong answer selected
            backgroundColor = Colors.red.withOpacity(0.2);
            borderColor = Colors.red;
          } else if (!isSelected && isCorrect) {
            // Correct answer not selected
            backgroundColor = Colors.green.withOpacity(0.1);
            borderColor = Colors.green.withOpacity(0.5);
          } else {
            // Not selected, not correct
            backgroundColor = Colors.white.withOpacity(0.05);
            borderColor = Colors.white.withOpacity(0.1);
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isCorrect ? Colors.green : Colors.red)
                        : Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D...
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.options[index],
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isCorrect)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicSubtopicRow(Question question) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            question.topic,
            style: AppStyles.mondaN.copyWith(
              fontSize: 12,
              color: Colors.purple,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            question.subTopic,
            style: AppStyles.mondaN.copyWith(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String level) {
    switch (level.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getDifficultyLabel(String level) {
    return level.toUpperCase();
  }
}