import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';
import 'package:hirewise/pages/login/email_verification_page.dart';
import 'package:hirewise/pages/splash/select_skill_page.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:hirewise/widget/customBottomNavigator.dart';
import 'package:provider/provider.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    String otp = _controller.text;
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.verifyOTP(context, widget.email, otp);

      if (!mounted) return;

      final user = userProvider.user;
      if (user != null) {
        if (user.keySkills.length < 5) {
          // Navigate to skills selection page if skills aren't sufficient
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SelectSkillsPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          // User has sufficient skills, proceed to main app
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const CustomBottomNavigator()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // User not authenticated, go to email verification
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const EmailVerificationPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('Error during OTP verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOTP() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .sendOTP(context, widget.email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code resent successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Hire",
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Wise",
                          style: AppStyles.mondaB.copyWith(
                            fontSize: 36,
                            color: customBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  "Enter Verification Code",
                  style: AppStyles.mondaB.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  "We've sent a verification code to",
                  style: AppStyles.mondaN.copyWith(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 16,
                    color: customBlue,
                  ),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _controller,
                  style: AppStyles.mondaB.copyWith(
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: cardBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "000000",
                    hintStyle: AppStyles.mondaN.copyWith(
                      fontSize: 24,
                      color: Colors.white24,
                      letterSpacing: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Verify',
                            style: AppStyles.mondaB.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Resend Code
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _resendOTP,
                    child: Text(
                      "Resend Code",
                      style: AppStyles.mondaN.copyWith(
                        color: customBlue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
