import 'package:carease/Components/carease_colors.dart';
import 'package:carease/Pages/UserPages/messages.dart';
import 'package:carease/Pages/UserPages/search_services.dart';
import 'package:carease/Pages/UserPages/user_favourites.dart';
import 'package:carease/Pages/UserPages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}


class _UserHomeState extends State<UserHome> {

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [];

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions.addAll([
      SearchServices(),
      UserFavourites(),
      Messages(),
      UserProfile(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("lib/Images/background_image.jpg"), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _selectedIndex,
          indicatorColor: CareaseColors.orangeLight,
          unselectedItemColor: CareaseColors.grey,
          backgroundColor: CareaseColors.backgroundDark.withOpacity(0.1),
          outlineBorderColor: CareaseColors.greyDark,
          borderWidth: 1,
          onTap: _handleIndexChanged,
          items: [
            CrystalNavigationBarItem(
              icon: Ionicons.home,
              unselectedIcon: Ionicons.home_outline,
              selectedColor: CareaseColors.orangeLight,
              unselectedColor: CareaseColors.greyDark,
            ),
            CrystalNavigationBarItem(
              icon: Ionicons.bookmark,
              unselectedIcon: Ionicons.bookmark_outline,
              selectedColor: CareaseColors.orangeLight,
              unselectedColor: CareaseColors.greyDark,
            ),
            CrystalNavigationBarItem(
              icon: Ionicons.mail,
              unselectedIcon: Ionicons.mail_outline,
              selectedColor: CareaseColors.orangeLight,
              unselectedColor: CareaseColors.greyDark,
            ),
            CrystalNavigationBarItem(
              icon: Ionicons.person,
              unselectedIcon: Ionicons.person_outline,
              selectedColor: CareaseColors.orangeLight,
              unselectedColor: CareaseColors.greyDark,
            ),
          ],
        ),
      ),
    );
  }
}
