import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileBuilderPage extends StatefulWidget {
  final user;
  const ProfileBuilderPage({super.key, required this.user});

  @override
  State<ProfileBuilderPage> createState() => _ProfileBuilderPageState();
}

class _ProfileBuilderPageState extends State<ProfileBuilderPage> {
  late TextEditingController resumeContentController;
  late TextEditingController additionalInfoController;

  @override
  void initState() {
    super.initState();
    resumeContentController = TextEditingController();
    additionalInfoController = TextEditingController();
  }

  Future<void> _processResume() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Build Profile from Resume",
          style: AppStyles.mondaB.copyWith(fontSize: 20),
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: cardBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paste Resume Content',
                        style: AppStyles.mondaB.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: resumeContentController,
                        maxLines: 10,
                        style: AppStyles.mondaN,
                        decoration: InputDecoration(
                          hintText: 'Paste your resume content here...',
                          hintStyle:
                              AppStyles.mondaN.copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: cardBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Information',
                        style: AppStyles.mondaB.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: additionalInfoController,
                        maxLines: 4,
                        style: AppStyles.mondaN,
                        decoration: InputDecoration(
                          hintText: 'Any additional information...',
                          hintStyle:
                              AppStyles.mondaN.copyWith(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Build',
                    style: AppStyles.mondaB.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
