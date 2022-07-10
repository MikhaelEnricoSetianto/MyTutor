// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/views/cart_screen.dart';
import 'package:login_ui/constants.dart';
import 'package:login_ui/models/subject.dart';
import 'package:login_ui/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SubjectPage extends StatefulWidget {
  final User user;
  const SubjectPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject> SubjectList = <Subject>[];
  List<User> UserList = <User>[];
  var numpage, currpage = 1;
  var title = "";
  String search = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadSubjects(1, search);
    });
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
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_basket_sharp),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(user: widget.user),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  _loadSearchDialog();
                },
              ),
            ]),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SubjectList.isEmpty
            ? Center(
                child: Text(
                title,
                style: const TextStyle(fontSize: 30),
              ))
            : Column(
                children: [
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 1,
                          children: List.generate(SubjectList.length, (index) {
                            return InkWell(
                              child: Card(
                                  child: Column(
                                children: [
                                  Flexible(
                                    flex: 8,
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
                                      flex: 20,
                                      child: Column(
                                        children: [
                                          Text(
                                            "\n" +
                                                SubjectList[index]
                                                    .subject_name
                                                    .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "\n" +
                                                (SubjectList[index]
                                                    .subject_description
                                                    .toString()),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "\nRM " +
                                                double.parse(SubjectList[index]
                                                        .subject_price
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            SubjectList[index]
                                                    .subject_sessions
                                                    .toString() +
                                                " sessions",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            SubjectList[index]
                                                .subject_rating
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.yellow),
                                          ),
                                          Expanded(
                                              flex: 10,
                                              child: IconButton(
                                                onPressed: () {
                                                  _cartDialog(index);
                                                },
                                                icon: const Icon(
                                                    Icons.shopping_cart),
                                                iconSize: 16,
                                              )),
                                        ],
                                      ))
                                ],
                              )),
                            );
                          }))),
                  SizedBox(
                    height: 25,
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
                                _loadSubjects(currpage, search);
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

  void _cartDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Add to Cart",
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text("Are you sure want to add '" +
                        (SubjectList[index].subject_name.toString()) +
                        "' with the price of " +
                        (SubjectList[index].subject_price.toString()) +
                        " RM to your cart? "),
                  ]),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _addtoCart(index);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                  )
                ],
              );
            },
          );
        });
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                alignment: Alignment.topCenter,
                title: const Text(
                  "Search ",
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search Here',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  void _addtoCart(int index) {
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/addcart.php"), body: {
      "subject_id": SubjectList[index].subject_id.toString(),
      "email": widget.user.email.toString(),
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        setState(() {});
      }
    });
  }

  void _loadSubjects(int page, String _search) {
    currpage = page;
    numpage ?? 1;
    ProgressDialog pd = ProgressDialog(context: context);
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
    pd.close();
  }
}
