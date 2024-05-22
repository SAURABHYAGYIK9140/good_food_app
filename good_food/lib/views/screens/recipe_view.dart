import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String postUrl;

  late String finalUrl ;
 late final WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalUrl = Get.arguments as String;

    // finalUrl = widget.postUrl;
    if(finalUrl.contains('http://')){
      finalUrl = finalUrl.replaceAll("http://","https://");
      print(finalUrl + "this is final url");
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(finalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //           colors: [
            //             const Color(0xff213A50),
            //             const Color(0xff071930)
            //           ],
            //           begin: FractionalOffset.topRight,
            //           end: FractionalOffset.bottomLeft)),
            // ),
            if (_progress < 1)
              Center(
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),

            Container(
              height: MediaQuery.of(context).size.height - (Platform.isIOS ? 104 : 30),
              width: MediaQuery.of(context).size.width,
              child:WebViewWidget(controller: _controller),

            ),
          ],
        ),
      )
    );
  }
}
