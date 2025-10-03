import 'package:carease/Helpers/app_start.dart';
import 'package:carease/Pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase Initialised");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Carease',
      theme: ThemeData.dark().copyWith(
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: ThemeData.dark().textTheme.apply(
          //fontFamily: 'Poppins', // or 'Poppins' / 'SF-Pro'
        ),
      ),
      home: AppStart(),
    );
  }
}