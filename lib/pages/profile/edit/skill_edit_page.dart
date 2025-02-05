import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SkillsEditPage extends StatefulWidget {
  final User user;

  const SkillsEditPage({
    super.key,
    required this.user,
  });

  @override
  State<SkillsEditPage> createState() => _SkillsEditPageState();
}

class _SkillsEditPageState extends State<SkillsEditPage> {
  final TextEditingController _skillSearchController = TextEditingController();
  final FocusNode _skillSearchFocus = FocusNode();
  List<String> _selectedSkills = [];
  bool _showSuggestions = false;

  // Moved predefined skills to a separate constant
  static const List<String> _predefinedSkills = [
    // Programming Languages
    "Java", "JavaScript", "jQuery", "JSON", "Jenkins",
    "Python", "PHP", "Ruby", "React", "React Native",
    // Frameworks
    "Django", "Docker", "Flutter", "Firebase",
    // Cloud Platforms
    "AWS", "Azure", "Google Cloud",
    // Data Science
    "Machine Learning", "Data Analysis", "Data Science", "Deep Learning",
    // Database
    "MongoDB", "MySQL", "PostgreSQL",
    // Tools
    "Git", "GitHub", "Visual Studio Code",
    // Soft Skills
    "Team Leadership", "Project Management", "Communication", "Problem Solving",
    // Mobile Development
    "Android Development", "iOS Development", "Kotlin", "Swift",
    // Web Technologies
    "HTML", "CSS", "Bootstrap", "TypeScript",
    // Testing
    "Unit Testing", "QA Testing", "Automated Testing",
    // Design
    "UI Design", "UX Design", "Figma", "Adobe XD"
  ];

  List<String> _filteredSkills = [];

  @override
  void initState() {
    super.initState();
    // Initialize selected skills from user data
    _selectedSkills = List<String>.from(widget.user.keySkills);
    _skillSearchController.addListener(_onSearchChanged);
    _skillSearchFocus.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _skillSearchFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _skillSearchController.dispose();
    _skillSearchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchText = _skillSearchController.text.toLowerCase();
    setState(() {
      _filteredSkills = searchText.isEmpty
          ? []
          : _predefinedSkills
              .where((skill) =>
                  skill.toLowerCase().contains(searchText) &&
                  !_selectedSkills.contains(skill))
              .toList();
    });
  }

  void _addSkill(String skill) {
    final trimmedSkill = skill.trim();
    if (trimmedSkill.isNotEmpty && !_selectedSkills.contains(trimmedSkill)) {
      setState(() {
        _selectedSkills.add(trimmedSkill);
        _skillSearchController.clear();
        _showSuggestions = false;
        _filteredSkills.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  Widget _buildSkillSuggestions() {
    if (!_showSuggestions || _filteredSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredSkills.length,
        itemBuilder: (context, index) {
          final skill = _filteredSkills[index];
          return ListTile(
            dense: true,
            title: Text(
              skill,
              style: AppStyles.mondaN.copyWith(color: Colors.white),
            ),
            onTap: () {
              _addSkill(skill);
              FocusScope.of(context).unfocus();
            },
            hoverColor: Colors.white.withOpacity(0.1),
          );
        },
      ),
    );
  }

  Widget _buildSelectedSkills() {
    if (_selectedSkills.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Selected Skills',
          style: AppStyles.mondaM.copyWith(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedSkills.map((skill) {
            return Chip(
              label: Text(
                skill,
                style: AppStyles.mondaN.copyWith(color: customBlue),
              ),
              backgroundColor: backgroundColor,
              deleteIcon: const Icon(
                Icons.close,
                size: 18,
                color: customBlue,
              ),
              onDeleted: () => _removeSkill(skill),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {"keySkills": _selectedSkills};

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
      title: "Skills",
      onSave: _saveChanges,
      children: [
        SingleChildScrollView(
          // Wrap with SingleChildScrollView
          padding: const EdgeInsets.all(16),
          child: Column(
            // Replace ListView with Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Skills',
                style: AppStyles.mondaB.copyWith(
                  fontSize: 18,
                  color: customBlue,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: TextField(
                  controller: _skillSearchController,
                  focusNode: _skillSearchFocus,
                  style: AppStyles.mondaN.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search or add new skill...',
                    hintStyle: AppStyles.mondaN.copyWith(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white38),
                    suffixIcon: _skillSearchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.add, color: customBlue),
                            onPressed: () =>
                                _addSkill(_skillSearchController.text),
                            tooltip: 'Add as new skill',
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: _addSkill,
                ),
              ),
              _buildSkillSuggestions(),
              _buildSelectedSkills(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
