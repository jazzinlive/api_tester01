import 'dart:async';
import 'dart:convert';

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

class QRCSPayment extends StatefulWidget {
  const QRCSPayment({Key? key}) : super(key: key);

  @override
  State<QRCSPayment> createState() => _QRCSPaymentState();
}

class _QRCSPaymentState extends State<QRCSPayment> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pasteValue = '';

  String endpointURL1 =
      "https://api-sandbox.partners.scb/partners/sandbox/v1/oauth/token";
  String endpointURL2 =
      "https://api-sandbox.partners.scb/partners/sandbox/v1/payment/qrcode/create";
  String appKey = "l7e1a2064e4210450a9801b08a22ee8d27";
  String secretKey = "0dad6869015941d7bf689629af65f6c7";
  late String requestMsg1 =
      '{\n"applicationKey": "$appKey",\n"applicationSecret": "$secretKey"\n}';

  String bid = "086655431885412";
  String mid = "396492940773632";
  String tid = "950030458883012";
  DateTime now = DateTime.now();
  late String ref1 = "QRCS" + DateFormat("yyyyMMddhhmmss").format(now);
  late String inv = DateFormat("yyyyMMddhhmmss").format(now);
  late String description = "item demo1";
  late double amount = 10.00;
  String csExtExpiry = "1800";
  String frontendReturnURL = "https://developer.scb";
  String backendReturnURL =
      "https://16fb0121-3d49-4b81-acbd-3c1329f8f3f0.mock.pstmn.io";
  late String requestMsg2 =
      '{\n  "qrType": "CS",\n  "merchantId": "$mid",\n  "terminalId": "$tid",\n  "invoice": "QRCS$inv",\n  "amount": "$amount",\n  "csExtExpiryTime" : "$csExtExpiry"\n}';

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
        print('ResponseBody: ${response.body}');
        print('ResponseJson Object: $responseJson');
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
          context.read<QRModels>().expireIn =
              responseJson['status']['expiresIn'].toString();
          context.read<QRModels>().expireAt =
              responseJson['status']['expiresAt'].toString();
        });
        setState(() {
          tokenValue = context.read<QRModels>().accessToken;
        });
        print('Access Token in Model: ${context.read<QRModels>().accessToken}');
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
        print('Response Body: ${response.body}');
        print('Response Json Object: $responseJson');
        print('respCode: ${responseJson['status']['code']}');
        print('respDesc: ${responseJson['status']['description']}');

        setState(() {
          context.read<QRModels>().responseQR2 = response.body;
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
    return Scaffold(
        key: _scaffoldKey,
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              // selectedValue = qrType[0];
            });
          },
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/gbg00.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.linearToSrgbGamma())),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Message Request - Authentication",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 6,
                            initialValue: requestMsg1,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromARGB(255, 31, 31, 30),
                              hintText: "Input message request",
                            ),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input request message.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                context.read<QRModels>().requestMsgQR1 = value;
                              });
                            },
                            onSaved: (value) {
                              context.read<QRModels>().requestMsgQR1 = value;
                            },
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    await getAccessToken();
                                  }
                                },
                                child: const Text(
                                  "POST Request Access Token",
                                )),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Respond Body - Authentication",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                              ),
                              child: context.read<QRModels>().accessToken ==
                                          null &&
                                      context.read<QRModels>().respDesc == null
                                  ? const Text(
                                      '{\n  "status": {\n      "code": <Status Code>,\n      "description": <Status Description>\n  },\n  "data": {\n      "accessToken": <Access Token>,\n      "tokenType": <Token Type>,\n      "expiresIn": <...>,\n      "expiresAt": <...>\n  }\n}',
                                      style: TextStyle(color: Colors.yellow),
                                    )
                                  : context.read<QRModels>().respDesc ==
                                          "Success"
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  '{\n  "accessToken": "${context.read<QRModels>().accessToken}",',
                                              style: const TextStyle(
                                                  color: Colors.cyanAccent,
                                                  fontFamily: 'SukhumvitSet'),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      '\n  "tokenType": "${context.read<QRModels>().tokenType}",',
                                                  style: const TextStyle(
                                                      color:
                                                          Colors.orangeAccent,
                                                      fontFamily:
                                                          'SukhumvitSet')),
                                              TextSpan(
                                                  text:
                                                      '\n  "respCode": "${context.read<QRModels>().respCode}",',
                                                  style: TextStyle(
                                                      color: Colors.purple[200],
                                                      fontFamily:
                                                          'SukhumvitSet')),
                                              TextSpan(
                                                  text:
                                                      '\n  "respDesc": "${context.read<QRModels>().respDesc}",\n}',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .lightGreenAccent,
                                                      fontFamily:
                                                          'SukhumvitSet')),
                                            ]))
                                      : context.read<QRModels>().respCode ==
                                              "9042"
                                          ? const Text(
                                              'Invalid hash value.',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : context.read<QRModels>().respCode ==
                                                  "9007"
                                              ? const Text(
                                                  'Merchant id is not found.',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : const Text(
                                                  'Decode not success.',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                          const SizedBox(height: 10),
                          const Divider(),
                          const Text(
                            "Message Request - Create QR",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 8,
                            initialValue: requestMsg2,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color.fromARGB(255, 31, 31, 30),
                              hintText: "Input message request",
                            ),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input request message.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                context.read<QRModels>().requestMsgQR2 = value;
                              });
                            },
                            onSaved: (value) {
                              context.read<QRModels>().requestMsgQR2 = value;
                            },
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await createQR();
                                },
                                child: const Text(
                                  "POST Request Create QR Code",
                                )),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Response Body - Create QR",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                              ),
                              child: context.read<QRModels>().respCode ==
                                          null &&
                                      context.read<QRModels>().respDesc == null
                                  ? const Text(
                                      '{\n  "qrImage": "<QR Image from POST request>"\n}',
                                      style: TextStyle(color: Colors.yellow),
                                    )
                                  : context.read<QRModels>().qrPaymentURL !=
                                          null
                                      ? Column(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text:
                                                      '"respCode": "${context.read<QRModels>().respCode}",',
                                                  style: const TextStyle(
                                                      color: Colors.cyanAccent,
                                                      fontFamily:
                                                          'SukhumvitSet'),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            '\n"respDesc": "${context.read<QRModels>().respDesc}",',
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .orangeAccent,
                                                            fontFamily:
                                                                'SukhumvitSet')),
                                                    TextSpan(
                                                      text:
                                                          '\n"qrImage": "${context.read<QRModels>().qrPaymentURL}"',
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .lightGreenAccent,
                                                          fontFamily:
                                                              'SukhumvitSet'),
                                                    ),
                                                  ]),
                                              overflow: TextOverflow.ellipsis,
                                              //maxLines: 5,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Card(
                                                child: Image.memory(
                                                  base64.decode(context
                                                      .read<QRModels>()
                                                      .qrPaymentURL),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: _saveImage,
                                              child: const Text(
                                                  "Click to save to album"),
                                            ),
                                          ],
                                        )
                                      : context.read<QRModels>().respCode ==
                                              "9042"
                                          ? const Text(
                                              'Invalid hash value.',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : context.read<QRModels>().respCode ==
                                                  "9007"
                                              ? const Text(
                                                  'Merchant id is not found.',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              : const Text(
                                                  'Decode not success.',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                          const SizedBox(height: 10),
                        ]),
                  )),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }
}
