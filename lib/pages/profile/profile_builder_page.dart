import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileBuilderPage extends StatefulWidget {
  final User user;
  const ProfileBuilderPage({super.key, required this.user});

  @override
  State<ProfileBuilderPage> createState() => _ProfileBuilderPageState();
}

class _ProfileBuilderPageState extends State<ProfileBuilderPage> {
  late TextEditingController resumeContentController;
  late TextEditingController additionalInfoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    resumeContentController = TextEditingController();
    additionalInfoController = TextEditingController();
  }

  @override
  void dispose() {
    resumeContentController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _processResume() async {
    if (_isLoading) return; // Prevent double submission

    if (resumeContentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste your resume content')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.buildUserProfileFromResume(
        context: context,
        userId: widget.user.id,
        resumeContent: resumeContentController.text,
        extraInfo: additionalInfoController.text,
      );

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
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
                        enabled: !_isLoading,
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
                        enabled: !_isLoading,
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
                  onPressed: _isLoading ? null : _processResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Building Profile...',
                              style: AppStyles.mondaB.copyWith(fontSize: 16),
                            ),
                          ],
                        )
                      : Text(
                          'Build Profile',
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
