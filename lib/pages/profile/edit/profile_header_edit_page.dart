import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeaderEditPage extends StatefulWidget {
  final User user;

  const ProfileHeaderEditPage({super.key, required this.user});

  @override
  State<ProfileHeaderEditPage> createState() => _ProfileHeaderEditPageState();
}

class _ProfileHeaderEditPageState extends State<ProfileHeaderEditPage> {
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController headlineController;

  @override
  void initState() {
    super.initState();
    // Split the full name into components
    firstNameController = TextEditingController(
      text: widget.user.firstName,
    );
    middleNameController = TextEditingController(
      text: widget.user.middleName,
    );
    lastNameController = TextEditingController(
      text: widget.user.lastName,
    );
    headlineController =
        TextEditingController(text: widget.user.profileHeadline);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    headlineController.dispose();
    super.dispose();
  }

  String _buildFullName() {
    final firstName = firstNameController.text.trim();
    final middleName = middleNameController.text.trim();
    final lastName = lastNameController.text.trim();

    return [firstName, middleName, lastName]
        .where((name) => name.isNotEmpty)
        .join(' ');
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {
      'name': _buildFullName(),
      'firstName': firstNameController.text.trim(),
      'middleName': middleNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'profileHeadline': headlineController.text.trim(),
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
      title: 'Edit Profile',
      onSave: _saveChanges,
      children: [
        _buildProfileHeaderEdit(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProfileHeaderEdit() {
    return Card(
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile Header', style: AppStyles.mondaB),
            const SizedBox(height: 16),
            Center(
              child: Stack(
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
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // TODO: Implement image picker
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            StyledTextField(
              label: 'First Name',
              controller: firstNameController,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Middle Name (Optional)',
              controller: middleNameController,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Last Name',
              controller: lastNameController,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Profile Headline',
              controller: headlineController,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
