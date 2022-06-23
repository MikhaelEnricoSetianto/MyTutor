import 'package:flutter/material.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<FavPage> {
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
