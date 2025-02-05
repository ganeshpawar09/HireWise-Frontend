import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ExperienceEditPage extends StatefulWidget {
  final User user;
  const ExperienceEditPage({super.key, required this.user});

  @override
  State<ExperienceEditPage> createState() => _ExperienceEditPageState();
}

class _ExperienceEditPageState extends State<ExperienceEditPage> {
  late List<Map<String, TextEditingController>> _controllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each experience entry
    _controllers = widget.user.experience
        .map((exp) => {
              'companyName': TextEditingController(text: exp.companyName),
              'jobTitle': TextEditingController(text: exp.jobTitle),
              'startDate': TextEditingController(text: exp.startDate),
              'endDate': TextEditingController(text: exp.endDate),
            })
        .toList();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controllerMap in _controllers) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Convert controllers' values back to Experience objects
    final List<Experience> updatedExperience = _controllers
        .map((controllers) => Experience(
              companyName: controllers['companyName']!.text,
              jobTitle: controllers['jobTitle']!.text,
              startDate: controllers['startDate']!.text,
              endDate: controllers['endDate']!.text,
            ))
        .toList();

    try {
      await userProvider.updateUserProfile(context,{'experience': updatedExperience});
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseEditPage(
      title: 'Experience',
      onSave: _saveChanges,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _controllers.length,
          itemBuilder: (context, index) => _buildExperienceItem(index),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addNewExperience,
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
              const Icon(Icons.add, color: customBlue),
              const SizedBox(width: 8),
              Text('Add Experience',
                  style: AppStyles.mondaB.copyWith(color: customBlue)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceItem(int index) {
    final controllers = _controllers[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Experience ${index + 1}', style: AppStyles.mondaB),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeExperience(index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StyledTextField(
              label: 'Company Name',
              controller: controllers['companyName']!,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Job Title',
              controller: controllers['jobTitle']!,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StyledTextField(
                    label: 'Start Date',
                    controller: controllers['startDate']!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StyledTextField(
                    label: 'End Date',
                    controller: controllers['endDate']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addNewExperience() {
    setState(() {
      _controllers.add({
        'companyName': TextEditingController(),
        'jobTitle': TextEditingController(),
        'startDate': TextEditingController(),
        'endDate': TextEditingController(),
      });
    });
  }

  void _removeExperience(int index) {
    setState(() {
      // Dispose controllers for the removed experience
      _controllers[index].values.forEach((controller) => controller.dispose());
      _controllers.removeAt(index);
    });
  }
}
