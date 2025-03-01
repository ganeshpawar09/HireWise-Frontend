import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileFeedbackPage extends StatefulWidget {
  final String userId;
  const ProfileFeedbackPage({super.key, required this.userId});

  @override
  State<ProfileFeedbackPage> createState() => _ProfileFeedbackPageState();
}

class _ProfileFeedbackPageState extends State<ProfileFeedbackPage> {
  @override
  void initState() {
    super.initState();
    // Load feedback once when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeedback(context);
    });
  }

  Future<void> _loadFeedback(BuildContext context) async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .getUserFeedback(context: context, userId: widget.userId);
    } catch (e) {
      if (!mounted) return;
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Something went wrong while fetching feedback'),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => _loadFeedback(context),
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    title == 'Feedback'
                        ? Icons.feedback_outlined
                        : Icons.lightbulb_outline,
                    color: customBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContent(UserProvider userProvider) {
    final feedback = userProvider.userFeedback;

    if (feedback == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: customBlue,
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AI-Powered Profile Analysis",
              style: AppStyles.mondaB.copyWith(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Here's what our AI thinks about your profile",
              style: AppStyles.mondaN.copyWith(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            _buildFeedbackSection('Feedback', feedback.feedback),
            _buildFeedbackSection('Improvement Tips', feedback.tips),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Feedback',
          style: AppStyles.mondaB.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) =>
              _buildContent(userProvider),
        ),
      ),
    );
  }
}
