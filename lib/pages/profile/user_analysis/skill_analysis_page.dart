import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart' as radar;

class SkillAnalysisPage extends StatelessWidget {
  final User user;
  const SkillAnalysisPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills Analysis',
            style: AppStyles.mondaB.copyWith(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your technical and soft skills distribution',
            style: AppStyles.mondaN.copyWith(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          _buildSkillCloud(),
          const SizedBox(height: 24),
          _buildSkillsRadarChart(),
        ],
      ),
    );
  }

  Widget _buildSkillCloud() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skill Cloud',
          style: AppStyles.mondaB.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: user.keySkills.map((skill) {
            // Generate a consistent color based on the skill name
            final colorIndex = skill.length % 4;
            final colors = [
              accentBlue,
              accentPurple,
              accentGreen,
              accentOrange
            ];
            final color = colors[colorIndex];

            return InkWell(
              onTap: () {
                // Handle skill tap if needed
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  skill,
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillsRadarChart() {
    // Define all skill categories
    final Map<String, Set<String>> skillCategories = {
      'Frontend': {
        'React',
        'Vue.js',
        'Next.js',
        'JavaScript',
        'TypeScript',
        'Redux',
        'CSS',
        'Sass',
        'Tailwind CSS',
        'GraphQL',
        'Webpack'
      },
      'Mobile': {
        'Flutter',
        'Dart',
        'Swift',
        'Kotlin',
        'React Native',
        'Android',
        'iOS',
        'Objective-C',
        'Xcode'
      },
      'Backend': {
        'Java',
        'Node.js',
        'Express',
        'MongoDB',
        'Python',
        'PostgreSQL',
        'FastAPI',
        'Spring Boot',
        'MySQL',
        'Redis',
        'Kafka'
      },
      'DevOps': {
        'Docker',
        'Kubernetes',
        'AWS',
        'CI/CD',
        'Jenkins',
        'Terraform',
        'GitLab',
        'GitHub Actions'
      },
      'AI/ML': {
        'TensorFlow',
        'PyTorch',
        'Machine Learning',
        'Deep Learning',
        'NLP',
        'Scikit-learn',
        'Pandas',
        'Keras',
        'Matplotlib',
        'OpenCV'
      },
      'Problem Solving': {
        'Critical thinking',
        'Analytical skills',
        'Decision-making',
        'Creativity and innovation',
        'Logical reasoning',
        'Research and information gathering',
        'Troubleshooting',
        'Adaptability',
        'Resilience',
        'Problem decomposition'
      },
      'Teamwork': {
        'Communication (verbal & written)',
        'Collaboration',
        'Active listening',
        'Conflict resolution',
        'Empathy',
        'Reliability and responsibility',
        'Negotiation',
        'Interpersonal skills',
        'Accountability',
        'Trust-building'
      },
      'Leadership': {
        'Strategic thinking',
        'Vision and goal setting',
        'Motivation and inspiration',
        'Delegation',
        'Emotional intelligence',
        'Coaching and mentoring',
        'Accountability',
        'Time management',
        'Decision-making under pressure',
        'Adaptability in leadership'
      },
      'Personal Development': {
        'Self-motivation',
        'Growth mindset',
        'Time management',
        'Stress management',
        'Work-life balance',
        'Self-awareness',
        'Continuous learning',
        'Networking'
      }
    };

    final userSkillsSet = user.keySkills.toSet();

    int calculateSkillPercentage(Set<String> categorySkills) {
      if (categorySkills.isEmpty) return 0;
      final matchCount = categorySkills.intersection(userSkillsSet).length;
      return (matchCount / categorySkills.length * 100).round().clamp(0, 100);
    }

    // Calculate scores dynamically
    final features = <String>[];
    final scores = <double>[];

    skillCategories.forEach((category, skills) {
      features.add(category);
      scores.add(calculateSkillPercentage(skills).toDouble());
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills Distribution',
          style: AppStyles.mondaB.copyWith(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: radar.RadarChart(
            ticks: const [20, 40, 60, 80, 100],
            features: features,
            data: [scores],
            reverseAxis: false,
            outlineColor: Colors.white.withOpacity(0.2),
            axisColor: Colors.white.withOpacity(0.2),
            ticksTextStyle: AppStyles.mondaN.copyWith(
              color: Colors.white70,
              fontSize: 10,
            ),
            featuresTextStyle: AppStyles.mondaB.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
            graphColors: [accentPink],
          ),
        ),
      ],
    );
  }
}
