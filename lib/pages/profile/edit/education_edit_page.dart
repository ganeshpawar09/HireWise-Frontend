import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class EducationEditPage extends StatefulWidget {
  final User user;

  const EducationEditPage({super.key, required this.user});

  @override
  State<EducationEditPage> createState() => _EducationEditPageState();
}

class _EducationEditPageState extends State<EducationEditPage> {
  late List<Map<String, TextEditingController>> _controllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each education entry
    _controllers = widget.user.education
        .map((edu) => {
              'degree': TextEditingController(text: edu.degree),
              'institution': TextEditingController(text: edu.institution),
              'startYear': TextEditingController(text: edu.startYear),
              'endYear': TextEditingController(text: edu.endYear),
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

    // Convert controllers' values back to Education objects
    final List<Education> updatedEducation = _controllers
        .map((controllers) => Education(
              degree: controllers['degree']!.text,
              institution: controllers['institution']!.text,
              startYear: controllers['startYear']!.text,
              endYear: controllers['endYear']!.text,
            ))
        .toList();

    try {
      await userProvider.updateUserProfile(context,{'education': updatedEducation});
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
      title: 'Education',
      onSave: _saveChanges,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _controllers.length,
          itemBuilder: (context, index) => _buildEducationItem(index),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addNewEducation,
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
              Text('Add Education',
                  style: AppStyles.mondaB.copyWith(color: customBlue)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEducationItem(int index) {
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
                Text('Education ${index + 1}', style: AppStyles.mondaB),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeEducation(index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StyledTextField(
              label: 'Degree',
              controller: controllers['degree']!,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Institution',
              controller: controllers['institution']!,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StyledTextField(
                    label: 'Start Year',
                    controller: controllers['startYear']!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StyledTextField(
                    label: 'End Year',
                    controller: controllers['endYear']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addNewEducation() {
    setState(() {
      _controllers.add({
        'degree': TextEditingController(),
        'institution': TextEditingController(),
        'startYear': TextEditingController(),
        'endYear': TextEditingController(),
      });
    });
  }

  void _removeEducation(int index) {
    setState(() {
      // Dispose controllers for the removed education
      _controllers[index].values.forEach((controller) => controller.dispose());
      _controllers.removeAt(index);
    });
  }
}
