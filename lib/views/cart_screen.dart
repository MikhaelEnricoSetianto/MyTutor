// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_import, avoid_print

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/constants.dart';
import 'package:login_ui/models/cart.dart';
import 'package:login_ui/models/subject.dart';
import 'package:login_ui/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:login_ui/views/payment_screen.dart';
import 'package:login_ui/views/subject_screen.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<User> UserList = <User>[];
  List<Cart> CartList = <Cart>[];
  double totalpayable = 0.0;
  String titlecenter = "...";
  var title = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadCart();
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
              'MY CART',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectPage(user: User()),
                  ),
                );
              },
            ),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                                user: widget.user, totalpayable: totalpayable),
                          ),
                        );
                      },
                    ),
                    // onTap: () {},
                    // child: const Icon(
                    //   Icons.check,
                    //   size: 26.0,
                    // ),
                  )),
              // [

              //   IconButton(
              //     icon: const Icon(Icons.shopping_basket_sharp),
              //     onPressed: () {
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => PaymentPage(user: User()),
              //         ),
              //       );
              //     },
              //   ),
            ]),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: CartList.isEmpty
            ? Center(
                child: Text(
                title,
                style: const TextStyle(fontSize: 30),
              ))
            : Column(
                children: [
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 1),
                          children: List.generate(CartList.length, (index) {
                            return InkWell(
                              child: Card(
                                  child: Column(
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/my_tutor/assets/courses/" +
                                          CartList[index]
                                              .subject_id
                                              .toString() +
                                          '.jpg',
                                    ),
                                  ),
                                  Flexible(
                                      flex: 10,
                                      child: Column(
                                        children: [
                                          Text(
                                            "\n" +
                                                CartList[index]
                                                    .subject_name
                                                    .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "\nRM " +
                                                double.parse(CartList[index]
                                                        .price
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              )),
                            );
                          }))),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Price: RM " +
                                totalpayable.toStringAsFixed(2),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  void _loadCart() {
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/loadcart.php"), body: {
      'email': widget.user.email.toString(),
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['cart'] != null) {
          CartList = <Cart>[];
          extractdata['cart'].forEach((v) {
            CartList.add(Cart.fromJson(v));
          });
          int qty = 0;
          totalpayable = 0.00;
          for (var element in CartList) {
            qty = qty + int.parse(element.cart_qty.toString());
            totalpayable =
                totalpayable + double.parse(element.totalprice.toString());
          }
          titlecenter = qty.toString() + " Products in your cart";
          setState(() {});
        }
      } else {
        titlecenter = "Your Cart is Empty";
        CartList.clear();
        setState(() {});
      }
    });
  }
}
