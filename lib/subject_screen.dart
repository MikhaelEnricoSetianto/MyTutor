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
            : Column(
                children: [
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 1),
                          children: List.generate(SubjectList.length, (index) {
                            return InkWell(
                              splashColor: Colors.amber,
                              child: Card(
                                  child: Column(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/my_tutor/assets/courses/" +
                                          SubjectList[index]
                                              .subject_id
                                              .toString() +
                                          '.jpg',
                                    ),
                                  ),
                                  Flexible(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Text(
                                            SubjectList[index]
                                                .subject_name
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("\n" +
                                              (SubjectList[index]
                                                  .subject_description
                                                  .toString())),
                                          Text("RM " +
                                              double.parse(SubjectList[index]
                                                      .subject_price
                                                      .toString())
                                                  .toStringAsFixed(2)),
                                          Text(SubjectList[index]
                                              .subject_sessions
                                              .toString()),
                                          Text(SubjectList[index]
                                              .subject_rating
                                              .toString()),
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
                          width: 40,
                          child: TextButton(
                              onPressed: () {
                                currpage = index + 1;
                                loadSubject();
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
      print(response.body);
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
