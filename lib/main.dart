import 'package:flutter/material.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/pages/splash/splash_page.dart';
import 'package:hirewise/provider/job_provider.dart';
import 'package:hirewise/provider/topic_provider.dart';
import 'package:hirewise/provider/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const HireWise());
}

class HireWise extends StatelessWidget {
  const HireWise({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, TopicProvider>(
          create: (_) => TopicProvider(userProvider: UserProvider()),
          update: (_, userProvider, jobProvider) =>
              TopicProvider(userProvider: userProvider),
        ),
        ChangeNotifierProxyProvider<UserProvider, JobProvider>(
          create: (_) => JobProvider(userProvider: UserProvider()),
          update: (_, userProvider, jobProvider) =>
              JobProvider(userProvider: userProvider),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedItemColor: customBlue,
            unselectedItemColor: Colors.white,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: backgroundColor),
          colorScheme: ColorScheme.fromSeed(seedColor: customBlue),
          primaryColor: customBlue,
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
