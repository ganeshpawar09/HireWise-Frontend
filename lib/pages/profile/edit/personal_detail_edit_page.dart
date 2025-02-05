import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class PersonalDetailEditPage extends StatefulWidget {
  final User user;

  const PersonalDetailEditPage({super.key, required this.user});

  @override
  State<PersonalDetailEditPage> createState() => _PersonalDetailEditPageState();
}

class _PersonalDetailEditPageState extends State<PersonalDetailEditPage> {
  late TextEditingController nameController;
  late TextEditingController headlineController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;
  late bool isDifferentlyAbled;
  late bool hasCareerBreak;

  @override
  void initState() {
    super.initState();
    headlineController =
        TextEditingController(text: widget.user.profileHeadline);
    genderController = TextEditingController(text: widget.user.gender);
    dateOfBirthController =
        TextEditingController(text: widget.user.dateOfBirth);
    isDifferentlyAbled = widget.user.differentlyAbled ?? false;
    hasCareerBreak = widget.user.careerBreak ?? false;
  }

  @override
  void dispose() {
    headlineController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {
      'gender': genderController.text.trim(),
      'dateOfBirth': dateOfBirthController.text.trim(),
      'differentlyAbled': isDifferentlyAbled,
      'careerBreak': hasCareerBreak,
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
      title: 'Personal Detail',
      onSave: _saveChanges,
      children: [
        _buildPersonalDetailsEdit(),
      ],
    );
  }

  Widget _buildPersonalDetailsEdit() {
    return Card(
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Personal Details', style: AppStyles.mondaB),
            const SizedBox(height: 16),
            StyledTextField(
              label: 'Gender',
              controller: genderController,
            ),
            StyledTextField(
              label: 'Date of Birth',
              controller: dateOfBirthController,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                'Differently Abled',
                style: AppStyles.mondaN.copyWith(color: Colors.white),
              ),
              value: isDifferentlyAbled,
              onChanged: (value) {
                setState(() {
                  isDifferentlyAbled = value;
                });
              },
              activeColor: customBlue,
            ),
            SwitchListTile(
              title: Text(
                'Career Break',
                style: AppStyles.mondaN.copyWith(color: Colors.white),
              ),
              value: hasCareerBreak,
              onChanged: (value) {
                setState(() {
                  hasCareerBreak = value;
                });
              },
              activeColor: customBlue,
            ),
          ],
        ),
      ),
    );
  }
}
