import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/login/email_verification_page.dart';
import 'package:hirewise/widget/customBottomNavigator.dart';
import 'package:provider/provider.dart';
import 'package:hirewise/provider/user_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Get UserProvider instance
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Initialize user provider (this will load data from local storage)
      await userProvider.initialize();

      // Delay for splash screen
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      // Check if user is authenticated
      if (userProvider.isAuthenticated) {
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomBottomNavigator(),
          ),
        );
      } else {
        print("New User");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EmailVerificationPage(),
          ),
        );
      }
    } catch (e) {
      print("Error during initialization: $e");
      // Handle initialization error - maybe show error screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EmailVerificationPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Hire",
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 45,
                      color: customBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "Wise",
                    style: AppStyles.mondaB.copyWith(
                      fontSize: 45,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
