import 'package:alert_info/alert_info.dart';
import 'package:carease/Components/carease_colors.dart';
import 'package:carease/Components/custom_progress_indicator.dart';
import 'package:carease/Components/text_button_orange.dart';
import 'package:carease/Pages/register_page.dart';
import 'package:carease/Pages/user_home.dart';
import 'package:carease/Pages/worker_home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Components/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  String enteredOtp = "";
  bool rememberMe = false;
  bool otpSent = false;
  bool loading = false;
  String verificationId = "";


  bool isValidPhone(String phone) {
    final regex = RegExp(r'^\d{10}$'); // Pakistan 10-digit format
    return regex.hasMatch(phone);
  }

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    if (!isValidPhone(phone)) {
      AlertInfo.show(
        context: context,
        text: "Invalid phone no",
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      return;
    }

    setState(() => loading = true);

    var userDoc =
    await FirebaseFirestore.instance.collection('users').doc(phone).get();

    if (!userDoc.exists) {
      AlertInfo.show(
        context: context,
        text: "Phone # not registered, Please signup",
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      setState(() => loading = false);
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+92$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _onLoginSuccess(userDoc['category'], phone);
        },
        verificationFailed: (FirebaseAuthException e) {
          AlertInfo.show(
            context: context,
            text: "Verification failed, Try again!",
            icon: Ionicons.alert_circle,
            iconColor: Colors.redAccent,
            position: MessagePosition.top,
            padding: 80.0,
          );
          setState(() => loading = false);
        },
        codeSent: (String verId, int? resendToken) {
          AlertInfo.show(
            context: context,
            text: "OTP sent!",
            icon: Ionicons.checkmark_circle,
            iconColor: Colors.green,
            position: MessagePosition.top,
            padding: 80.0,
          );
          setState(() {
            otpSent = true;
            verificationId = verId;
            loading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
    } catch (e) {
      AlertInfo.show(
        context: context,
        text: "Failed to send OTP",
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      setState(() => loading = false);
    }
  }

  Future<void> verifyOtp() async {
    debugPrint("Verifying OTP");
    final otp = enteredOtp;
    if (otp.isEmpty) {
      AlertInfo.show(
        context: context,
        text: "Please enter OTP",
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      return;
    }

    setState(() => loading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(phoneController.text.trim())
          .get();

      String category = userDoc['category']; // 'user' or 'worker'
      _onLoginSuccess(category, phoneController.text.trim());
    } catch (e) {
      AlertInfo.show(
        context: context,
        text: "Invalid OTP",
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      setState(() => loading = false);
    }
  }

  Future<void> _onLoginSuccess(String category, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('phoneNumber', phone);
      await prefs.setString('role', category);
    }

    if (category == 'user') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const UserHome();
          },
        ),
      );
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          color: CareaseColors.backgroundLight,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.transparent,
                  child: Column(
                      children: [
                        Image.asset('lib/Images/logo_512.png',width: 250,)]
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              "Enter your number to login",
                              style: TextStyle(
                                color: CareaseColors.white,
                                fontFamily: 'MyFont',
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 20),
                            InputField(
                              controller: phoneController,
                              hintText: '3xxxxxxxxx',
                              obscureText: false,
                              onlyNumbers: true,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  activeColor: CareaseColors.purple,
                                  onChanged: (value) {
                                    setState(() => rememberMe = value ?? false);
                                  },
                                ),
                                const Text(
                                  "Remember me",
                                  style: TextStyle(
                                    color: CareaseColors.white,
                                    fontFamily: 'MyFont',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: otpSent ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Enter OTP",
                              style: TextStyle(
                                color: CareaseColors.white,
                                fontFamily: 'MyFont',
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 6, // Number of digits
                                autoDisposeControllers: false,
                                animationType: AnimationType.fade,
                                keyboardType: TextInputType.number,
                                cursorColor: CareaseColors.orangeLight,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  borderRadius: BorderRadius.circular(12),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  inactiveFillColor: Colors.transparent,
                                  activeFillColor: Colors.transparent,
                                  selectedFillColor: Colors.transparent,
                                  inactiveColor: CareaseColors.purple,
                                  selectedColor: CareaseColors.purple,
                                  activeColor: CareaseColors.purple,
                                ),
                                enableActiveFill: true,
                                onChanged: (value) {
                                  enteredOtp = value; // updates as user types
                                },
                                onCompleted: (value) {
                                  enteredOtp = value; // stores complete OTP
                                  print("✅ Entered OTP: $enteredOtp");
                                },
                              ),
                            ),
                            const SizedBox(height: 15,),
                          ],
                        ) : SizedBox(),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      loading
                          ? const CustomProgressIndicator(
                        imagePath: 'lib/Images/loading_gear.png',
                        size: 50,
                      )
                          : TextButtonOrange(
                        buttonText: otpSent ? "Verify OTP" : "Continue",
                        onTap: otpSent ? verifyOtp : sendOtp,
                      ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const RegisterPage();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Don’t have an account? Sign up",
                          style: TextStyle(
                            fontFamily: 'MyFont',
                            color: CareaseColors.orangeDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}
