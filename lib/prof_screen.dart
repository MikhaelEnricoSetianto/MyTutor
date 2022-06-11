import 'package:flutter/material.dart';

class ProfPage extends StatefulWidget {
  const ProfPage({Key? key}) : super(key: key);

  @override
  State<ProfPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<ProfPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
    );
  }
}
