import 'package:flutter/material.dart';

class SubsPage extends StatefulWidget {
  const SubsPage({Key? key}) : super(key: key);

  @override
  State<SubsPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubsPage> {
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
