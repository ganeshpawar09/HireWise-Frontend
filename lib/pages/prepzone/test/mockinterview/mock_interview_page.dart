import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/prepzone/test/mockinterview/mock_interview_video_process_page.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hirewise/provider/user_provider.dart';

class MockInterviewPage extends StatefulWidget {
  const MockInterviewPage({super.key});

  @override
  State<MockInterviewPage> createState() => _MockInterviewPageState();
}

class _MockInterviewPageState extends State<MockInterviewPage> {
  int _currentQuestionIndex = 0;
  final FlutterTts _flutterTts = FlutterTts();
  final List<StreamSubscription<dynamic>> _ttsSubscriptions = [];
  bool _isSpeaking = false;
  Map<String, String?> questionVideoMap = {};
  @override
  void initState() {
    super.initState();
    _initTts();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    for (var sub in _ttsSubscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setErrorHandler((error) {
        setState(() => _isSpeaking = false);
        _showError('TTS Error: $error');
      });

      _flutterTts.setCompletionHandler(() {
        setState(() => _isSpeaking = false);
      });

      // Get available voices
      try {
        final voices = await _flutterTts.getVoices;
        // Try to find a female English voice
        for (var voice in voices) {
          if (voice['locale'].toString().startsWith('en') &&
              voice['gender'] == 'female') {
            await _flutterTts.setVoice(voice);
            break;
          }
        }
      } catch (e) {
        // If getting voices fails, continue with default voice
        debugPrint('Failed to get voices: $e');
      }
    } catch (e) {
      _showError('Failed to initialize TTS: $e');
    }
  }

  Future<void> _speakQuestion() async {
    if (_isSpeaking) {
      await _stopSpeaking();
      return;
    }

    final questions = context.read<UserProvider>().questions;
    if (_currentQuestionIndex >= questions.length) return;

    try {
      setState(() => _isSpeaking = true);

      final question = questions[_currentQuestionIndex];
      final result = await _flutterTts.speak(question);

      if (result != 1) {
        throw Exception('Failed to start TTS');
      }
    } catch (e) {
      setState(() => _isSpeaking = false);
      _showError('Failed to speak question: $e');
    }
  }

  Future<void> _stopSpeaking() async {
    try {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    } catch (e) {
      _showError('Failed to stop speaking: $e');
    }
  }

  Future<void> _pickVideoFile(String question) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          questionVideoMap[question] = result.files.single.path;
        });
        _showSuccess('Video file selected successfully');
      } else {
        _showError('No file selected');
      }
    } catch (e) {
      _showError('Failed to pick video file: $e');
    }
  }

  void _handleNextQuestion() {
    if (_currentQuestionIndex <
        context.read<UserProvider>().questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _speakQuestion();
    }
  }

  void _submitInterview() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MockInterviewProcessPage(
          questionVideoMap: questionVideoMap,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = context.watch<UserProvider>().questions;
    final hasQuestions = questions.isNotEmpty;
    final isLastQuestion = _currentQuestionIndex == questions.length - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: !hasQuestions
          ? _buildNoQuestionsView()
          : SafeArea(
              child: Column(
                children: [
                  _buildProgressBar(questions.length),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQuestionHeader(),
                          const SizedBox(height: 24),
                          _buildQuestionCard(questions),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigation(
          isLastQuestion, questions[_currentQuestionIndex]),
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
                const Icon(
                  Icons.videocam,
                  color: Colors.purple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mock Interview',
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
          onPressed: () => _showSubmitConfirmation(),
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

  Widget _buildProgressBar(int totalQuestions) {
    return Column(
      children: [
        Container(
          height: 4,
          width: double.infinity,
          color: Colors.grey.withOpacity(0.2),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (_currentQuestionIndex + 1) / totalQuestions,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.purple.withOpacity(0.7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of $totalQuestions',
                style: AppStyles.mondaN.copyWith(
                  color: Colors.purple[300],
                  fontSize: 14,
                ),
              ),
              Text(
                '${((_currentQuestionIndex + 1) / totalQuestions * 100).round()}%',
                style: AppStyles.mondaN.copyWith(
                  color: Colors.purple[300],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.question_answer,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Interview Question',
            style: AppStyles.mondaB.copyWith(
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(List<String> questions) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questions[_currentQuestionIndex],
            style: AppStyles.mondaB.copyWith(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _speakQuestion,
            icon: Icon(
              _isSpeaking ? Icons.stop : Icons.volume_up,
              size: 20,
            ),
            label: Text(_isSpeaking ? 'Stop' : 'Listen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.withOpacity(0.2),
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: questionVideoMap[questions[_currentQuestionIndex]] == null
                ? Text(
                    'No video file selected',
                    style: AppStyles.mondaN.copyWith(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  )
                : Text(
                    'Video file selected',
                    style: AppStyles.mondaN.copyWith(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(bool isLastQuestion, String question) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavigationButton(
              'Select Video',
              Icons.video_library,
              Colors.orange,
              () => _pickVideoFile(question),
            ),
            _buildNavigationButton(
              isLastQuestion ? 'Finish' : 'Next Question',
              isLastQuestion ? Icons.check : Icons.arrow_forward_ios,
              Colors.green,
              () {
                if (isLastQuestion) {
                  _showSubmitConfirmation();
                } else {
                  _handleNextQuestion();
                }
              },
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
          'Submit Interview?',
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
              'Are you sure you want to submit your interview responses?',
              style: AppStyles.mondaN.copyWith(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            _buildInterviewSummary(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Review Responses',
              style: AppStyles.mondaN.copyWith(
                color: Colors.white70,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitInterview();
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

  Widget _buildInterviewSummary() {
    final questions = context.read<UserProvider>().questions;
    final answeredQuestions = questionVideoMap.length;
    final remainingQuestions = questions.length - answeredQuestions;

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
            'Questions Answered',
            answeredQuestions,
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Remaining Questions',
            remainingQuestions,
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

Widget _buildNoQuestionsView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.question_answer_outlined, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'No questions available',
          style: AppStyles.mondaN.copyWith(
            color: Colors.grey[400],
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}
