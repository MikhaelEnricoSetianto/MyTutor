// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:login_ui/constants.dart';
import 'package:login_ui/models/tutor.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:http/http.dart' as http;

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key}) : super(key: key);

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  List<Tutor> TutorList = <Tutor>[];
  var numpage, currpage = 1;
  var title = "";
  @override
  void initState() {
    super.initState();
    loadTutor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: TutorList.isEmpty
            ? Center(
                child: Text(
                title,
                style: const TextStyle(fontSize: 60),
              ))
            : SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: TutorList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            height: 280,
                            child: Card(
                              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(4, 2, 6, 2),
                                      child: CachedNetworkImage(
                                        imageUrl: CONSTANTS.server +
                                            "/my_tutor/assets/tutors/" +
                                            TutorList[index]
                                                .tutor_id
                                                .toString() +
                                            '.jpg',
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            child: Text(
                                              TutorList[index]
                                                  .tutor_name
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Card(
                                            child: Flexible(
                                              flex: 3,
                                              child: Text(
                                                  "\n" +
                                                      TutorList[index]
                                                          .tutor_description
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.mail,
                                                    color: Colors.black,
                                                    size: 20),
                                                Text(
                                                    TutorList[index]
                                                        .tutor_email
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    )),
                                                const Icon(Icons.phone,
                                                    color: Colors.green,
                                                    size: 20),
                                                Text(
                                                    TutorList[index]
                                                        .tutor_phone
                                                        .toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: NumberPaginator(
                        numberPages: numpage ?? 1,
                        onPageChange: (int index) {
                          setState(() {
                            currpage = index + 1;
                            loadTutor();
                          });
                        },
                        buttonShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        buttonSelectedBackgroundColor:
                            const Color.fromARGB(255, 0, 154, 33),
                        buttonSelectedForegroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ));
  }

  void loadTutor() {
    numpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/tutor.php"), body: {
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
}
