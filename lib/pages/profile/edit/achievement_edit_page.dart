import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class AchievementsEditPage extends StatefulWidget {
  final User user;
  const AchievementsEditPage({super.key, required this.user});

  @override
  State<AchievementsEditPage> createState() => _AchievementsEditPageState();
}

class _AchievementsEditPageState extends State<AchievementsEditPage> {
  late List<String> achievements;

  @override
  void initState() {
    super.initState();
    achievements = List.from(widget.user.achievements);
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {'achievements': achievements};

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
      title: 'Achievements',
      onSave: _saveChanges,
      children: [
        ...achievements
            .asMap()
            .entries
            .map((entry) => _buildAchievementItem(entry.value, entry.key))
            .toList(),
        ElevatedButton(
          onPressed: _addNewAchievement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: customBlue),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add,
                color: customBlue,
              ),
              const SizedBox(width: 8),
              Text('Add Achievement',
                  style: AppStyles.mondaB.copyWith(color: customBlue)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(String achievement, int index) {
    final controller = TextEditingController(text: achievement);
    controller.addListener(() {
      achievements[index] = controller.text;
    });

    return Card(
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Achievement', style: AppStyles.mondaB),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeAchievement(index),
                ),
              ],
            ),
            StyledTextField(
              label: 'Description',
              controller: controller,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _addNewAchievement() {
    setState(() {
      achievements.add('');
    });
  }

  void _removeAchievement(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackgroundColor,
        title: Text('Delete Achievement', style: AppStyles.mondaB),
        content: Text('Are you sure you want to delete this achievement?',
            style: AppStyles.mondaN),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppStyles.mondaN),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                achievements.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete',
                style: AppStyles.mondaN.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
