import 'package:carease/Components/carease_colors.dart';
import 'package:carease/Components/text_button_blue.dart';
import 'package:carease/Components/text_button_orange.dart';
import 'package:carease/Pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: CareaseColors.backgroundLight,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50,),
                      Image.asset(
                        'lib/Images/logo_512.png',
                        fit: BoxFit.contain,
                        width: 250,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(height: 20),
                      // Text(
                      //   "Welcome to Carease",
                      //   style: TextStyle(
                      //     color: CareaseColors.white,
                      //     fontFamily: "MyFont",
                      //     fontSize: 30,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Your trusted partner for car care.",
                          style: TextStyle(
                            color: CareaseColors.purple,
                            fontFamily: "MyFont",
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Find skilled mechanics, electricians, and specialists all in one place. Whether it’s quick fixes, regular maintenance, or expert advice, Carease connects you with the right hands to keep your car running smooth.",
                          style: TextStyle(
                            color: CareaseColors.white,
                            fontFamily: "MyFont",
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      TextButtonOrange(
                        onTap: () {
                          OnContinueButtonTap(context);
                        },
                        buttonText: "Continue",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void OnContinueButtonTap(BuildContext context) {
    AddPlayerPrefs();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> AddPlayerPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcomeScreenShown', true);
  }

  Future<void> ClearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
