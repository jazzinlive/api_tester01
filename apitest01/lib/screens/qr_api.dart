import 'dart:async';
import 'dart:convert';

import 'package:apitest01/screens/qr_api_qr30.dart';
import 'package:apitest01/screens/qr_api_qrall.dart';
import 'package:apitest01/screens/qr_api_qrcs.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_save/image_save.dart';
import 'package:status_alert/status_alert.dart';

import 'package:apitest01/services/jwt_services.dart';

import '../models/qr_models.dart';

class QRPayment extends StatefulWidget {
  const QRPayment({Key? key}) : super(key: key);

  @override
  State<QRPayment> createState() => _QRPaymentState();
}

class _QRPaymentState extends State<QRPayment> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pasteValue = '';

  String endpointURL1 =
      "https://api-sandbox.partners.scb/partners/sandbox/v1/oauth/token";
  String endpointURL2 =
      "https://api-sandbox.partners.scb/partners/sandbox/v1/payment/qrcode/create";
  String appKey = "l7c41f9a48550344418ef25ccc549dfab1";
  String secretKey = "d58f9def29294c39b552ea19359473ea";
  late String requestMsg1 =
      '{\n"applicationKey": "$appKey",\n"applicationSecret": "$secretKey"\n}';

  String bid = "178616548291167";
  String mid = "811434534321023";
  String tid = "119644890500961";
  DateTime now = DateTime.now();
  late String ref1 = DateFormat("yyyyMMddhhmmss").format(now);
  late String inv = DateFormat("yyyyMMddhhmmss").format(now);
  late String description = "item demo1";
  late double amount = 10.00;
  String csExtExpiry = "60";
  String frontendReturnURL = "https://developer.scb";
  String backendReturnURL =
      "https://3861159a-13a9-46f3-977f-78d2cd932679.mock.pstmn.io";
  late String requestMsg2 =
      '{\n  "qrType": "PP",\n  "ppType": "BILLERID",\n  "ppId": "178616548291167",\n  "amount": "$amount",\n  "ref1": "$ref1",\n  "ref2": "ABC",\n  "ref3": "RRN$ref1"}';
  late String requestMsgQR30 =
      '{\n  "qrType": "PP",\n  "ppType": "BILLERID",\n  "ppId": "178616548291167",\n  "amount": "$amount",\n  "ref1": "$ref1",\n  "ref2": "ABC",\n  "ref3": "RRN$ref1"}';
  late String requestMsgCS =
      '{\n  "qrType": "CS",\n  "merchantId": "$mid",\n  "terminalId": "$tid",\n  "invoice": "$inv",\n  "amount": "$amount",\n  "csExtExpiryTime" : "$csExtExpiry"\n}';
  late String requestMsgAll =
      '{\n  "qrType": "CS",\n  "merchantId": "$mid",\n  "terminalId": "$tid",\n  "invoice": "$inv",\n  "amount": "$amount",\n  "csExtExpiryTime" : "$csExtExpiry"\n}';

  String respBackToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXJkTm8iOiI0MTExMTFYWFhYWFgxMTExIiwiY2FyZFRva2VuIjoiIiwibG95YWx0eVBvaW50cyI6bnVsbCwibWVyY2hhbnRJRCI6IjAxNDAxMDAwMDAwMDAwMyIsImludm9pY2VObyI6IjIwMjIwNDI0MDAwMDUxIiwiYW1vdW50IjoxMDAwLjAsIm1vbnRobHlQYXltZW50IjpudWxsLCJ1c2VyRGVmaW5lZDEiOiIiLCJ1c2VyRGVmaW5lZDIiOiIiLCJ1c2VyRGVmaW5lZDMiOiIiLCJ1c2VyRGVmaW5lZDQiOiIiLCJ1c2VyRGVmaW5lZDUiOiIiLCJjdXJyZW5jeUNvZGUiOiJUSEIiLCJyZWN1cnJpbmdVbmlxdWVJRCI6IiIsInRyYW5SZWYiOiI0ODczMjg0IiwicmVmZXJlbmNlTm8iOiI0NTEzMDI5IiwiYXBwcm92YWxDb2RlIjoiNjgzNTYzIiwiZWNpIjoiMDUiLCJ0cmFuc2FjdGlvbkRhdGVUaW1lIjoiMjAyMjA1MDMxNTQ1MTgiLCJhZ2VudENvZGUiOiJUQkFOSyIsImNoYW5uZWxDb2RlIjoiVkkiLCJpc3N1ZXJDb3VudHJ5IjoiVVMiLCJpc3N1ZXJCYW5rIjoiQkFOSyIsImluc3RhbGxtZW50TWVyY2hhbnRBYnNvcmJSYXRlIjpudWxsLCJjYXJkVHlwZSI6IkNSRURJVCIsImlkZW1wb3RlbmN5SUQiOiIiLCJwYXltZW50U2NoZW1lIjoiVkkiLCJyZXNwQ29kZSI6IjAwMDAiLCJyZXNwRGVzYyI6IlN1Y2Nlc3MifQ.g61cW9XFyzOuO3bV47g7Y2vUoyfQp6qMib6mpjR4oZI";
  String? tokenValue;
  String? qrBase64 = "";

  String _result = "";

  final ImagePicker imgPicker = ImagePicker();
  String imagepath = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveImage() async {
    bool success = false;
    try {
      success = (await ImageSave.saveImage(
          base64.decode(context.read<QRModels>().qrPaymentURL),
          "QR Payment.jpg",
          albumName: "QR Payment"))!;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }
    setState(() {
      _result = success ? "Save to album success" : "Save to album failed";
    });
    print(_result);
    StatusAlert.show(context,
        duration: const Duration(seconds: 3),
        title: 'Saved',
        titleOptions: StatusAlertTextConfiguration(
            style: const TextStyle(
                fontFamily: 'SukhumvitSet',
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        subtitle: 'Save to device success',
        subtitleOptions: StatusAlertTextConfiguration(
            style: const TextStyle(
          fontFamily: 'SukhumvitSet',
          fontSize: 20,
        )),
        configuration: const IconConfiguration(icon: Icons.save),
        backgroundColor: Colors.white.withOpacity(0.8));
  }

  Future<String> getAccessToken() async {
    // step 1 : POST request access token
    try {
      final response = await http.post(Uri.parse(endpointURL1),
          headers: {
            'content-type': 'application/json',
            'requestUId': '85230887-e643-4fa4-84b2-4e56709c4ac4',
            'resourceOwnerId': appKey
          },
          body: jsonEncode(jsonDecode(context.read<QRModels>().requestMsgQR1))
          // body: jsonEncode(
          //     {'applicationKey': appKey, 'applicationSecret': secretKey}),
          );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final responseAccessToken = responseJson['data']['accessToken'];
        final tokenType = responseJson['data']['tokenType'];

        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        print('Response: $responseJson');
        print('Response Access Token: $tokenType $responseAccessToken');
        print('respCode: ${responseJson['status']['code']}');
        print('respDesc: ${responseJson['status']['description']}');
        setState(() {
          context.read<QRModels>().accessToken = responseAccessToken;
          context.read<QRModels>().tokenType = tokenType;
          context.read<QRModels>().respCode =
              responseJson['status']['code'].toString();
          context.read<QRModels>().respDesc =
              responseJson['status']['description'];
        });
        setState(() {
          tokenValue = context.read<QRModels>().accessToken;
        });
        print('${context.read<QRModels>().accessToken}');
        print('$tokenValue\n$bid\n$ref1');
      }
      return "";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createQR() async {
    // step 2 : POST request create QR link
    try {
      String tokenValue = context.read<QRModels>().accessToken;
      final response = await http.post(
        Uri.parse(endpointURL2),
        headers: {
          'content-type': 'application/json',
          'requestUId': '7f53b03d-7b9c-42d6-8283-f522ee88ac1c',
          'resourceOwnerId': appKey,
          'authorization': 'Bearer ' + tokenValue
        },
        body: jsonEncode(jsonDecode(context.read<QRModels>().requestMsgQR2)),
      );
      final responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final qrRawData = responseJson['data']['qrRawData'];
        final qrImage = responseJson['data']['qrImage'];

        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        print('Response: $responseJson');
        print('QR Base64 Image: $qrImage');
        print('respCode: ${responseJson['status']['code']}');
        print('respDesc: ${responseJson['status']['description']}');

        setState(() {
          context.read<QRModels>().qrPaymentURL = qrImage;
          context.read<QRModels>().respCode =
              responseJson['status']['code'].toString();
          context.read<QRModels>().respDesc =
              responseJson['status']['description'];
          qrBase64 = context.read<QRModels>().qrPaymentURL;
        });
      } else {
        print('Status Code: ${response.statusCode}');
        print('respCode: ${responseJson['status']['code']}');
        print('respDesc: ${responseJson['status']['description']}');
        setState(() {
          context.read<QRModels>().respCode =
              responseJson['status']['code'].toString();
          context.read<QRModels>().respDesc =
              responseJson['status']['description'];
        });
      }
      return "";
    } catch (e) {
      print('ERROR!!! ${e.toString()}');
      rethrow;
    }
  }

  void responseBackend() async {
    try {
      // JWT Decode
      final respToken = await context.read<QRModels>().responseQR2;
      final jwt2 =
          JWT.verify(respToken, SecretKey(context.read<QRModels>().secretKey));

      print('Response Backend Payload: ${jwt2.payload}');

      setState(() {
        context.read<QRModels>().decodedPayload = jwt2.payload.toString();
      });
    } on JWTError catch (ex) {
      print(ex.message); // ex: invalid signature
    }
  }

  var jwts = JWTServices();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('QR Payment'),
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
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monetization_on), text: "QR30"),
              Tab(icon: Icon(Icons.credit_card), text: "QRCS"),
              Tab(icon: Icon(Icons.qr_code_scanner), text: "QR30 & QRCS"),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/gbg00.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.linearToSrgbGamma())),
          child: const TabBarView(
            children: [
              QR30Payment(), QRCSPayment(), QRAllPayment()],
          ),
        ),
      ),
    );
  }
}
