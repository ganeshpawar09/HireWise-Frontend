import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/aptitude_test_result_model.dart';
import 'package:hirewise/models/question_model.dart';
import 'package:hirewise/pages/prepzone/test/aptitude/aptitude_result_page.dart';
import 'package:hirewise/provider/topic_provider.dart';
import 'package:provider/provider.dart';

class AptitudeTestPage extends StatefulWidget {
  final List<Question> questions;
  final int timePerQuestion;

  const AptitudeTestPage(
      {super.key, required this.questions, required this.timePerQuestion});

  @override
  State<AptitudeTestPage> createState() => _AptitudeTestPageState();
}

class _AptitudeTestPageState extends State<AptitudeTestPage> {
  late List<Question> testQuestions;
  late int timeLeft;
  late int totalTimeTaken;
  int currentQuestionIndex = 0;
  bool isTestComplete = false;
  Map<Question, int> selectedOptions = {};
  DateTime? testStartTime;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    testQuestions = widget.questions;
    timeLeft = widget.timePerQuestion;
    totalTimeTaken = 0;
    testStartTime = DateTime.now();
    _startTimer();
    for (var question in testQuestions) {
      selectedOptions[question] = -1;
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      if (isTestComplete) return false;

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            _moveToNextQuestion();
          }
        });
      }
      return !isTestComplete;
    });
  }

  void _moveToNextQuestion() {
    if (currentQuestionIndex < testQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        timeLeft = widget.timePerQuestion;
      });
    } else {
      _completeTest();
    }
  }

  void _completeTest() async {
    setState(() {
      isTestComplete = true;
      totalTimeTaken = DateTime.now().difference(testStartTime!).inSeconds;
      _isProcessing = true;
    });

    int totalCorrect = 0;

    // Iterate over selected options and compare with correct answers
    selectedOptions.forEach((question, selectedOptionIndex) {
      if (selectedOptionIndex != -1 &&
          question.correctOptionIndex == selectedOptionIndex) {
        totalCorrect++;
      }
    });

    final testResult = AptitudeTestResult(
        testDate: DateTime.now(),
        totalTimeTaken: totalTimeTaken,
        selectedOptions: selectedOptions,
        overallScore: (totalCorrect / widget.questions.length) * 100);

    TopicProvider topicProvider =
        Provider.of<TopicProvider>(context, listen: false);

    try {
      bool updateSuccess =
          await topicProvider.updateAptitudeResult(context, testResult);
      print(updateSuccess);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (updateSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AptitudeResultPage(result: testResult),
            ),
          );
        } else {
          _showUpdateFailedDialog(testResult);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _showUpdateFailedDialog(testResult);
      }
    }
  }

  void _showUpdateFailedDialog(AptitudeTestResult testResult) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.withOpacity(0.3), width: 2),
        ),
        title: Text(
          'Failed to Submit',
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We couldn\'t save your test results. Please check your internet connection and try again.',
              style: AppStyles.mondaN.copyWith(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isProcessing = true;
              });
              _retrySubmitTest(testResult);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.2),
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Try Again',
              style: AppStyles.mondaB.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _retrySubmitTest(AptitudeTestResult testResult) async {
    TopicProvider topicProvider =
        Provider.of<TopicProvider>(context, listen: false);

    try {
      bool updateSuccess =
          await topicProvider.updateAptitudeResult(context, testResult);

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (updateSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AptitudeResultPage(result: testResult),
            ),
          );
        } else {
          _showUpdateFailedDialog(testResult);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _showUpdateFailedDialog(testResult);
      }
    }
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: darkBackground.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: accentMint,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Processing your results...',
                    style: AppStyles.mondaB.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This may take a moment',
                    style: AppStyles.mondaN.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.green.withOpacity(0.3), width: 2),
        ),
        title: Text(
          'Submit Test?',
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to submit the test?',
              style: AppStyles.mondaN.copyWith(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            _buildSubmitSummary(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue Test',
              style: AppStyles.mondaN.copyWith(
                color: Colors.white70,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeTest();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.2),
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Submit',
              style: AppStyles.mondaB.copyWith(
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitSummary() {
    int answeredCount = 0;
    selectedOptions.forEach((question, selectedOption) {
      if (selectedOption != -1) {
        answeredCount++;
      }
    });

    final unansweredQuestions = testQuestions.length - answeredCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
            'Answered',
            answeredCount,
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Unanswered',
            unansweredQuestions,
            Icons.help,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, int count, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppStyles.mondaN.copyWith(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const Spacer(),
        Text(
          count.toString(),
          style: AppStyles.mondaB.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.timer,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '$timeLeft s',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: _showSubmitConfirmation,
          icon: const Icon(
            Icons.done_all,
            color: Colors.green,
            size: 20,
          ),
          label: Text(
            'Submit',
            style: AppStyles.mondaB.copyWith(
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigation(),
        ),
        if (_isProcessing) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildProgressBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuestionHeader(),
                const SizedBox(height: 24),
                _buildQuestionText(),
                const SizedBox(height: 32),
                _buildOptions(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 4,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (currentQuestionIndex + 1) / testQuestions.length,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.withOpacity(0.7)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Question ${currentQuestionIndex + 1}',
            style: AppStyles.mondaB.copyWith(
              fontSize: 16,
              color: Colors.purple,
            ),
          ),
          Text(
            ' of ${testQuestions.length}',
            style: AppStyles.mondaN.copyWith(
              fontSize: 16,
              color: Colors.purple.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        testQuestions[currentQuestionIndex].questionText,
        style: AppStyles.mondaB.copyWith(
          fontSize: 18,
          color: Colors.white,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(
        testQuestions[currentQuestionIndex].options.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOptionCard(index),
        ),
      ),
    );
  }

  Widget _buildOptionCard(int optionIndex) {
    final isSelected =
        selectedOptions[testQuestions[currentQuestionIndex]] == optionIndex;
    final option = testQuestions[currentQuestionIndex].options[optionIndex];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: buildOptionCard(
        title: option,
        primaryColor: Colors.blue,
        icon: isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
        onTap: () {
          setState(() {
            selectedOptions[testQuestions[currentQuestionIndex]] = optionIndex;
          });
        },
        isSelected: isSelected,
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildNavigationButton(
              currentQuestionIndex < testQuestions.length - 1
                  ? 'Next'
                  : 'Finish',
              Icons.arrow_forward_ios,
              Colors.green,
              () {
                if (currentQuestionIndex < testQuestions.length - 1) {
                  _moveToNextQuestion();
                } else {
                  _completeTest();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppStyles.mondaB.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildOptionCard({
  required String title,
  required Color primaryColor,
  required IconData icon,
  required VoidCallback onTap,
  bool isSelected = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.02),
            primaryColor.withOpacity(0.01),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? primaryColor : primaryColor.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: primaryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyles.mondaB.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
