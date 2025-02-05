import 'package:flutter/material.dart';
import 'package:hirewise/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:hirewise/provider/user_provider.dart'; 
import 'package:hirewise/pages/home/home_page.dart';
import 'package:hirewise/pages/apply/apply_page.dart';
import 'package:hirewise/pages/prepzone/prepzone.dart';
import 'package:hirewise/pages/profile/profile_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hirewise/const/colors.dart';
import 'package:hirewise/const/font.dart';

class CustomBottomNavigator extends StatefulWidget {
  const CustomBottomNavigator({super.key});

  @override
  State<CustomBottomNavigator> createState() => _CustomBottomNavigatorState();
}

class _CustomBottomNavigatorState extends State<CustomBottomNavigator> {
  int _currIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize the pages in the initState
    _pages.addAll([
      HomePage(),
      ApplyPage(),
      PrepZonePage(),
      PrepZonePage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user!;

    _pages[3] = ProfilePage(user: user, viewer: false);

    return Scaffold(
      body: _pages[_currIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        elevation: 0,
        selectedLabelStyle: AppStyles.mondaB.copyWith(fontSize: 12),
        selectedItemColor: customBlue,
        unselectedItemColor: Colors.white,
        onTap: (value) {
          setState(() {
            _currIndex = value;
          });
        },
        currentIndex: _currIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.homeOutline),
            label: "Home",
            activeIcon: Icon(MdiIcons.home),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.near_me_outlined),
            activeIcon: Icon(Icons.near_me),
            label: "Apply",
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.headLightbulbOutline),
            activeIcon: Icon(MdiIcons.headLightbulb),
            label: "Prep Zone",
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountOutline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
