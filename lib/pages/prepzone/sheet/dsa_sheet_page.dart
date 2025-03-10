import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class DSASheetPage extends StatefulWidget {
  const DSASheetPage({super.key});

  @override
  State<DSASheetPage> createState() => _DSASheetPageState();
}

class _DSASheetPageState extends State<DSASheetPage> {
  // Add an expanded state map to track which topic is expanded
  Map<String, bool> expandedTopics = {};

  // DSA problems data structure
  final Map<String, Map<String, String>> dsaProblems = sheet;
  @override
  void initState() {
    super.initState();
    // Initialize all topics as collapsed
    for (String topic in dsaProblems.keys) {
      expandedTopics[topic] = false;
    }
    // Expand the first topic by default
    if (dsaProblems.keys.isNotEmpty) {
      expandedTopics[dsaProblems.keys.first] = true;
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
        "DSA Sheet",
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
            itemCount: dsaProblems.length,
            itemBuilder: (context, index) {
              final topic = dsaProblems.keys.elementAt(index);
              final problems = dsaProblems[topic]!;
              final topicColor = _getTopicColor(index);

              return _buildTopicCard(topic, problems, topicColor);
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
                    "150 Curated Problems",
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 15,
                      color: accentPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "DSA Interview Prep",
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 28,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Categorized LeetCode problems to ace your technical interviews",
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
            child: const Icon(
              Icons.code,
              color: accentPurple,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
      String topic, Map<String, String> problems, Color topicColor) {
    final isExpanded = expandedTopics[topic] ?? false;

    return Container(
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
          // Topic header (always visible)
          InkWell(
            onTap: () {
              setState(() {
                expandedTopics[topic] = !isExpanded;
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
                      color: topicColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getTopicIcon(topic),
                      color: topicColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic,
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${problems.length} problems",
                          style: AppStyles.mondaN.copyWith(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Problems list (visible only when expanded)
          if (isExpanded)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: problems.length,
              itemBuilder: (context, index) {
                final problem = problems.keys.elementAt(index);
                final url = problems[problem]!;
                return _buildProblemItem(problem, url, index, topicColor);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProblemItem(
      String problem, String url, int index, Color topicColor) {
    return InkWell(
      onTap: () => _launchUrl(url),
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
                color: topicColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${index + 1}",
                style: AppStyles.mondaB.copyWith(
                  fontSize: 14,
                  color: topicColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                problem,
                style: AppStyles.mondaB.copyWith(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.open_in_new,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
              onPressed: () => _launchUrl(url),
            ),
            IconButton(
              icon: Icon(
                Icons.content_copy,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
              onPressed: () => _copyToClipboard(url),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL copied to clipboard'),
        backgroundColor: accentGreen,
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Helper method to get color based on topic index
  Color _getTopicColor(int index) {
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

  // Helper method to get icon based on topic name
  // Helper method to get icon based on topic name
  IconData _getTopicIcon(String topic) {
    switch (topic) {
      case "Arrays & Hashing":
        return Icons.grid_on_outlined;
      case "Two Pointers":
        return Icons.compare_arrows_outlined;
      case "Sliding Window":
        return Icons.filter_center_focus;
      case "Stack":
        return Icons.layers_outlined;
      case "Binary Search":
        return Icons.search_outlined;
      case "Linked List":
        return Icons.link_outlined;
      case "Trees":
        return Icons.account_tree_outlined;
      case "Dynamic Programming":
        return Icons.table_chart_outlined;
      case "Graphs":
        return Icons.hub_outlined;
      case "Advanced Graphs":
        return Icons.share_outlined;
      case "Backtracking":
        return Icons.undo_outlined;
      case "Greedy":
        return Icons.bolt_outlined;
      case "Bit Manipulation":
        return Icons.memory_outlined;
      case "Math & Geometry":
        return Icons.square_foot_outlined;
      case "Intervals":
        return Icons.linear_scale_outlined;
      case "Tries":
        return Icons.text_fields_outlined;
      case "Heap / Priority Queue":
        return Icons.leaderboard_outlined;
      case "Miscellaneous":
        return Icons.lightbulb_outline;
      default:
        return Icons.code_outlined;
    }
  }
}
