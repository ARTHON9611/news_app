import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Viewurl extends StatefulWidget {
  String url;
  Viewurl(this.url);
  @override
  State<Viewurl> createState() => _ViewurlState();
}

class _ViewurlState extends State<Viewurl> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          child: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          setState(() {
            controller.complete(webViewController);
          });
        },
      )),
    ));
  }
}
