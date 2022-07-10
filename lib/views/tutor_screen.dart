// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login_ui/constants.dart';
import 'package:login_ui/models/tutor.dart';
import 'package:login_ui/models/subject.dart';
import 'package:http/http.dart' as http;

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key}) : super(key: key);

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  List<Tutor> TutorList = <Tutor>[];
  List<Subject> SubjectList = <Subject>[];
  var numpage, currpage = 1;
  var title = "";
  @override
  void initState() {
    super.initState();
    loadTutor();
    _loadSubjects(1, "");
  }

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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: TutorList.isEmpty
            ? Center(
                child: Text(
                title,
                style: const TextStyle(fontSize: 60),
              ))
            : Column(
                children: [
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 1,
                          children: List.generate(TutorList.length, (index) {
                            return InkWell(
                              child: Card(
                                  child: Column(
                                children: [
                                  Flexible(
                                    flex: 8,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/my_tutor/assets/tutors/" +
                                          TutorList[index].tutor_id.toString() +
                                          '.jpg',
                                    ),
                                  ),
                                  Flexible(
                                      flex: 20,
                                      child: Column(
                                        children: [
                                          Text(
                                            TutorList[index]
                                                .tutor_name
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("\n" +
                                              TutorList[index]
                                                  .tutor_email
                                                  .toString()),
                                          Text("\n" +
                                              TutorList[index]
                                                  .tutor_phone
                                                  .toString() +
                                              "\n"),
                                          TextButton(
                                              onPressed: () =>
                                                  _loadDetailDialog(index),
                                              child: const Text("Details"))
                                        ],
                                      ))
                                ],
                              )),
                            );
                          }))),
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: numpage,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 35,
                          child: TextButton(
                              onPressed: () {
                                currpage = index + 1;
                                _loadSubjects(currpage, "");
                                loadTutor();
                              },
                              child: Text(
                                (index + 1).toString(),
                              )),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }

  void loadTutor() {
    numpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/tutor2.php"), body: {
      'page': currpage.toString(),
    }).timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numpage = int.parse(jsondata['totalPages']);

        if (extractdata['tutors'] != null) {
          TutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            TutorList.add(Tutor.fromJson(v));
          });
        } else {
          TutorList.clear();
        }
        setState(() {});
      }
    });
  }

  void _loadSubjects(int page, String _search) {
    numpage ?? 1;
    currpage = page;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/subject2.php"), body: {
      'page': page.toString(),
      'search': _search,
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numpage = int.parse(jsondata['totalPages']);
        if (extractdata['subjects'] != null) {
          SubjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            SubjectList.add(Subject.fromJson(v));
          });
        } else {
          SubjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        SubjectList.clear();
        setState(() {});
      }
    });
  }

  _loadDetailDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  TutorList[index].tutor_name.toString(),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text((TutorList[index].tutor_description.toString())),
                    const Text(
                      "\nSubject(s) Taught :\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      (SubjectList[index].subject_name.toString()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    )
                  ]),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  )
                ],
              );
            },
          );
        });
  }
}
