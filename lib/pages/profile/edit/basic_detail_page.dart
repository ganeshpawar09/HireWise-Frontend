import 'package:flutter/material.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class BasicDetailsEditPage extends StatefulWidget {
  final User user;

  const BasicDetailsEditPage({super.key, required this.user});

  @override
  State<BasicDetailsEditPage> createState() => _BasicDetailsEditPageState();
}

class _BasicDetailsEditPageState extends State<BasicDetailsEditPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late bool isFresher;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    locationController = TextEditingController(text: widget.user.location);
    isFresher = widget.user.fresher ?? false;
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUserData = {
      'email': emailController.text.trim(),
      'phoneNumber': phoneController.text.trim(),
      'location': locationController.text.trim(),
      'fresher': isFresher,
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
      title: 'Basic Details',
      onSave: _saveChanges,
      children: [
        StyledTextField(
          label: 'Email',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        StyledTextField(
          label: 'Phone',
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        StyledTextField(
          label: 'Location',
          controller: locationController,
        ),
        SwitchListTile(
          title: Text('Fresher', style: AppStyles.mondaN),
          value: isFresher,
          onChanged: (value) => setState(() => isFresher = value),
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}

// Education Edit Page
