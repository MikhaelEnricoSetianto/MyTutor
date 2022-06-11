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
            : Column(
                children: [
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 1),
                          children: List.generate(TutorList.length, (index) {
                            return InkWell(
                              splashColor: Colors.amber,
                              child: Card(
                                  child: Column(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/my_tutor/assets/tutors/" +
                                          TutorList[index].tutor_id.toString() +
                                          '.jpg',
                                    ),
                                  ),
                                  Flexible(
                                      flex: 4,
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
                                              (TutorList[index]
                                                  .tutor_description
                                                  .toString())),
                                          Text(TutorList[index]
                                              .tutor_email
                                              .toString()),
                                          Text(TutorList[index]
                                              .tutor_phone
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
