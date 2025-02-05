import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';

class BaseEditPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onSave;

  const BaseEditPage({
    super.key,
    required this.title,
    required this.children,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title, style: AppStyles.mondaB.copyWith(fontSize: 22)),
        actions: [
          TextButton(
            onPressed: onSave,
            child: Text(
              'Save',
              style: AppStyles.mondaB.copyWith(color: customBlue, fontSize: 20),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

// Reusable styled text field
class StyledTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final int? maxLines;
  final TextInputType? keyboardType;

  const StyledTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.mondaN.copyWith(color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: AppStyles.mondaN.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppStyles.mondaN.copyWith(color: Colors.grey.withOpacity(0.5)),
            filled: true,
            fillColor: cardBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

