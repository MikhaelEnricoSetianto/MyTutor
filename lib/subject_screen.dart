// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/constants.dart';
import 'package:login_ui/models/subject.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject> SubjectList = <Subject>[];
  var numpage, currpage = 1;
  var title = "";
  @override
  void initState() {
    super.initState();
    loadSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SubjectList.isEmpty
            ? Center(
                child: Text(
                title,
                style: const TextStyle(fontSize: 40),
              ))
            : SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: SubjectList.length,
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
                                      margin: const EdgeInsets.fromLTRB(
                                          5, 5, 10, 5),
                                      child: CachedNetworkImage(
                                        imageUrl: CONSTANTS.server +
                                            "/my_tutor/assets/courses/" +
                                            SubjectList[index]
                                                .subject_id
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
                                            margin: const EdgeInsets.all(2),
                                            child: Text(
                                              SubjectList[index]
                                                  .subject_name
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
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
                                                      SubjectList[index]
                                                          .subject_description
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Card(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                        "RM " +
                                                            double.parse(SubjectList[
                                                                        index]
                                                                    .subject_price
                                                                    .toString())
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        )),
                                                  ),
                                                ),
                                                Card(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                        SubjectList[index]
                                                                .subject_sessions
                                                                .toString() +
                                                            " session(s)",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        )),
                                                  ),
                                                ),
                                                Card(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Icon(Icons.star,
                                                              color: Colors
                                                                  .yellow),
                                                          Text(
                                                              SubjectList[index]
                                                                  .subject_rating
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .yellow,
                                                                fontSize: 12,
                                                              )),
                                                        ],
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
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
                            loadSubject();
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

  void loadSubject() {
    numpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/subject.php"), body: {
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

        if (extractdata['subjects'] != null) {
          SubjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            SubjectList.add(Subject.fromJson(v));
          });
        } else {
          SubjectList.clear();
        }
        setState(() {});
      }
    });
  }
}
