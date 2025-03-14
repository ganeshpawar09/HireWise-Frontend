import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/prepzone/roadmap/roadmap_page.dart';
import 'package:hirewise/pages/prepzone/sheet/dsa_sheet_page.dart';
import 'package:hirewise/pages/prepzone/studymaterial/aptitude_study_material_page.dart';
import 'package:hirewise/pages/prepzone/studymaterial/cs_fundamentals_study_material_page.dart';
import 'package:hirewise/pages/prepzone/test/aptitude/aptitude_test_setup_page.dart';
import 'package:hirewise/pages/prepzone/test/mockinterview/mock_interview_setup_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
          // 1. Assessment Center first
          _buildSectionHeader(
            'Assessment Center',
            Icons.assessment_outlined,
            accentMint,
          ),
          _buildPracticeSection(),

          // 2. New section for Roadmap and DSA Sheet
          _buildSectionHeader(
            'Programming Track',
            Icons.code_outlined,
            accentBlue,
          ),
          _buildProgrammingTrackSection(),

          // 3. Community section
          _buildSectionHeader(
            'Community',
            Icons.people_alt_outlined,
            accentPink,
          ),
          _buildCommunitySection(),

          // 4. Study Materials last
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
              child: const Icon(
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

  // New section for Roadmap and DSA Sheet
  Widget _buildProgrammingTrackSection() {
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
            "Roadmap",
            "Personalized learning path for development",
            Icons.map_outlined,
            accentBlue,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoadmapPage(),
              ),
            ),
          ),
          PathItem(
            "DSA Sheet",
            "150 curated questions for interviews",
            Icons.format_list_numbered_outlined,
            accentPurple,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DSASheetPage(),
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

  // Community section with the Connect with Peers card
  Widget _buildCommunitySection() {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          final Uri url =
              Uri.parse('https://hirewise-webrtc.netlify.app/');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentPink.withOpacity(0.15),
                accentOrange.withOpacity(0.15),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Connect with Peers",
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Practice communication in English with other candidates",
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentPink.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.groups_outlined,
                  color: accentPink,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
      ),
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
