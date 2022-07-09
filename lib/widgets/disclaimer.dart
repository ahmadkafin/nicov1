import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import '../providers/auth.dart';

class Disclaimer extends StatefulWidget {
  Disclaimer({Key? key}) : super(key: key);
  @override
  State<Disclaimer> createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  late WebViewController _webViewController;
  String filePath = 'files/disclaimer.html';
  bool _isAccept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  child: WebView(
                    initialUrl: '',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _webViewController = webViewController;
                      _loadFromFile();
                    },
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Theme(
                      data: ThemeData(
                        primarySwatch: Colors.blue,
                        unselectedWidgetColor: Colors.white,
                      ),
                      child: Checkbox(
                        value: _isAccept,
                        onChanged: (value) {
                          print(_isAccept);
                          setState(
                            () {
                              _isAccept = !_isAccept;
                            },
                          );
                        },
                      ),
                    ),
                    const Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    onPressed: () async {
                      var _auth = Provider.of<Auth>(
                        context,
                        listen: false,
                      );
                      await _auth.logout().then(
                            (value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            ),
                          );
                    },
                    child: const Text(
                      "Decline",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isAccept,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Provider.of<Auth>(context, listen: false)
                            .disclaimerOff();
                      },
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadFromFile() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(
      Uri.dataFromString(
        fileHtmlContents,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }
}
