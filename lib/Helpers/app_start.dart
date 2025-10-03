import 'package:carease/Components/custom_progress_indicator.dart';
import 'package:carease/Pages/login_page.dart';
import 'package:carease/Pages/register_page.dart';
import 'package:carease/Pages/user_home.dart';
import 'package:carease/Pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStart extends StatefulWidget {
  @override
  _AppStartState createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  bool _loading = true;
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenWelcome = prefs.getBool('welcomeScreenShown') ?? false;

    setState(() {
      _showWelcome = !hasSeenWelcome;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(body: Center(child: CustomProgressIndicator(imagePath: 'lib/Images/loading_gear.png',)));
    }

    return UserHome();
    return _showWelcome ? WelcomePage() : LoginPage();
  }
}