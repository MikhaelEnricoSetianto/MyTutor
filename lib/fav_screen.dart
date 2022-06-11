import 'package:flutter/material.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
    );
  }
}
