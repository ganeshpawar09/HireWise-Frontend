import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';

// Data models for better structure
class RoadmapModel {
  final String role;
  final String description;
  final List<PhaseModel> phases;

  RoadmapModel({
    required this.role,
    required this.description,
    required this.phases,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    return RoadmapModel(
      role: json['role'] as String,
      description: json['description'] as String,
      phases: (json['phases'] as List)
          .map((phase) => PhaseModel.fromJson(phase))
          .toList(),
    );
  }
}

class PhaseModel {
  final String name;
  final String timeline;
  final List<TaskModel> tasks;
  bool isExpanded;

  PhaseModel({
    required this.name,
    required this.timeline,
    required this.tasks,
    this.isExpanded = false,
  });

  factory PhaseModel.fromJson(Map<String, dynamic> json) {
    return PhaseModel(
      name: json['phase'] as String,
      timeline: json['timeline'] as String,
      tasks: (json['tasks'] as List)
          .map((task) => TaskModel.fromJson(task))
          .toList(),
    );
  }
}

class TaskModel {
  final String name;
  final List<String> subtasks;
  final List<String> resources;
  bool isExpanded;

  TaskModel({
    required this.name,
    required this.subtasks,
    required this.resources,
    this.isExpanded = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      name: json['task'] as String,
      subtasks: (json['subtasks'] as List).map((e) => e as String).toList(),
      resources: (json['resources'] as List).map((e) => e as String).toList(),
    );
  }
}

class RoadmapDetailPage extends StatefulWidget {
  final Map<String, dynamic> roadmapData;

  const RoadmapDetailPage({
    super.key,
    required this.roadmapData,
  });

  @override
  State<RoadmapDetailPage> createState() => _RoadmapDetailPageState();
}

class _RoadmapDetailPageState extends State<RoadmapDetailPage> {
  late RoadmapModel roadmap;

  @override
  void initState() {
    super.initState();
    roadmap = RoadmapModel.fromJson(widget.roadmapData);

    // Expand first phase by default
    if (roadmap.phases.isNotEmpty) {
      roadmap.phases[0].isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: darkBackground,
      elevation: 0,
      title: Text(
        roadmap.role,
        style: AppStyles.mondaB.copyWith(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeaderCard(),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: roadmap.phases.length,
            itemBuilder: (context, index) {
              final phase = roadmap.phases[index];
              final phaseColor = _getPhaseColor(index);
              return _buildPhaseCard(phase, phaseColor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentPurple.withOpacity(0.15),
            accentBlue.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accentPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    "${roadmap.phases.length} Phases",
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 15,
                      color: accentPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Career Roadmap",
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 28,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  roadmap.description,
                  style: AppStyles.mondaN.copyWith(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: accentPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accentPurple.withOpacity(0.3),
              ),
            ),
            child: Icon(
              _getRoleIcon(roadmap.role),
              color: accentPurple,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(PhaseModel phase, Color phaseColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Phase header (always visible)
          InkWell(
            onTap: () {
              setState(() {
                phase.isExpanded = !phase.isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: phaseColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getPhaseIcon(phase.name),
                      color: phaseColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phase.name,
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Timeline: ${phase.timeline}",
                          style: AppStyles.mondaN.copyWith(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: phase.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tasks list (visible only when expanded)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: phase.isExpanded
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: phase.tasks.length,
                    itemBuilder: (context, index) {
                      final task = phase.tasks[index];
                      return _buildTaskItem(task, index, phaseColor);
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskModel task, int index, Color phaseColor) {
    return Column(
      children: [
        // Task header with toggle capability
        InkWell(
          onTap: () {
            setState(() {
              task.isExpanded = !task.isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: phaseColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 14,
                      color: phaseColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    task.name,
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: task.isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Subtasks and resources (visible only when expanded)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: task.isExpanded
              ? Container(
                  margin:
                      const EdgeInsets.only(left: 50, right: 20, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtasks section
                      _buildSubtasksSection(task.subtasks, phaseColor),

                      // Resources section
                      if (task.resources.isNotEmpty)
                        _buildResourcesSection(task.resources, phaseColor),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSubtasksSection(List<String> subtasks, Color phaseColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subtasks:",
            style: AppStyles.mondaB.copyWith(
              fontSize: 14,
              color: phaseColor,
            ),
          ),
          const SizedBox(height: 8),
          ...subtasks.map((subtask) => _buildListItem(
                subtask,
                Icons.check_circle_outline,
                phaseColor,
              )),
        ],
      ),
    );
  }

  Widget _buildResourcesSection(List<String> resources, Color phaseColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resources:",
            style: AppStyles.mondaB.copyWith(
              fontSize: 14,
              color: phaseColor,
            ),
          ),
          const SizedBox(height: 8),
          ...resources.map((resource) => _buildListItem(
                resource,
                Icons.link,
                phaseColor,
              )),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: color.withOpacity(0.8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyles.mondaN.copyWith(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get color based on phase index
  Color _getPhaseColor(int index) {
    final colors = [
      accentPurple,
      accentBlue,
      accentOrange,
      accentPink,
      accentGreen,
      accentMint,
      accentViolet,
    ];
    return colors[index % colors.length];
  }

  // Helper method to get icon based on phase name
  IconData _getPhaseIcon(String phase) {
    if (phase.contains("Foundation")) return Icons.foundation_outlined;
    if (phase.contains("Basics")) return Icons.school_outlined;
    if (phase.contains("Deep Learning")) return Icons.psychology_outlined;
    if (phase.contains("Dart")) return Icons.code_outlined;
    if (phase.contains("Advanced")) return Icons.rocket_launch_outlined;
    return Icons.lightbulb_outline;
  }

  // Helper method to get icon based on role
  IconData _getRoleIcon(String role) {
    if (role.contains("AI") || role.contains("ML"))
      return Icons.biotech_outlined;
    if (role.contains("Flutter")) return Icons.flutter_dash_outlined;
    if (role.contains("Web")) return Icons.web_outlined;
    if (role.contains("Mobile")) return Icons.phone_android_outlined;
    if (role.contains("Backend")) return Icons.storage_outlined;
    return Icons.work_outline;
  }
}
