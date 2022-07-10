// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_import

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/constants.dart';
import 'package:login_ui/models/cart.dart';
import 'package:login_ui/models/subject.dart';
import 'package:login_ui/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:login_ui/views/subject_screen.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'cart_screen.dart';

class PaymentPage extends StatefulWidget {
  final User user;
  final double totalpayable;
  const PaymentPage({Key? key, required this.user, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 154, 33),
          centerTitle: true,
          toolbarHeight: 45,
          title: const Text(
            'PAYMENT',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(user: User()),
                ),
              );
            },
          ),
          // actions: <Widget>[
          //   Padding(
          //       padding: const EdgeInsets.only(right: 10.0),
          //       child: GestureDetector(
          //         child: IconButton(
          //           icon: const Icon(Icons.check),
          //           onPressed: () {
          //             Navigator.pushReplacement(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => PaymentPage(user: User()),
          //               ),
          //             );
          //           },
          //         ),
          //         // onTap: () {},
          //         // child: const Icon(
          //         //   Icons.check,
          //         //   size: 26.0,
          //         // ),
          //       )),
          //   // [

          //   //   IconButton(
          //   //     icon: const Icon(Icons.shopping_basket_sharp),
          //   //     onPressed: () {
          //   //       Navigator.pushReplacement(
          //   //         context,
          //   //         MaterialPageRoute(
          //   //           builder: (context) => PaymentPage(user: User()),
          //   //         ),
          //   //       );
          //   //     },
          //   //   ),
          // ]
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: CONSTANTS.server +
                    '/my_tutor/payment.php' +
                    widget.user.email.toString() +
                    '&mobile=' +
                    widget.user.phone.toString() +
                    '&name=' +
                    widget.user.name.toString() +
                    '&amount=' +
                    widget.totalpayable.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
