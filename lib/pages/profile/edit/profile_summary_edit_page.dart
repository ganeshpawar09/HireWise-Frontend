import 'package:flutter/material.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileSummaryEditPage extends StatefulWidget {
  final User user;

  const ProfileSummaryEditPage({super.key, required this.user});

  @override
  State<ProfileSummaryEditPage> createState() => _ProfileSummaryEditPageState();
}

class _ProfileSummaryEditPageState extends State<ProfileSummaryEditPage> {
  late TextEditingController summaryController;

  @override
  void initState() {
    super.initState();
    summaryController = TextEditingController(text: widget.user.profileSummary);
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {
      'profileSummary': summaryController.text.trim(),
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
      title: 'Edit Profile Summary',
      onSave: _saveChanges,
      children: [
        StyledTextField(
          label: 'Profile Summary',
          controller: summaryController,
          maxLines: 5,
          hint: 'Write a brief summary about yourself...',
        ),
      ],
    );
  }
}
