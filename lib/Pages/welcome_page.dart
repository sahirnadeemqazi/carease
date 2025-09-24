import 'package:carease/Components/carease_colors.dart';
import 'package:carease/Components/text_button_blue.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareaseColors.backgroundDark,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Image.asset('lib/Images/logo_512.png',width: 100,),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Text(
                          "Welcome to Carease",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "MyFont",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          "Your trusted partner for car care.",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "MyFont",
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Find skilled mechanics, electricians, and specialists — all in one place. Whether it’s quick fixes, regular maintenance, or expert advice, Carease connects you with the right hands to keep your car running smooth.",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "MyFont",
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 1,
                    child: Column(
                      children: [
                        TextButtonBlue(onTap: OnContinueButtonTap, buttonText: "Continue"),
                      ],
                    )
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  void OnContinueButtonTap()
  {

  }
}
