import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:hirewise/widget/customBottomNavigator.dart';
import 'package:provider/provider.dart';

class SelectSkillsPage extends StatefulWidget {
  const SelectSkillsPage({super.key});

  @override
  State<SelectSkillsPage> createState() => _SelectSkillsPageState();
}

class _SelectSkillsPageState extends State<SelectSkillsPage> {
  final List<String> _availableSkills = [
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
    "Flutter",
    "Dart",
    "Swift",
    "Kotlin",
    "React Native",
    "Android",
    "iOS",
    "Objective-C",
    "Xcode",
    "Java",
    "Node.js",
    "Express",
    "MongoDB",
    "Python",
    "PostgreSQL",
    "FastAPI",
    "Java",
    "Spring Boot",
    "MySQL",
    "Redis",
    "Kafka",
    "Docker",
    "Kubernetes",
    "AWS",
    "TensorFlow",
    "PyTorch",
    "Machine Learning",
    "Deep Learning",
    "NLP",
    "Scikit-learn",
    "Pandas",
    "Keras",
    "Matplotlib",
    "OpenCV"
  ];

  final Set<String> _selectedSkills = {};
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadExistingSkills();
  }

  void _loadExistingSkills() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      setState(() {
        _selectedSkills.addAll(user.keySkills);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_selectedSkills.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 5 skills')),
      );
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Update user profile with selected skills
      await userProvider.updateUserProfile(
        context,
        {'keySkills': _selectedSkills.toList()},
      );

      if (!mounted) return;

      // Navigate to main app
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const CustomBottomNavigator()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update skills: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Your Skills',
          style: AppStyles.mondaB.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section with selected count
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select at least 5 skills',
                    style: AppStyles.mondaN.copyWith(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selected: ${_selectedSkills.length}/5',
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 16,
                      color: _selectedSkills.length >= 5
                          ? customBlue
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable skills section
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _availableSkills.map((skill) {
                      final isSelected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          });
                        },
                        backgroundColor: cardBackgroundColor,
                        selectedColor: customBlue,
                        checkmarkColor: Colors.white,
                        labelStyle: AppStyles.mondaN.copyWith(
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Bottom button section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUpdating || _selectedSkills.length < 5
                      ? null
                      : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: customBlue.withOpacity(0.3),
                  ),
                  child: _isUpdating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
