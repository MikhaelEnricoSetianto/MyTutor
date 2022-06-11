import 'dart:async';

import 'package:flutter/material.dart';

import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

ColorScheme defaultColorScheme = const ColorScheme(
  primary: Color.fromARGB(255, 0, 154, 33),
  secondary: Color.fromARGB(255, 0, 201, 181),
  surface: Color.fromARGB(255, 0, 0, 0),
  background: Color.fromARGB(255, 0, 0, 0),
  error: Color.fromARGB(255, 56, 204, 27),
  onPrimary: Color.fromARGB(255, 255, 255, 255),
  onSecondary: Color.fromARGB(255, 255, 0, 0),
  onSurface: Color.fromARGB(255, 255, 255, 255),
  onBackground: Color.fromARGB(255, 0, 0, 0),
  onError: Color.fromARGB(255, 255, 0, 0),
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTutor',
      theme: ThemeData(
        colorScheme: defaultColorScheme,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(title: 'MyTutor'),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => const LoginPage(
                      title: 'Login UI',
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                "MyTutor",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              CircularProgressIndicator(),
              Text("Now Loading",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ],
          ),
        ),
      ),
    );
  }
}
