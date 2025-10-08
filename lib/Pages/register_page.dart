import 'package:carease/Components/custom_progress_indicator.dart';
import 'package:carease/Components/text_button_orange.dart';
import 'package:carease/Database/user_details.dart';
import 'package:carease/Pages/UserPages/user_home.dart';
import 'package:carease/Pages/WorkerPages/worker_home.dart';
import 'package:easy_radio/easy_radio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:alert_info/alert_info.dart';
import '../Components/carease_colors.dart';
import '../Components/input_field.dart';
import '../Database/worker_details.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String category = "users"; // default
  String enteredOtp = "";
  bool otpSent = false;
  bool loading = false;
  String verificationId = "";

  bool isValidPhone(String phone) {
    final regex = RegExp(r'^\d{10}$'); // 10 digits for Pakistan
    return regex.hasMatch(phone);
  }

  Future<bool> userAlreadyRegistered(String phone) async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(phone).get();
    var workerDoc = await FirebaseFirestore.instance.collection('workers').doc(phone).get();

    if (userDoc.exists || workerDoc.exists) {
      return true;
    }

    return false;
  }

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    final name = nameController.text.trim();

    if (name.isEmpty) {
      AlertInfo.show(
        context: context,
        text: 'Please enter your name',
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      return;
    }

    if (!isValidPhone(phone)) {
      AlertInfo.show(
        context: context,
        text: 'Invalid phone number.',
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      return;
    }

    if (await userAlreadyRegistered(phone)) {
      AlertInfo.show(
        context: context,
        text: 'Phone # already registered, Please login.',
        icon: Ionicons.alert_circle,
        iconColor: Colors.redAccent,
        position: MessagePosition.top,
        padding: 80.0,
      );
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+92$phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          _onRegisterSuccess(phone, name, category);
        },
        verificationFailed: (FirebaseAuthException e) {
          AlertInfo.show(
            context: context,
            text: e.message ?? "Verification failed",
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
            text: "OTP Sent",
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
    if (enteredOtp.isEmpty) {
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
        smsCode: enteredOtp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final phone = phoneController.text.trim();
      final name = nameController.text.trim();
      await _onRegisterSuccess(phone, name, category);

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

  Future<void> _onRegisterSuccess(String phone, String name, String category) async {
    if(category == 'users') {
      UserData.instance.currentUser.name = name;
      UserData.instance.currentUser.phoneNumber = phone;
      UserData.instance.currentUser.location = GeoPoint(0, 0);

      await UserData.instance.uploadUserDetails();

      setState(() => loading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const UserHome();
          },
        ),
      );
    }
    else {
      // update firestore with worker details

        setState(() => loading = false);


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
        decoration: const BoxDecoration(
          color: CareaseColors.backgroundLight,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
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
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Please provide the details to register",
                              style: TextStyle(
                                color: CareaseColors.grey,
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            InputField(
                              controller: nameController,
                              hintText: "Name",
                              obscureText: false,
                              onlyNumbers: false,
                            ),
                            const SizedBox(height: 15),
                            InputField(
                              controller: phoneController,
                              hintText: "Phone no (3xxxxxxxxx)",
                              obscureText: false,
                              onlyNumbers: true,
                            ),
                            const SizedBox(height: 35),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  EasyRadio<String>(
                                    value: "users",
                                    radius: 10.0,
                                    dotRadius: 8.0,
                                    activeBorderColor: CareaseColors.greyDark,
                                    inactiveBorderColor: CareaseColors.greyDark,
                                    dotColor: CareaseColors.orangeLight,
                                    dotStyle: DotStyle.check(),
                                    groupValue: category,
                                    onChanged: (value) {
                                      setState(() {
                                        category = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 20,),
                                  Text(
                                    "Looking for services.",
                                    style: TextStyle(
                                      color: CareaseColors.greyDark,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  EasyRadio<String>(
                                    value: "workers",
                                    radius: 10.0,
                                    dotRadius: 8.0,
                                    activeBorderColor: CareaseColors.greyDark,
                                    inactiveBorderColor: CareaseColors.greyDark,
                                    dotColor: CareaseColors.orangeLight,
                                    dotStyle: DotStyle.check(),
                                    groupValue: category,
                                    onChanged: (value) {
                                      setState(() {
                                        category = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 20,),
                                  Text(
                                    "Want to provide a service.",
                                    style: TextStyle(
                                      color: CareaseColors.greyDark,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: otpSent ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Enter the code sent to your mobile number",
                              style: TextStyle(
                                color: CareaseColors.grey,
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
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
                                  inactiveColor: CareaseColors.greyDark,
                                  selectedColor: CareaseColors.greyDark,
                                  activeColor: CareaseColors.greyDark,
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
                        buttonText: otpSent ? "Verify OTP" : "Sign Up",
                        onTap: otpSent ? verifyOtp : sendOtp,
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginPage();
                              },
                            ),
                          );
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: CareaseColors.greyDark,
                            fontWeight: FontWeight.normal,
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
