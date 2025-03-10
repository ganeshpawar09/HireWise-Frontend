import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/prepzone/roadmap/roadmap_detail_page.dart';
import 'package:hirewise/roadmap.dart';

class RoadmapPage extends StatelessWidget {
  RoadmapPage({super.key});

  final List<Map<String, dynamic>> roadmaps = roadmap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        title: Text(
          "Career Roadmaps",
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderCard(),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: roadmaps.length,
              itemBuilder: (context, index) {
                final roadmap = roadmaps[index];
                final color = _getRoleColor(index);
                return _buildRoadmapCard(context, roadmap, color);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentBlue.withOpacity(0.15),
            accentPurple.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
                    "${roadmaps.length} Career Paths",
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 15,
                      color: accentBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Career Roadmaps",
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 28,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Choose a career path and follow step-by-step guidance to achieve your professional goals",
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
              Icons.route,
              color: accentBlue,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapCard(
      BuildContext context, Map<String, dynamic> roadmap, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoadmapDetailPage(roadmapData: roadmap),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardDark,
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withOpacity(0.3),
                ),
              ),
              child: Icon(
                _getRoleIcon(roadmap['role'] as String),
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roadmap['role'] as String,
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(roadmap['phases'] as List).length} phases · ${_calculateTotalTasks(roadmap)} tasks",
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to calculate total tasks across all phases
  int _calculateTotalTasks(Map<String, dynamic> roadmap) {
    int taskCount = 0;
    for (var phase in roadmap['phases'] as List) {
      taskCount += (phase['tasks'] as List).length;
    }
    return taskCount;
  }

  // Helper method to get color based on role index
  Color _getRoleColor(int index) {
    final colors = [
      accentPurple,
      accentBlue,
      accentOrange,
      accentPink,
      accentGreen,
      accentMint,
      accentViolet,
    ];
    return colors[index % colors.length];
  }

  // Helper method to get icon based on role
  IconData _getRoleIcon(String role) {
    if (role.contains("AI") || role.contains("ML"))
      return Icons.biotech_outlined;
    if (role.contains("Flutter")) return Icons.flutter_dash_outlined;
    if (role.contains("Web")) return Icons.web_outlined;
    if (role.contains("Mobile")) return Icons.phone_android_outlined;
    if (role.contains("Backend")) return Icons.storage_outlined;
    return Icons.work_outline;
  }
}
