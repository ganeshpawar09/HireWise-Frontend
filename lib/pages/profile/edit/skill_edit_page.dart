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
  String _currentCategory = 'All';

  // Skill categories
  static const Map<String, List<String>> _skillCategories = {
    'Problem-Solving Skills': [
      "Critical thinking",
      "Analytical skills",
      "Decision-making",
      "Creativity and innovation",
      "Logical reasoning",
      "Research and information gathering",
      "Troubleshooting",
      "Adaptability",
      "Resilience",
      "Problem decomposition",
    ],
    'Teamwork Skills': [
      "Communication (verbal & written)",
      "Collaboration",
      "Active listening",
      "Conflict resolution",
      "Empathy",
      "Reliability and responsibility",
      "Negotiation",
      "Interpersonal skills",
      "Accountability",
      "Trust-building",
    ],
    'Leadership Skills': [
      "Strategic thinking",
      "Vision and goal setting",
      "Motivation and inspiration",
      "Delegation",
      "Emotional intelligence",
      "Coaching and mentoring",
      "Accountability",
      "Time management",
      "Decision-making under pressure",
      "Adaptability in leadership",
    ],
    'Personal Development Skills': [
      "Self-motivation",
      "Growth mindset",
      "Time management",
      "Stress management",
      "Work-life balance",
      "Self-awareness",
      "Continuous learning",
      "Networking",
    ],
    'Frontend': [
      "React",
      "Vue.js",
      "Next.js",
      "JavaScript",
      "TypeScript",
      "Redux",
      "CSS",
      "Sass",
      "Tailwind CSS",
      "GraphQL",
      "Webpack",
    ],
    'Mobile': [
      "Flutter",
      "Dart",
      "Swift",
      "Kotlin",
      "React Native",
      "Android",
      "iOS",
      "Objective-C",
      "Xcode",
    ],
    'Backend': [
      "Java",
      "Node.js",
      "Express",
      "MongoDB",
      "Python",
      "PostgreSQL",
      "FastAPI",
      "Spring Boot",
      "MySQL",
      "Redis",
      "Kafka",
    ],
    'DevOps': [
      "Docker",
      "Kubernetes",
      "AWS",
      "CI/CD",
      "Jenkins",
      "Terraform",
      "GitLab",
      "GitHub Actions",
    ],
    'AI/ML': [
      "TensorFlow",
      "PyTorch",
      "Machine Learning",
      "Deep Learning",
      "NLP",
      "Scikit-learn",
      "Pandas",
      "Keras",
      "Matplotlib",
      "OpenCV",
    ],
  };

  // Compute all skills for search
  List<String> get _allSkills {
    final allSkills = <String>[];
    _skillCategories.forEach((_, skills) => allSkills.addAll(skills));
    return allSkills;
  }

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
          : _allSkills
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

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip('All'),
          ..._skillCategories.keys.map(_buildCategoryChip),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _currentCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _currentCategory = category;
          });
        },
        backgroundColor: cardBackgroundColor,
        selectedColor: customBlue,
        checkmarkColor: Colors.white,
        labelStyle: AppStyles.mondaN.copyWith(
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildSkillCategorySection(String category, List<String> skills) {
    // Filter skills that are not already selected
    final availableSkills =
        skills.where((s) => !_selectedSkills.contains(s)).toList();

    if (availableSkills.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: AppStyles.mondaB.copyWith(
            fontSize: 16,
            color: customBlue,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableSkills.map((skill) {
            return FilterChip(
              label: Text(skill),
              selected: false,
              onSelected: (_) {
                _addSkill(skill);
              },
              backgroundColor: cardBackgroundColor,
              labelStyle: AppStyles.mondaN.copyWith(
                color: Colors.white70,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSelectedSkills() {
    if (_selectedSkills.isEmpty) return const SizedBox.shrink();

    // Group selected skills by category
    final Map<String, List<String>> categorizedSelectedSkills = {};

    for (final skill in _selectedSkills) {
      String foundCategory = 'Other';

      for (final entry in _skillCategories.entries) {
        if (entry.value.contains(skill)) {
          foundCategory = entry.key;
          break;
        }
      }

      categorizedSelectedSkills.putIfAbsent(foundCategory, () => []);
      categorizedSelectedSkills[foundCategory]!.add(skill);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Your Skills',
          style: AppStyles.mondaB.copyWith(
            fontSize: 18,
            color: customBlue,
          ),
        ),
        const SizedBox(height: 8),
        ...categorizedSelectedSkills.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: AppStyles.mondaM.copyWith(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.value.map((skill) {
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
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAvailableSkills() {
    if (_currentCategory == 'All') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _skillCategories.entries.map((entry) {
          return _buildSkillCategorySection(entry.key, entry.value);
        }).toList(),
      );
    } else {
      final skills = _skillCategories[_currentCategory] ?? [];
      return _buildSkillCategorySection(_currentCategory, skills);
    }
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {"keySkills": _selectedSkills};

    try {
      await userProvider.updateUserProfile(context, updatedUserData);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      if (!mounted) return;
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
          padding: const EdgeInsets.all(16),
          child: Column(
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
              const SizedBox(height: 16),
              _buildCategorySelector(),
              const SizedBox(height: 16),
              _buildSelectedSkills(),
              const SizedBox(height: 16),
              _buildAvailableSkills(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
