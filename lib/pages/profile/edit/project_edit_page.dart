import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/pages/profile/widget/edit_widget_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProjectsEditPage extends StatefulWidget {
  final User user;
  const ProjectsEditPage({super.key, required this.user});

  @override
  State<ProjectsEditPage> createState() => _ProjectsEditPageState();
}

class _ProjectsEditPageState extends State<ProjectsEditPage> {
  late List<Map<String, TextEditingController>> _controllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each project
    _controllers = widget.user.projects
        .map((project) => {
              'title': TextEditingController(text: project.title),
              'description': TextEditingController(text: project.description),
              'technologyUsed':
                  TextEditingController(text: project.technologyUsed),
              'projectLink': TextEditingController(text: project.projectLink),
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

    // Convert controllers' values back to Project objects
    final List<Project> updatedProjects = _controllers
        .map((controllers) => Project(
              title: controllers['title']!.text,
              description: controllers['description']!.text,
              technologyUsed: controllers['technologyUsed']!.text,
              projectLink: controllers['projectLink']!.text,
            ))
        .toList();

    try {
      await userProvider.updateUserProfile(context,{'projects': updatedProjects});
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
      title: 'Projects',
      onSave: _saveChanges,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _controllers.length,
          itemBuilder: (context, index) => _buildProjectItem(index),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addNewProject,
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
              Text('Add Project',
                  style: AppStyles.mondaB.copyWith(color: customBlue)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectItem(int index) {
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
                Text('Project ${index + 1}', style: AppStyles.mondaB),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeProject(index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StyledTextField(
              label: 'Title',
              controller: controllers['title']!,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Description',
              controller: controllers['description']!,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Technologies Used',
              controller: controllers['technologyUsed']!,
            ),
            const SizedBox(height: 12),
            StyledTextField(
              label: 'Project Link',
              controller: controllers['projectLink']!,
            ),
          ],
        ),
      ),
    );
  }

  void _addNewProject() {
    setState(() {
      _controllers.add({
        'title': TextEditingController(),
        'description': TextEditingController(),
        'technologyUsed': TextEditingController(),
        'projectLink': TextEditingController(),
      });
    });
  }

  void _removeProject(int index) {
    setState(() {
      // Dispose controllers for the removed project
      _controllers[index].values.forEach((controller) => controller.dispose());
      _controllers.removeAt(index);
    });
  }
}
