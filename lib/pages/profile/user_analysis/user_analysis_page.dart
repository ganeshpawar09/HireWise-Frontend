import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/user_analysis/aptitude_analysis_page.dart';
import 'package:hirewise/pages/profile/user_analysis/mock_interview_analysis_page.dart';
import 'package:hirewise/pages/profile/user_analysis/skill_analysis_page.dart';

class UserAnalysisPage extends StatefulWidget {
  final User user;

  const UserAnalysisPage({super.key, required this.user});

  @override
  State<UserAnalysisPage> createState() => _UserAnalysisPageState();
}

class _UserAnalysisPageState extends State<UserAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          'User Analysis',
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
            child: const Icon(Icons.arrow_back, color: Colors.white),
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
              _buildProfileCompletionCard(),
              const SizedBox(height: 24),
              SkillAnalysisPage(user: widget.user),
              const SizedBox(height: 24),
              AptitudeAnalysisPage(user: widget.user),
              const SizedBox(height: 24),
              MockInterviewAnalysisPage(user: widget.user),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCompletionCard() {
    // Calculate profile completion percentage
    final totalFields = 15; // Counting main user fields
    int filledFields = 0;

    if (widget.user.firstName != null) filledFields++;
    if (widget.user.lastName != null) filledFields++;
    if (widget.user.gender != null) filledFields++;
    if (widget.user.dateOfBirth != null) filledFields++;
    if (widget.user.location != null) filledFields++;
    if (widget.user.phoneNumber != null) filledFields++;
    if (widget.user.profileHeadline != null) filledFields++;
    if (widget.user.profileSummary != null) filledFields++;
    if (widget.user.keySkills.isNotEmpty) filledFields++;
    if (widget.user.achievements.isNotEmpty) filledFields++;
    if (widget.user.education.isNotEmpty) filledFields++;
    if (widget.user.experience.isNotEmpty) filledFields++;
    if (widget.user.projects.isNotEmpty) filledFields++;
    if (widget.user.linkedin != null) filledFields++;
    if (widget.user.github != null) filledFields++;

    final completionPercentage = (filledFields / totalFields) * 100;

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
                    const Icon(
                      Icons.person,
                      color: accentPurple,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PROFILE COMPLETION',
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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${completionPercentage.toInt()}%',
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Profile Completion',
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: completionPercentage / 100,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        color: _getCompletionColor(completionPercentage),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getCompletionMessage(completionPercentage),
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCompletionColor(double percentage) {
    if (percentage < 40) return Colors.redAccent;
    if (percentage < 70) return accentOrange;
    return accentGreen;
  }

  String _getCompletionMessage(double percentage) {
    if (percentage < 40)
      return 'Your profile needs more information to attract recruiters';
    if (percentage < 70)
      return 'Good progress! Complete a few more sections to stand out';
    if (percentage < 90)
      return 'Almost there! Just a few more details to perfect your profile';
    return 'Excellent! Your profile is fully optimized for recruiters';
  }
}
