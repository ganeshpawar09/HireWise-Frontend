import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SocialLinksEditPage extends StatefulWidget {
  final User user;

  const SocialLinksEditPage({super.key, required this.user});

  @override
  State<SocialLinksEditPage> createState() => _SocialLinksEditPageState();
}

class _SocialLinksEditPageState extends State<SocialLinksEditPage> {
  late TextEditingController linkedinController;
  late TextEditingController githubController;
  late TextEditingController leetcodeController;
  late TextEditingController portfolioController;

  @override
  void initState() {
    super.initState();
    linkedinController = TextEditingController(text: widget.user.linkedin);
    githubController = TextEditingController(text: widget.user.github);
    leetcodeController = TextEditingController(text: widget.user.leetcode);
    portfolioController = TextEditingController(text: widget.user.portfolio);
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {
      'linkedin': linkedinController.text.trim(),
      'github': githubController.text.trim(),
      'leetcode': leetcodeController.text.trim(),
      'portfolio': portfolioController.text.trim(),
    };

    try {
      await userProvider.updateUserProfile(context,updatedUserData);
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseEditPage(
      title: 'Social Links',
      onSave: _saveChanges,
      children: [
        _buildSocialLinkField(
          controller: linkedinController,
          icon: MdiIcons.linkedin,
          label: 'LinkedIn Profile',
          hint: 'https://linkedin.com/in/username',
          color: const Color(0xFF0077B5),
        ),
        _buildSocialLinkField(
          controller: githubController,
          icon: MdiIcons.github,
          label: 'GitHub Profile',
          hint: 'username',
          color: const Color(0xFF333333),
        ),
        _buildSocialLinkField(
          controller: leetcodeController,
          icon: Icons.code,
          label: 'Leetcode Profile',
          hint: 'username',
          color: const Color(0xFF1DA1F2),
        ),
        _buildSocialLinkField(
          controller: portfolioController,
          icon: MdiIcons.web,
          label: 'Portfolio Website',
          hint: 'https://yourportfolio.com',
          color: const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  Widget _buildSocialLinkField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: AppStyles.mondaN.copyWith(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: AppStyles.mondaN.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppStyles.mondaN
                  .copyWith(color: Colors.grey.withOpacity(0.5)),
              filled: true,
              fillColor: cardBackgroundColor,
              prefixIcon: Icon(MdiIcons.link, color: color.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle,
              color: Colors.green.withOpacity(0.7), size: 16),
          const SizedBox(width: 8),
          Text(text, style: AppStyles.mondaN.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}
