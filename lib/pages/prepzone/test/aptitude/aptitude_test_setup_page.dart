import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/prepzone/test/aptitude/aptitude_test_page.dart';
import 'package:hirewise/pages/prepzone/test/widget/test_style.dart';
import 'package:hirewise/provider/topic_provider.dart';
import 'package:provider/provider.dart';

class AptitudeSetUpPage extends StatefulWidget {
  const AptitudeSetUpPage({super.key});

  @override
  State<AptitudeSetUpPage> createState() => _AptitudeSetUpPageState();
}

class _AptitudeSetUpPageState extends State<AptitudeSetUpPage> {
  String? selectedTopic;
  Map<String, List<String>> selectedSubtopicsMap = {};
  int numberOfQuestions = 10;
  int timePerQuestion = 60;

  @override
  void initState() {
    super.initState();
    _initialFetch();
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => fetchTopics(),
        ),
      ),
    );
  }

  Future<void> _initialFetch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    try {
      await fetchTopics();
    } catch (e) {
      if (!mounted) return;
      _showError("Failed to load initial data");
    }
  }

  Future<void> fetchTopics() async {
    final topicProvider = Provider.of<TopicProvider>(context, listen: false);

    try {
      await topicProvider.fetchTopicsStructure(context);
    } catch (e) {
      _showError("Something went wrong while fetching applied jobs");
    }
  }

  Future<void> _loadTopics() async {
    await fetchTopics();
  }

  List<String> getSelectedSubtopics(String topic) =>
      selectedSubtopicsMap[topic] ?? [];

  Future<void> _submitSelection() async {
    if (selectedTopic == null || getSelectedSubtopics(selectedTopic!).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one topic and subtopic'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    print(selectedTopic);
    final topicProvider = Provider.of<TopicProvider>(context, listen: false);
    try {
      await topicProvider.fetchQuestionsBySubTopic(
        context,
        subTopics: selectedSubtopicsMap.values
            .expand((subtopicList) => subtopicList)
            .toList(),
        numberOfQuestions: numberOfQuestions,
      );

      if (topicProvider.questions != null &&
          topicProvider.questions!.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestPage(
                  questions: topicProvider.questions!,
                  timePerQuestion: timePerQuestion),
            ));
        print(
            'Questions fetched successfully: ${topicProvider.questions!.length}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Test Setup",
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
      ),
      body: Consumer<TopicProvider>(
        builder: (context, topicProvider, child) {
          if (topicProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            );
          }

          if (topicProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading topics',
                    style: AppStyles.mondaB.copyWith(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTopics,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TestStyles.buildSectionHeader(
                  'Select Topics & Subtopics',
                  Icons.category,
                  customBlue,
                ),
                _buildTopicsSection(topicProvider),
                TestStyles.buildSectionHeader(
                  'Test Configuration',
                  Icons.settings,
                  customBlue,
                ),
                _buildConfigurationCard(),
                _buildSubmitButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopicsSection(TopicProvider topicProvider) {
    final topics = topicProvider.topics;
    if (topics == null) return const SizedBox();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics.keys.elementAt(index);
        return _buildExpandableTopicCard(topic, topics[topic]!);
      },
    );
  }

  // Widget _buildExpandableTopicCard(String topic, List<String> subtopics) {
  //   final isSelected = selectedTopic == topic;
  //   final selectedSubtopics = getSelectedSubtopics(topic);

  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     child: Column(
  //       children: [
  //         Material(
  //           color: Colors.transparent,
  //           child: InkWell(
  //             onTap: () => setState(() {
  //               selectedTopic = isSelected ? null : topic;
  //             }),
  //             borderRadius: BorderRadius.circular(15),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: isSelected
  //                       ? [
  //                           Colors.indigo.withOpacity(0.3),
  //                           Colors.indigo.withOpacity(0.1)
  //                         ]
  //                       : [
  //                           Colors.grey.withOpacity(0.1),
  //                           Colors.grey.withOpacity(0.05)
  //                         ],
  //                 ),
  //                 borderRadius: BorderRadius.circular(15),
  //                 border: Border.all(
  //                   color: isSelected
  //                       ? Colors.indigo
  //                       : selectedSubtopics.isNotEmpty
  //                           ? Colors.indigo.withOpacity(0.3)
  //                           : Colors.grey.withOpacity(0.3),
  //                   width: isSelected ? 2 : 1,
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(16),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: isSelected
  //                           ? Colors.indigo.withOpacity(0.2)
  //                           : Colors.grey.withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Icon(
  //                       _getTopicIcon(topic),
  //                       color: isSelected ? Colors.indigo : Colors.grey,
  //                       size: 24,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           topic,
  //                           style: AppStyles.mondaB.copyWith(
  //                             fontSize: 18,
  //                             color: isSelected ? Colors.indigo : Colors.white,
  //                           ),
  //                         ),
  //                         if (selectedSubtopics.isNotEmpty) ...[
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             '${selectedSubtopics.length} subtopics selected',
  //                             style: AppStyles.mondaB.copyWith(
  //                               fontSize: 14,
  //                               color: Colors.indigo.withOpacity(0.7),
  //                             ),
  //                           ),
  //                         ],
  //                       ],
  //                     ),
  //                   ),
  //                   Icon(
  //                     isSelected
  //                         ? Icons.keyboard_arrow_up
  //                         : Icons.keyboard_arrow_down,
  //                     color: isSelected ? Colors.indigo : Colors.grey,
  //                     size: 24,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         if (isSelected) ...[
  //           AnimatedContainer(
  //             duration: const Duration(milliseconds: 300),
  //             margin: const EdgeInsets.only(
  //               left: 16,
  //               right: 16,
  //               top: 8,
  //               bottom: 8,
  //             ),
  //             decoration: BoxDecoration(
  //               color: Colors.indigo.withOpacity(0.05),
  //               borderRadius: BorderRadius.circular(12),
  //               border: Border.all(
  //                 color: Colors.indigo.withOpacity(0.1),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Select Subtopics',
  //                     style: AppStyles.mondaB.copyWith(
  //                       fontSize: 16,
  //                       color: Colors.indigo,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 12),
  //                   Wrap(
  //                     spacing: 8,
  //                     runSpacing: 12,
  //                     children: subtopics.map((subtopic) {
  //                       final isSubtopicSelected =
  //                           selectedSubtopics.contains(subtopic);
  //                       return InkWell(
  //                         onTap: () {
  //                           setState(() {
  //                             selectedSubtopicsMap[topic] ??= [];
  //                             if (isSubtopicSelected) {
  //                               selectedSubtopicsMap[topic]!.remove(subtopic);
  //                             } else {
  //                               selectedSubtopicsMap[topic]!.add(subtopic);
  //                             }
  //                           });
  //                         },
  //                         borderRadius: BorderRadius.circular(20),
  //                         child: Container(
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: 16,
  //                             vertical: 8,
  //                           ),
  //                           decoration: BoxDecoration(
  //                             gradient: LinearGradient(
  //                               colors: isSubtopicSelected
  //                                   ? [
  //                                       Colors.purple.withOpacity(0.3),
  //                                       Colors.purple.withOpacity(0.1),
  //                                     ]
  //                                   : [
  //                                       Colors.grey.withOpacity(0.1),
  //                                       Colors.grey.withOpacity(0.05),
  //                                     ],
  //                             ),
  //                             borderRadius: BorderRadius.circular(20),
  //                             border: Border.all(
  //                               color: isSubtopicSelected
  //                                   ? Colors.purple
  //                                   : Colors.grey.withOpacity(0.3),
  //                             ),
  //                           ),
  //                           child: Row(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               Icon(
  //                                 isSubtopicSelected
  //                                     ? Icons.check_circle
  //                                     : Icons.circle_outlined,
  //                                 size: 18,
  //                                 color: isSubtopicSelected
  //                                     ? Colors.purple
  //                                     : Colors.grey,
  //                               ),
  //                               const SizedBox(width: 8),
  //                               Text(
  //                                 subtopic,
  //                                 style: AppStyles.mondaB.copyWith(
  //                                   fontSize: 14,
  //                                   color: isSubtopicSelected
  //                                       ? Colors.purple
  //                                       : Colors.grey,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     }).toList(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget _buildExpandableTopicCard(String topic, List<String> subtopics) {
    final isSelected = selectedTopic == topic;
    final selectedSubtopics = getSelectedSubtopics(topic);
    final displayName = _getTopicDisplayName(topic);
    final topicColor = _getTopicColor(topic);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() {
                selectedTopic = isSelected ? null : topic;
              }),
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [
                            topicColor.withOpacity(0.3),
                            topicColor.withOpacity(0.1)
                          ]
                        : [
                            Colors.grey.withOpacity(0.1),
                            Colors.grey.withOpacity(0.05)
                          ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected
                        ? topicColor
                        : selectedSubtopics.isNotEmpty
                            ? topicColor.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? topicColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTopicIcon(topic),
                        color: isSelected ? topicColor : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: AppStyles.mondaB.copyWith(
                              fontSize: 18,
                              color: isSelected ? topicColor : Colors.white,
                            ),
                          ),
                          if (selectedSubtopics.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${selectedSubtopics.length} subtopics selected',
                              style: AppStyles.mondaB.copyWith(
                                fontSize: 14,
                                color: topicColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: isSelected ? topicColor : Colors.grey,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelected) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                color: topicColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: topicColor.withOpacity(0.1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Subtopics',
                      style: AppStyles.mondaB.copyWith(
                        fontSize: 16,
                        color: topicColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: subtopics.map((subtopic) {
                        final isSubtopicSelected =
                            selectedSubtopics.contains(subtopic);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedSubtopicsMap[topic] ??= [];
                              if (isSubtopicSelected) {
                                selectedSubtopicsMap[topic]!.remove(subtopic);
                              } else {
                                selectedSubtopicsMap[topic]!.add(subtopic);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSubtopicSelected
                                    ? [
                                        topicColor.withOpacity(0.3),
                                        topicColor.withOpacity(0.1)
                                      ]
                                    : [
                                        Colors.grey.withOpacity(0.1),
                                        Colors.grey.withOpacity(0.05)
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSubtopicSelected
                                    ? topicColor
                                    : Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSubtopicSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 18,
                                  color: isSubtopicSelected
                                      ? topicColor
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  subtopic,
                                  style: AppStyles.mondaB.copyWith(
                                    fontSize: 14,
                                    color: isSubtopicSelected
                                        ? topicColor
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTopicColor(String topic) {
    return customBlue;
  }

  String _getTopicDisplayName(String topic) {
    switch (topic.toLowerCase()) {
      case 'dsa':
        return 'Data Structures & Algorithms';
      case 'dbms':
        return 'Database Management Systems';
      case 'os':
        return 'Operating Systems';
      case 'oop':
        return 'Object Oriented Programming';
      case 'cn':
        return 'Computer Networks';
      case 'verbal':
        return 'Verbal Ability';
      case 'quantitative':
        return 'Quantitative Aptitude';
      case 'logical':
        return 'Logical Reasoning';
      default:
        return topic;
    }
  }

  IconData _getTopicIcon(String topic) {
    switch (topic.toLowerCase()) {
      case 'dsa':
        return Icons.account_tree;
      case 'dbms':
        return Icons.data_array;
      case 'os':
        return Icons.desktop_windows;
      case 'oop':
        return Icons.extension;
      case 'cn':
        return Icons.hub;
      case 'verbal':
        return Icons.text_fields;
      case 'quantitative':
        return Icons.calculate;
      case 'logical':
        return Icons.psychology;
      default:
        return Icons.school;
    }
  }

  Widget _buildConfigurationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            customBlue.withOpacity(0.2),
            customBlue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: customBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConfigurationSlider(
            title: 'Number of Questions',
            value: numberOfQuestions.toDouble(),
            min: 5,
            max: 50,
            divisions: 9,
            onChanged: (value) =>
                setState(() => numberOfQuestions = value.round()),
            suffix: 'questions',
          ),
          const SizedBox(height: 24),
          _buildConfigurationSlider(
            title: 'Time per Question',
            value: timePerQuestion.toDouble(),
            min: 30,
            max: 180,
            divisions: 5,
            onChanged: (value) =>
                setState(() => timePerQuestion = value.round()),
            suffix: 'seconds',
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${value.round()} $suffix',
          style: AppStyles.mondaB.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: customBlue,
            inactiveTrackColor: customBlue.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: customBlue.withOpacity(0.1),
            valueIndicatorColor: customBlue,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: '${value.round()} $suffix',
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final bool canSubmit = selectedTopic != null &&
        getSelectedSubtopics(selectedTopic!).isNotEmpty;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
          onPressed: canSubmit ? _submitSelection : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: customBlue,
            disabledBackgroundColor: Colors.grey.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: (Provider.of<TopicProvider>(context).isLoading)
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : Text(
                  'Start Test',
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 18,
                    color: canSubmit ? Colors.white : Colors.grey,
                  ),
                )),
    );
  }
}
