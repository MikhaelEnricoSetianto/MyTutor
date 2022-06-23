// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

class ProfPage extends StatefulWidget {
  const ProfPage({Key? key}) : super(key: key);

  @override
  State<ProfPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<ProfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 154, 33),
          centerTitle: true,
          toolbarHeight: 45,
          title: const Text(
            'MY TUTOR',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0));
  }
}
