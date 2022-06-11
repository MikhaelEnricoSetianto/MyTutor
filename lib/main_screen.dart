import 'package:flutter/material.dart';
import 'package:login_ui/fav_screen.dart';
import 'package:login_ui/prof_screen.dart';
import 'package:login_ui/subject_screen.dart';
import 'package:login_ui/subs_screen.dart';
import 'package:login_ui/tutor_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var rememberValue = false;
  int pageIndex = 0;
  final screenPage = [
    const SubjectPage(),
    const TutorPage(),
    const SubsPage(),
    const FavPage(),
    const ProfPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 154, 33),
          title: const Text(
            'MY TUTOR',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          centerTitle: true,
        ),
        body: IndexedStack(index: pageIndex, children: screenPage),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 0, 154, 33),
          // selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          currentIndex: pageIndex,
          iconSize: 25,
          fixedColor: const Color.fromARGB(255, 0, 0, 0),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          onTap: (index) => setState(() => pageIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              label: 'Subject',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'Tutor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline_outlined),
              label: 'Subscription',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline_outlined),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: 'Profile',
            ),
          ],
        ));
  }
}
