import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/aptitude_test_result_model.dart';
import 'package:hirewise/models/mock_interview_result_model.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/login/email_verification_page.dart';
import 'package:hirewise/pages/profile/aptitude_detail_page.dart';
import 'package:hirewise/pages/profile/edit/achievement_edit_page.dart';
import 'package:hirewise/pages/profile/edit/basic_detail_page.dart';
import 'package:hirewise/pages/profile/edit/education_edit_page.dart';
import 'package:hirewise/pages/profile/edit/experience_edit_page.dart';
import 'package:hirewise/pages/profile/edit/personal_detail_edit_page.dart';
import 'package:hirewise/pages/profile/edit/profile_header_edit_page.dart';
import 'package:hirewise/pages/profile/edit/profile_summary_edit_page.dart';
import 'package:hirewise/pages/profile/edit/project_edit_page.dart';
import 'package:hirewise/pages/profile/edit/skill_edit_page.dart';
import 'package:hirewise/pages/profile/edit/social_link_edit.dart';
import 'package:hirewise/pages/profile/mock_interview_detail_page.dart';
import 'package:hirewise/pages/profile/profile_builder_page.dart';
import 'package:hirewise/pages/profile/profile_feedback_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final bool viewer;
  const ProfilePage({super.key, required this.user, required this.viewer});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Color> colorPalette = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.yellow,
    Colors.pink,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple
  ];
  final Random _random = Random();

  Color getRandomColor() {
    return colorPalette[_random.nextInt(colorPalette.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Profile",
          style: AppStyles.mondaB.copyWith(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionCard("", _buildProfileHeader()),
              const SizedBox(height: 16),
              _buildActionButton(
                title: 'Build Your Profile',
                subtitle: 'Generate profile from your resume',
                icon: Icons.description_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileBuilderPage(user: widget.user),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              _buildActionButton(
                title: 'Get Profile Feedback',
                subtitle: 'Receive personalized feedback and tips',
                icon: Icons.analytics_outlined,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileFeedbackPage(
                            userId: widget.user.id,
                          )));
                },
              ),
              const SizedBox(height: 16),
              _buildSectionCard('Basic details', _buildBasicDetails()),
              const SizedBox(height: 16),
              _buildSectionCard('Profile summary', _buildProfileSummary()),
              const SizedBox(height: 16),
              _buildAptitudeCard(
                widget.user.aptitudeTestResult,
                customBlue,
              ),
              const SizedBox(height: 16),
              _buildMockInterviewCard(
                  widget.user.mockInterviewResult, accentPink),
              const SizedBox(height: 16),
              _buildSectionCard('Education', _buildEducation()),
              const SizedBox(height: 16),
              _buildSectionCard('Experience', _buildExperience()),
              const SizedBox(height: 16),
              _buildSectionCard('Projects', _buildProjects()),
              const SizedBox(height: 16),
              _buildSectionCard('Skills', _buildSkills()),
              const SizedBox(height: 16),
              _buildSectionCard('Achievements', _buildAchievements()),
              const SizedBox(height: 16),
              _buildSectionCard('Social Links', _buildSocialLinks()),
              const SizedBox(height: 16),
              _buildSectionCard('Personal details', _buildPersonalDetails()),
              const SizedBox(height: 16),
              _buildCodingProfiles(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('user_data');
                  await prefs.remove('access_token');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmailVerificationPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 70),
                  backgroundColor: customBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Log out',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: cardBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: customBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: customBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Card(
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppStyles.mondaB.copyWith(fontSize: 18),
                ),
                (widget.viewer)
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          switch (title) {
                            case 'Basic details':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BasicDetailsEditPage(user: widget.user),
                                ),
                              );
                              break;
                            case 'Profile summary':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileSummaryEditPage(user: widget.user),
                                ),
                              );
                              break;
                            case 'Education':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EducationEditPage(user: widget.user),
                                ),
                              );
                              break;
                            case 'Skills':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SkillsEditPage(user: widget.user),
                                ),
                              );
                              break;
                            case 'Projects':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProjectsEditPage(user: widget.user),
                                ),
                              );
                              break;
                            case 'Achievements':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AchievementsEditPage(user: widget.user),
                                ),
                              );
                              break;
                            case 'Social Links':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SocialLinksEditPage(
                                    user: widget.user,
                                  ),
                                ),
                              );
                              break;
                            case 'Experience':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExperienceEditPage(
                                    user: widget.user,
                                  ),
                                ),
                              );
                              break;
                            case 'Personal details':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonalDetailEditPage(
                                    user: widget.user,
                                  ),
                                ),
                              );
                              break;
                            case '':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileHeaderEditPage(
                                    user: widget.user,
                                  ),
                                ),
                              );
                              break;
                          }
                        },
                        icon: Icon(MdiIcons.pencil),
                        color: Colors.blue),
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildBasicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem(MdiIcons.briefcase,
            (widget.user.fresher ?? false) ? "Fresher" : "Experience"),
        _buildDetailItem(MdiIcons.mapMarker, widget.user.location ?? ""),
        _buildDetailItem(MdiIcons.email, widget.user.email),
        _buildDetailItem(MdiIcons.phone, widget.user.phoneNumber ?? ""),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppStyles.mondaN)),
        ],
      ),
    );
  }

  Widget _buildProfileSummary() {
    return Text(
      widget.user.profileSummary ?? "",
      style: AppStyles.mondaN.copyWith(fontSize: 14),
    );
  }

  Widget _buildAchievements() {
    return Card(
      color: cardBackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.user.achievements.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: customBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: AppStyles.mondaB.copyWith(
                            color: customBlue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.user.achievements[index],
                        style: AppStyles.mondaN.copyWith(
                          color: Colors.grey[300],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperience() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.user.experience.length,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        height: 32,
      ),
      itemBuilder: (context, index) {
        final exp = widget.user.experience[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: customBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.work, color: customBlue, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp.jobTitle,
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exp.companyName,
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 14,
                            color: customBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2D2D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 1,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${exp.startDate} - ${exp.endDate}",
                                style: AppStyles.mondaN.copyWith(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
      },
    );
  }

  Widget _buildEducation() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.user.education.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final edu = widget.user.education[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: customBlue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.school, color: customBlue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edu.degree,
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      edu.institution,
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 14,
                        color: customBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${edu.startYear} - ${edu.endYear}",
                            style: AppStyles.mondaN.copyWith(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: AppStyles.mondaN.copyWith(color: Colors.grey)),
        Text(widget.user.gender ?? "",
            style: AppStyles.mondaN.copyWith(color: Colors.white)),
        const SizedBox(height: 8),
        Text('Date of birth',
            style: AppStyles.mondaN.copyWith(color: Colors.grey)),
        Text(widget.user.dateOfBirth ?? "",
            style: AppStyles.mondaN.copyWith(color: Colors.white)),
        const SizedBox(height: 8),
        Text('Differently abled',
            style: AppStyles.mondaN.copyWith(color: Colors.grey)),
        Text((widget.user.differentlyAbled ?? false) ? "Yes" : "No",
            style: AppStyles.mondaN.copyWith(color: Colors.white)),
        const SizedBox(height: 8),
        Text('Career break',
            style: AppStyles.mondaN.copyWith(color: Colors.grey)),
        Text((widget.user.careerBreak ?? false) ? "Yes" : "No",
            style: AppStyles.mondaN.copyWith(color: Colors.white)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProjects() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.user.projects.length,
      itemBuilder: (context, index) {
        final project = widget.user.projects[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Dark background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: AppStyles.mondaB.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _launchURL(project.projectLink),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: customBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.link,
                                size: 16,
                                color: customBlue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'View Project',
                                style: AppStyles.mondaN.copyWith(
                                  color: customBlue,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  project.description,
                  style: AppStyles.mondaN.copyWith(
                    color: Colors.grey[300],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technologies',
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project.technologyUsed
                          .split(',')
                          .map((tech) => tech.trim())
                          .map((tech) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF2D2D2D), // Slightly lighter dark background
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tech,
                                  style: AppStyles.mondaN.copyWith(
                                    fontSize: 13,
                                    color: customBlue,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.user.keySkills
              .map(
                (skill) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 15,
                      color: customBlue,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child:
                      const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt,
                        size: 18, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement image picker
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.user.name ?? "",
              style: AppStyles.mondaB.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.profileHeadline ?? "",
              style:
                  AppStyles.mondaN.copyWith(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildSocialButton(MdiIcons.linkedin, 'LinkedIn', Colors.blue),
        _buildSocialButton(MdiIcons.github, 'GitHub', Colors.white),
        _buildSocialButton(MdiIcons.web, 'Portfolio', Colors.purple),
        _buildSocialButton(Icons.code, 'Leetcode', Colors.lightBlue),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String platform, Color color) {
    return InkWell(
      onTap: () {
        String? url;
        switch (platform) {
          case "Linkedin":
            if (widget.user.linkedin != null &&
                widget.user.linkedin!.isNotEmpty) {
              url = widget.user.linkedin;
            }
            break;
          case "Portfolio":
            if (widget.user.portfolio != null &&
                widget.user.portfolio!.isNotEmpty) {
              url = widget.user.portfolio;
            }
            break;
          case "Leetcode":
            if (widget.user.leetcode != null &&
                widget.user.leetcode!.isNotEmpty) {
              url = "https://leetcode.com/${widget.user.leetcode}";
            }
            break;
          case "GitHub":
            if (widget.user.github != null && widget.user.github!.isNotEmpty) {
              url = "https://github.com/${widget.user.github}";
            }
            break;
        }
        if (url != null) {
          _launchURL(url);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              platform,
              style: AppStyles.mondaN.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Cannot launch URL: $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  Widget _buildAptitudeCard(
    List<AptitudeTestResult> assessments,
    Color color,
  ) {
    bool hasTests = assessments.isNotEmpty;

    // Calculate statistics if tests exist
    double averageScore = 0;
    int averageTime = 0;
    double latestScore = hasTests ? assessments.last.overallScore : 0;
    int totalQuestions = 0;

    if (hasTests) {
      double totalScore = 0;
      int totalTime = 0;

      for (var test in assessments) {
        totalScore += test.overallScore;
        totalTime += test.totalTimeTaken;
        // Count questions from the most recent test
        if (test == assessments.last) {
          totalQuestions = test.selectedOptions.length;
        }
      }

      averageScore = totalScore / assessments.length;
      averageTime = (totalTime / assessments.length).round();
    }

    // Format time from seconds to mm:ss
    String formatTime(int seconds) {
      final mins = seconds ~/ 60;
      final secs = seconds % 60;
      return '$mins:${secs.toString().padLeft(2, '0')}';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AptitudeDetailPage(
              type: 'Aptitude Test',
              assessments: assessments,
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.05),
              cardBackgroundColor,
            ],
          ),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: color),
                    const SizedBox(width: 8),
                    Text(
                      'Aptitude Test',
                      style: AppStyles.mondaB.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                if (hasTests)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${assessments.length} completed',
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 12,
                        color: color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasTests) ...[
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildAptitudeMetric(
                        'Latest\nScore',
                        '${latestScore.toStringAsFixed(0)}%',
                        Icons.trending_up,
                        color,
                      ),
                    ),
                    Expanded(
                      child: _buildAptitudeMetric(
                        'Average\nScore',
                        '${averageScore.toStringAsFixed(0)}%',
                        Icons.bar_chart,
                        color,
                      ),
                    ),
                    Expanded(
                      child: _buildAptitudeMetric(
                        'Avg. Time\nper Test',
                        formatTime(averageTime),
                        Icons.timer,
                        color,
                      ),
                    ),
                    Expanded(
                      child: _buildAptitudeMetric(
                        'Questions\nAnswered',
                        totalQuestions.toString(),
                        Icons.quiz,
                        color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Last test: ${hasTests ? '${assessments.last.testDate.day}/${assessments.last.testDate.month}/${assessments.last.testDate.year}' : ''}",
                style:
                    AppStyles.mondaN.copyWith(color: Colors.grey, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ] else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz_outlined,
                          size: 32, color: Colors.grey.withOpacity(0.7)),
                      const SizedBox(height: 8),
                      Text(
                        'No aptitude tests taken yet',
                        style: AppStyles.mondaN.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Take tests to measure your analytical abilities',
                        style: AppStyles.mondaN
                            .copyWith(color: color, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

// Helper widget for aptitude metrics - same structure as mock interview metrics
  Widget _buildAptitudeMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppStyles.mondaB.copyWith(
            fontSize: 18,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.mondaN.copyWith(
            color: Colors.grey,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

// Mock Interview Widget (Different Design)
  Widget _buildMockInterviewCard(
    List<MockInterviewResult> results,
    Color color,
  ) {
    bool hasInterviews = results.isNotEmpty;

    // Calculate averages if there are interviews
    double avgVideoConfidence = 0;
    double avgAudioConfidence = 0;
    double avgFluency = 0;
    int totalFillerWords = 0;

    if (hasInterviews) {
      for (var result in results) {
        avgVideoConfidence += 0; //result.videoConfidence;
        avgAudioConfidence += 0; //result.audioConfidence;
        avgFluency += 0; //result.fluencyPercentage;
        totalFillerWords += 0; //result.transcription.totalFillers;
      }
      avgVideoConfidence /= results.length;
      avgAudioConfidence /= results.length;
      avgFluency /= results.length;
      totalFillerWords = (totalFillerWords / results.length).round();
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MockInterviewDetailPage(
              results: results,
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.05),
              cardBackgroundColor,
            ],
          ),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.videocam, color: color),
                    const SizedBox(width: 8),
                    Text(
                      'Mock Interview',
                      style: AppStyles.mondaB.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                if (hasInterviews)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${results.length} completed',
                      style: AppStyles.mondaN.copyWith(
                        fontSize: 12,
                        color: color,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasInterviews) ...[
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildInterviewMetric(
                        'Video\nConfidence',
                        '${avgVideoConfidence.toStringAsFixed(0)}%',
                        Icons.face,
                        color,
                      ),
                    ),
                    Expanded(
                      child: _buildInterviewMetric(
                        'Audio\nConfidence',
                        '${avgAudioConfidence.toStringAsFixed(0)}%',
                        Icons.mic,
                        color,
                      ),
                    ),
                    Expanded(
                      child: _buildInterviewMetric(
                        'Fluency\nScore',
                        '${avgFluency.toStringAsFixed(0)}%',
                        Icons.auto_graph,
                        color,
                      ),
                    ),
                    Expanded(
                      child: _buildInterviewMetric(
                        'Filler\nWords',
                        totalFillerWords.toString(),
                        Icons.text_fields,
                        color,
                        isNegative: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ] else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_camera_front_outlined,
                          size: 32, color: Colors.grey.withOpacity(0.7)),
                      const SizedBox(height: 8),
                      Text(
                        'No interviews taken yet',
                        style: AppStyles.mondaN.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Practice with mock interviews to improve your skills',
                        style: AppStyles.mondaN
                            .copyWith(color: color, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

// Helper widget for mock interview metrics
  Widget _buildInterviewMetric(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isNegative = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppStyles.mondaB.copyWith(
            fontSize: 18,
            color: isNegative ? Colors.orange : color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.mondaN.copyWith(
            color: Colors.grey,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCodingProfiles() {
    return Card(
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Coding Profiles',
                  style: AppStyles.mondaB.copyWith(fontSize: 18),
                ),
                IconButton(
                    onPressed: () async {
                      if (widget.user.leetcode != null) {
                        await Provider.of<UserProvider>(context, listen: false)
                            .fetchLeetCodeProfile(context);
                      }
                      if (widget.user.github != null) {
                        await Provider.of<UserProvider>(context, listen: false)
                            .fetchGitHubProfile(context);
                      }
                    },
                    icon: Icon(MdiIcons.refresh),
                    color: Colors.blue),
              ],
            ),
            const SizedBox(height: 16),
            (widget.user.gitHubData != null)
                ? _buildGitHubSection()
                : Text(
                    "Add your github link",
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  ),
            const Divider(color: Colors.grey, height: 32),
            (widget.user.leetCodeData != null)
                ? _buildLeetCodeSection()
                : Text(
                    "Add your leetcode link",
                    style: AppStyles.mondaB.copyWith(fontSize: 18),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildGitHubSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(MdiIcons.github, color: Colors.white),
            const SizedBox(width: 8),
            Text('GitHub Profile', style: AppStyles.mondaB),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildGitHubStat(
                MdiIcons.sourceRepository,
                widget.user.gitHubData!.repositories.toString(),
                'Repositories'),
            _buildGitHubStat(MdiIcons.starOutline,
                widget.user.gitHubData!.stars.toString(), 'Stars'),
            _buildGitHubStat(MdiIcons.accountGroup,
                widget.user.gitHubData!.followers.toString(), 'Followers'),
            _buildGitHubStat(MdiIcons.accountMultiple,
                widget.user.gitHubData!.following.toString(), 'Following'),
          ],
        ),
        const SizedBox(height: 16),
        Text('Language Distribution', style: AppStyles.mondaN),
        const SizedBox(height: 8),
        Column(
          children:
              widget.user.gitHubData!.languageDistribution.entries.map((entry) {
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(entry.key, style: AppStyles.mondaN),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: entry.value / 100,
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            getRandomColor(),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.value.toDouble().toStringAsFixed(2)}%',
                      style: AppStyles.mondaN.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLeetCodeSection() {
    int len = widget.user.leetCodeData!.ratingHistory.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(MdiIcons.codeBraces, color: Colors.orange),
                const SizedBox(width: 8),
                Text('LeetCode Stats', style: AppStyles.mondaB),
              ],
            ),
            Text(
              'Rating: ${(len > 0) ? widget.user.leetCodeData!.ratingHistory[len - 1].toInt() : 0}',
              style: AppStyles.mondaB.copyWith(
                color: Colors.orange,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRatingGraph(),
        const SizedBox(height: 16),
        _buildSubmissionStats(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLeetCodeProblemStat(
                'Easy',
                (widget.user.leetCodeData!.problemStats['Easy']).toString(),
                Colors.green),
            _buildLeetCodeProblemStat(
                'Medium',
                (widget.user.leetCodeData!.problemStats['Medium']).toString(),
                Colors.orange),
            _buildLeetCodeProblemStat(
                'Hard',
                (widget.user.leetCodeData!.problemStats['Hard']).toString(),
                Colors.red),
          ],
        ),
        const SizedBox(height: 16),
        Text('Top Languages Used', style: AppStyles.mondaN),
        const SizedBox(height: 8),
        ...widget.user.leetCodeData!.languageUsage.entries.map(
          (entry) => _buildLanguageUsageBar(
              entry.key, entry.value.toInt(), getRandomColor()),
        ),
        const SizedBox(height: 16),
        Text('Skills Breakdown', style: AppStyles.mondaN),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...widget.user.leetCodeData!.skillStats.entries.map(
              (entry) => _buildSkillChip(
                  entry.key, entry.value.toInt(), getRandomColor()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingGraph() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 200,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const count = [
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                  ];
                  if (value.toInt() >= 0 && value.toInt() < count.length) {
                    return Text(
                      count[value.toInt()],
                      style: AppStyles.mondaN.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 200,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: AppStyles.mondaN.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 11,
          minY: 1500,
          maxY: 2500,
          lineBarsData: [
            LineChartBarData(
              spots: List<FlSpot>.generate(
                widget.user.leetCodeData!.ratingHistory.length,
                (index) => FlSpot(index.toDouble(),
                    widget.user.leetCodeData!.ratingHistory[index]),
              ),
              isCurved: true,
              color: Colors.orange,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.orange.withOpacity(0.1),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Submission Statistics', style: AppStyles.mondaN),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSubmissionStat(
                  (widget.user.leetCodeData!.problemStats['All']).toString(),
                  'Submissions',
                  'Total'),
              _buildSubmissionStat(
                  widget.user.leetCodeData!.submissionStats.activeDays
                      .toString(),
                  'Active Days',
                  'Total'),
              _buildSubmissionStat(
                  widget.user.leetCodeData!.submissionStats.maxStreak
                      .toString(),
                  'Max Streak',
                  'Days'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGitHubStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 4),
        Text(value, style: AppStyles.mondaB),
        Text(
          label,
          style: AppStyles.mondaN.copyWith(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionStat(String value, String label, String subLabel) {
    return Column(
      children: [
        Text(
          value,
          style: AppStyles.mondaB.copyWith(
            fontSize: 24,
            color: Colors.orange,
          ),
        ),
        Text(
          label,
          style: AppStyles.mondaN.copyWith(fontSize: 14),
        ),
        Text(
          subLabel,
          style: AppStyles.mondaN.copyWith(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLeetCodeProblemStat(
      String difficulty, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: AppStyles.mondaB.copyWith(
            color: color,
            fontSize: 24,
          ),
        ),
        Text(
          difficulty,
          style: AppStyles.mondaN.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageUsageBar(String language, int problems, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(language, style: AppStyles.mondaN),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: problems / 400, // Normalize to max problems
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$problems',
            style: AppStyles.mondaN.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$skill ($count)',
        style: AppStyles.mondaB.copyWith(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}
