import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';

class MockInterviewSetUpPage extends StatefulWidget {
  const MockInterviewSetUpPage({super.key});

  @override
  State<MockInterviewSetUpPage> createState() => _MockInterviewSetUpPageState();
}

class _MockInterviewSetUpPageState extends State<MockInterviewSetUpPage> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();

  String? selectedType;
  String? selectedExperience;

  // Move these to a separate constants file or service
  static const Map<String, List<String>> dropdownOptions = {
    'companies': ['Google', 'Amazon', 'Facebook', 'Microsoft', 'Netflix'],
    'roles': [
      'Software Engineer',
      'Data Scientist',
      'Product Manager',
      'UI/UX Designer'
    ],
    'experienceLevels': [
      'Entry (0-2 years)',
      'Mid-Level (3-5 years)',
      'Senior (6+ years)'
    ],
    'interviewTypes': ['Technical', 'HR', 'System Design', 'Behavioral']
  };

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }

  void _handleStartInterview() {
    final interviewData = {
      'company': _companyController.text,
      'role': _roleController.text,
      'type': selectedType,
      'experience': selectedExperience,
      'jobDescription': _jobDescriptionController.text,
    };

    debugPrint('Interview Data: $interviewData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        "Mock Interview Setup",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAutocompleteField(
              "Company Name",
              _companyController,
              dropdownOptions['companies']!,
              Icons.business,
            ),
            const SizedBox(height: 16),
            _buildAutocompleteField(
              "Role",
              _roleController,
              dropdownOptions['roles']!,
              Icons.work,
            ),
            const SizedBox(height: 24),
            CustomDropdown(
              label: "Interview Type",
              options: dropdownOptions['interviewTypes']!,
              selectedValue: selectedType,
              onChanged: (value) => setState(() => selectedType = value),
              icon: Icons.category,
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              label: "Experience Level",
              options: dropdownOptions['experienceLevels']!,
              selectedValue: selectedExperience,
              onChanged: (value) => setState(() => selectedExperience = value),
              icon: Icons.timeline,
            ),
            const SizedBox(height: 24),
            _buildJobDescriptionInput(),
            const SizedBox(height: 32),
            StartButton(
              onPressed: _isFormValid() ? _handleStartInterview : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutocompleteField(
    String label,
    TextEditingController controller,
    List<String> options,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.mondaB.copyWith(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return options.where((String option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            controller.text = selection;
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextFormField(
              controller: fieldController,
              focusNode: fieldFocusNode,
              style: AppStyles.mondaB.copyWith(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: customBlue),
                hintText: "Start typing...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: backgroundColor,
                border: _getBorder(),
                enabledBorder: _getBorder(color: Colors.grey.withOpacity(0.2)),
                focusedBorder: _getBorder(color: customBlue),
              ),
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF2A2A2A),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  constraints: const BoxConstraints(maxHeight: 200),
                  width:
                      MediaQuery.of(context).size.width - 40, // Adjust padding
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return ListTile(
                        title: Text(
                          option,
                          style: AppStyles.mondaB.copyWith(color: Colors.white),
                        ),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  OutlineInputBorder _getBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: color != null ? BorderSide(color: color) : BorderSide.none,
    );
  }

  bool _isFormValid() {
    return _companyController.text.isNotEmpty &&
        _roleController.text.isNotEmpty &&
        selectedType != null &&
        selectedExperience != null;
  }

  Widget _buildJobDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Job Description",
          style: AppStyles.mondaB.copyWith(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _jobDescriptionController,
          maxLines: 5,
          style: AppStyles.mondaB.copyWith(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.description, color: customBlue),
            hintText: "Paste job description here (optional)",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: backgroundColor,
            border: _getBorder(),
            enabledBorder: _getBorder(color: Colors.grey.withOpacity(0.2)),
            focusedBorder: _getBorder(color: customBlue),
          ),
        ),
      ],
    );
  }
}

// CustomDropdown and StartButton classes remain the same
class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final IconData icon;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.mondaB.copyWith(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: options
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: AppStyles.mondaB.copyWith(color: Colors.white),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF2A2A2A),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: customBlue),
            filled: true,
            fillColor: backgroundColor,
            border: _getBorder(),
            enabledBorder: _getBorder(color: Colors.white.withOpacity(0.2)),
            focusedBorder: _getBorder(color: customBlue),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _getBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: color != null ? BorderSide(color: color) : BorderSide.none,
    );
  }
}

class StartButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const StartButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isEnabled ? customBlue : Colors.grey.withOpacity(0.3),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          "Start Interview",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
