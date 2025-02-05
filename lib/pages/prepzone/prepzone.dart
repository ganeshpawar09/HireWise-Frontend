import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/prepzone/studymaterial/aptitude_study_material_page.dart';
import 'package:hirewise/pages/prepzone/studymaterial/cs_fundamentals_study_material_page.dart';
import 'package:hirewise/pages/prepzone/test/aptitude/aptitude_test_setup_page.dart';
import 'package:hirewise/pages/prepzone/test/mockinterview/mock_interview_setup_page.dart';

class PrepZonePage extends StatelessWidget {
  const PrepZonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildWelcomeCard(),
          _buildSectionHeader(
            'Assessment Center',
            Icons.assessment_outlined,
            accentMint,
          ),
          _buildPracticeSection(),
          _buildSectionHeader(
            'Study Materials',
            Icons.menu_book_outlined,
            accentPurple,
          ),
          _buildPreparationSection(),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: darkBackground,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.rocket_launch_outlined,
              color: accentBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            "Prep Zone",
            style: AppStyles.mondaB.copyWith(
              fontSize: 26,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentBlue.withOpacity(0.15),
            accentPurple.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: accentBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      "Welcome Back!",
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 15,
                        color: accentBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Ready to level up?",
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 28,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enhance your skills with our comprehensive preparation tools",
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: accentBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: accentBlue.withOpacity(0.3),
                ),
              ),
              child: Icon(
                Icons.rocket_launch_outlined,
                color: accentBlue,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color.withOpacity(0.3),
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: AppStyles.mondaB.copyWith(
              fontSize: 20,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        final paths = [
          PathItem(
            "Mock\nInterview",
            "Practice with simulated interviews",
            Icons.people_outline,
            accentPink,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MockInterviewSetUpPage(),
              ),
            ),
          ),
          PathItem(
            "Aptitude\nTest",
            "Test your analytical and logical skills",
            Icons.timeline_outlined,
            accentBlue,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AptitudeSetUpPage(),
              ),
            ),
          ),
        ];
        return _buildCard(paths[index]);
      },
    );
  }

  Widget _buildPreparationSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        final paths = [
          PathItem(
            "CS\nFundamentals",
            "Core Computer Science concepts",
            Icons.computer_outlined,
            accentMint,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CSFundamentalsStudyMaterialPage(),
              ),
            ),
          ),
          PathItem(
            "Aptitude\nPreparation",
            "Aptitude concepts",
            Icons.psychology_outlined,
            accentOrange,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AptitudePreparationPage(),
              ),
            ),
          ),
        ];
        return _buildCard(paths[index]);
      },
    );
  }

  Widget _buildCard(PathItem path) {
    return GestureDetector(
      onTap: path.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              path.color.withOpacity(0.15),
              path.color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: path.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                path.icon,
                color: path.color,
                size: 28,
              ),
            ),
            const Spacer(),
            Text(
              path.title,
              style: AppStyles.mondaB.copyWith(
                fontSize: 20,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              path.description,
              style: AppStyles.mondaN.copyWith(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PathItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  PathItem(
    this.title,
    this.description,
    this.icon,
    this.color,
    this.onTap,
  );
}
