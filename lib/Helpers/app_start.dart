import 'package:carease/Components/custom_progress_indicator.dart';
import 'package:carease/Pages/login_page.dart';
import 'package:carease/Pages/register_page.dart';
import 'package:carease/Pages/UserPages/user_home.dart';
import 'package:carease/Pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Database/user_details.dart';
import '../Database/worker_details.dart';
import '../Pages/WorkerPages/worker_home.dart';

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
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberMe = prefs.getBool('rememberMe');

    if(rememberMe == true){
      String? phoneNumber = prefs.getString('phoneNumber');
      if(prefs.getString('role') == 'user'){
        UserData.instance.currentUser.phoneNumber = phoneNumber!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const UserHome();
            },
          ),
        );
      }
      else{
        WorkerData.instance.currentWorker.phoneNumber = phoneNumber!;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const WorkerHome();
            },
          ),
        );
      }
    }
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

    //return UserHome();
    return _showWelcome ? WelcomePage() : LoginPage();
  }
}