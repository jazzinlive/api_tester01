import 'dart:async';
import 'dart:io';
import 'package:apitest01/models/jwt_models.dart';
import 'package:apitest01/screens/menu.dart';
import 'package:apitest01/screens/nav_control.dart';
import 'package:apitest01/screens/web_view_stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RedirectPaymentPage extends StatefulWidget {
  RedirectPaymentPage(webPaymentURL, {Key? key}) : super(key: key);

  @override
  State<RedirectPaymentPage> createState() => _RedirectPaymentPageState();
}

class _RedirectPaymentPageState extends State<RedirectPaymentPage> {
  final controller = Completer<WebViewController>();

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2c2p Payment Page'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 1,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.teal.withOpacity(0.8),
                  //Colors.white.withOpacity(0.7),
                  Colors.purple[900]!.withOpacity(0.8),
                ]),
          ),
        ),
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller)
        ],
      ),
      
      body: WebViewStack(controller: controller),
    );
  }
}
