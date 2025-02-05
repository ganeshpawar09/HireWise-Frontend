import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/prepzone/prepzone.dart';
import 'package:hirewise/study_material.dart';
import 'package:hirewise/pages/prepzone/studymaterial/study_material_detail_page.dart';

class AptitudePreparationPage extends StatelessWidget {
  const AptitudePreparationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Aptitude Preparation",
          style: AppStyles.mondaB.copyWith(
            fontSize: 25,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final topics = [
                    PathItem(
                      "Quantitative",
                      "Numbers, calculations & mathematics",
                      Icons.calculate,
                      accentBlue,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TopicContent(topic: quantitative),
                        ),
                      ),
                    ),
                    PathItem(
                      "Verbal",
                      "Language, comprehension & communication",
                      Icons.language,
                      accentGreen,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicContent(topic: verbal),
                        ),
                      ),
                    ),
                    PathItem(
                      "Logical",
                      "Reasoning, patterns & problem solving",
                      Icons.psychology,
                      accentOrange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicContent(topic: logical),
                        ),
                      ),
                    ),
                  ];
                  return _buildCard(topics[index]);
                },
              ),
              const SizedBox(height: 30),
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
