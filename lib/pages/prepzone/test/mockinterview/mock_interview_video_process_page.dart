import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/mock_interview_result_model.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class MockInterviewProcessPage extends StatefulWidget {
  final Map<String, String?> questionVideoMap;

  const MockInterviewProcessPage({
    super.key,
    required this.questionVideoMap,
  });

  @override
  State<MockInterviewProcessPage> createState() =>
      _MockInterviewProcessPageState();
}

class _MockInterviewProcessPageState extends State<MockInterviewProcessPage> {
  bool _isUploading = false;
  Map<String, MockInterviewResult> results = {};
  Map<String, bool> expanded = {};
  bool _isProcessing = false;

  void _toggleResultDetails(String question) {
    setState(() {
      expanded[question] = !(expanded[question] ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> processVideo(String question, String videoUrl) async {
    try {
      setState(() => _isProcessing = true);
      print("Processing video...");
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      MockInterviewResult? result = await userProvider.processVideo(
          context: context, question: question, videoUrl: videoUrl);

      if (result != null) {
        setState(() {
          results[question] = result;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _uploadVideo(String question, String videoPath) async {
    try {
      setState(() => _isUploading = true);

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (File(videoPath).existsSync()) {
        final file = File(videoPath);

        final videoUrl = await userProvider.uploadVideo(
          context: context,
          file: file,
        );

        if (videoUrl != null) {
          setState(() {
            print(videoUrl);
            widget.questionVideoMap[question] = videoUrl;
          });
        }
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Process Video",
          style: AppStyles.mondaN.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  darkBackground,
                  darkBackground.withOpacity(0.95),
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.questionVideoMap.length,
                    itemBuilder: (context, index) {
                      final question =
                          widget.questionVideoMap.keys.elementAt(index);
                      final videoPath = widget.questionVideoMap[question];
                      final result = results[question];
                      final isResultExpanded = expanded[question] ?? false;

                      return _buildQuestionCard(
                        index: index,
                        question: question,
                        videoPath: videoPath,
                        result: result,
                        isResultExpanded: isResultExpanded,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isUploading || _isProcessing) _buildLoadingOverlay(),
        ],
      ),
    );
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
                      color: _isUploading ? accentMint : accentViolet,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _isUploading
                        ? 'Uploading your video...'
                        : 'Analyzing your response...',
                    style: AppStyles.mondaB.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isUploading
                        ? 'This may take a moment'
                        : 'Getting your interview feedback',
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

  Widget _buildQuestionCard({
    required int index,
    required String question,
    required String? videoPath,
    MockInterviewResult? result,
    required bool isResultExpanded,
  }) {
    final bool isAlreadyUploaded =
        videoPath != null && videoPath.contains('cloudinary.com');
    final bool hasResults = result != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cardDark,
            surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentBlue, accentTeal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}',
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question,
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cardDark.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (videoPath != null) ...[
                    _buildInfoRow(
                      icon: Icons.video_file,
                      label: 'Video File',
                      value: videoPath,
                      color: accentBlue,
                      iconColor: accentBlue,
                    ),
                    const SizedBox(height: 20),
                    if (!isAlreadyUploaded)
                      _buildActionButton(
                        onPressed: () => _uploadVideo(question, videoPath),
                        icon: Icons.cloud_upload,
                        label: 'Upload Video',
                        gradient: [accentGreen, accentTurquoise],
                        shadowColor: accentGreen,
                      ),
                    if (isAlreadyUploaded && !hasResults)
                      _buildActionButton(
                        onPressed: () => processVideo(question, videoPath),
                        icon: Icons.psychology,
                        label: 'Analyze Response',
                        gradient: [accentBlue, accentIndigo],
                        shadowColor: accentBlue,
                      ),
                    if (hasResults) ...[
                      const SizedBox(height: 24),
                      _buildResultsSummary(result),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _toggleResultDetails(question),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentViolet.withOpacity(0.2),
                                accentPurple.withOpacity(0.2)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accentViolet.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isResultExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: accentViolet,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isResultExpanded
                                    ? 'Hide Details'
                                    : 'View Detailed Analysis',
                                style: AppStyles.mondaB.copyWith(
                                  fontSize: 14,
                                  color: accentViolet,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isResultExpanded) ...[
                        const SizedBox(height: 24),
                        _buildDetailedResults(result),
                      ],
                    ],
                  ] else
                    _buildInfoRow(
                      icon: Icons.warning,
                      label: 'Status',
                      value: 'No video recorded',
                      color: accentOrange,
                      iconColor: accentOrange,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required Color shadowColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: AppStyles.mondaB
                      .copyWith(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSummary(MockInterviewResult result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentViolet.withOpacity(0.15),
            accentPurple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentViolet.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentViolet.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.analytics, color: accentViolet, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Interview Analysis',
                style: AppStyles.mondaB.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildScoreIndicator(
            label: 'Video Confidence',
            value: result.videoConfidence,
            color: accentBlue,
            icon: Icons.videocam,
          ),
          const SizedBox(height: 12),
          _buildScoreIndicator(
            label: 'Audio Confidence',
            value: result.audioConfidence,
            color: accentGreen,
            icon: Icons.mic,
          ),
          const SizedBox(height: 12),
          _buildScoreIndicator(
            label: 'Speaking Fluency',
            value: result.fluencyPercentage,
            color: accentAmber,
            icon: Icons.record_voice_over,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator({
    required String label,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppStyles.mondaN.copyWith(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const Spacer(),
            Text(
              '$value%',
              style: AppStyles.mondaB.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: surfaceDark,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Container(
              height: 6,
              width: (MediaQuery.of(context).size.width - 40) * (value / 100),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.7), color],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedResults(dynamic result) {
    Transcription transcription = result.transcription ?? {};
    Grammar grammar = result.grammar ?? {};
    final fillerWords = transcription.fillerWords;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentViolet.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailedResultsSection(
            title: 'Transcription',
            icon: Icons.text_fields,
            color: accentBlue,
            content: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardDark.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transcription.transcription,
                style: AppStyles.mondaN.copyWith(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailedResultsSection(
            title: 'Filler Words',
            icon: Icons.error_outline,
            color: accentOrange,
            content: fillerWords.isNotEmpty
                ? Column(
                    children: fillerWords.entries
                        .map((entry) => _buildFillerWordItem(
                              word: entry.key,
                              count: entry.value,
                            ))
                        .toList(),
                  )
                : Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: accentGreen.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              color: accentGreen, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'No filler words detected',
                            style: AppStyles.mondaN.copyWith(
                              fontSize: 14,
                              color: accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          _buildDetailedResultsSection(
            title: 'Grammar Analysis',
            icon: Icons.spellcheck,
            color: accentPurple,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grammar Mistakes:',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                ..._buildBulletPoints(
                  grammar.grammarMistakes,
                  icon: Icons.error_outline,
                  color: accentOrange,
                ),
                const SizedBox(height: 20),
                Text(
                  'Enhanced Response:',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentGreen.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: accentGreen.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    grammar.enhancedResponse ??
                        'No enhanced response available',
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 14,
                      color: accentGreen.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Feedback & Suggestions:',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                ..._buildBulletPoints(
                  grammar.feedback,
                  icon: Icons.lightbulb_outline,
                  color: accentBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedResultsSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: AppStyles.mondaB.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildFillerWordItem({
    required String word,
    required int count,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cardDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '"$word"',
            style: AppStyles.mondaB.copyWith(
              fontSize: 14,
              color: accentOrange,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accentOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentOrange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '$count ${count == 1 ? 'time' : 'times'}',
              style: AppStyles.mondaB.copyWith(
                fontSize: 12,
                color: accentOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBulletPoints(List<dynamic> points,
      {required IconData icon, required Color color}) {
    if (points.isEmpty) {
      return [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: cardDark.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'No points available',
              style: AppStyles.mondaN.copyWith(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ];
    }

    return points.map((point) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardDark.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                point.toString(),
                style: AppStyles.mondaN.copyWith(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.mondaN.copyWith(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 14,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
