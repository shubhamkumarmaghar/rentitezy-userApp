import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title, uri;

  const WebViewPage({Key? key, required this.title, required this.uri})
      : super(key: key);

  @override
  InAppWebViewPageState createState() => InAppWebViewPageState();
}

class InAppWebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark, //<-- SEE HERE
        child: Scaffold(
          body: WebView(
            initialUrl: widget.uri,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ));
  }
}
