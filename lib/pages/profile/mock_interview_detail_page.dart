import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/mock_interview_result_model.dart';
import 'package:hirewise/pages/prepzone/test/mockinterview/mock_interview_result_page.dart';

class MockInterviewDetailPage extends StatefulWidget {
  final List<MockInterviewResult> results;

  const MockInterviewDetailPage({
    required this.results,
    super.key,
  });

  @override
  State<MockInterviewDetailPage> createState() =>
      _MockInterviewDetailPageState();
}

class _MockInterviewDetailPageState extends State<MockInterviewDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Interview Results",
          style: AppStyles.mondaN.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
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
              child: widget.results.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.results.length,
                      itemBuilder: (context, index) {
                        final result = widget.results[index];
                        final question = result.question;

                        return _buildRowCard(
                            index: index, result: result, context: context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowCard({
    required int index,
    required MockInterviewResult result,
    required BuildContext context,
  }) {
    final question = result.question;

    return GestureDetector(
      onTap: () {
        // Navigate to the result page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MockInterviewResultPage(result: result),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
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
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
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
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: cardDark.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.videocam_off,
              size: 60,
              color: accentViolet.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Results Yet',
            style: AppStyles.mondaB.copyWith(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Complete your mock interview to see results',
            style: AppStyles.mondaN.copyWith(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ).copyWith(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                return accentViolet.withOpacity(0.2);
              }),
              side: MaterialStateProperty.all(
                BorderSide(color: accentViolet.withOpacity(0.3), width: 1),
              ),
            ),
            child: Text(
              'Go Back',
              style: AppStyles.mondaB.copyWith(
                fontSize: 16,
                color: accentViolet,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
