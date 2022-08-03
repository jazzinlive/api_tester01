import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:apitest01/services/jwt_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/paywise_models.dart';

class Paywise extends StatefulWidget {
  const Paywise({Key? key}) : super(key: key);

  @override
  State<Paywise> createState() => _PaywiseState();
}

class _PaywiseState extends State<Paywise> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pasteValue = '';

  String endpointURL1 =
      "https://api-sandbox.partners.scb/partners/sandbox/v1/oauth/token";
  String endpointURL2 =
      "https://api-sandbox.partners.scb/partners/sandbox/v3/deeplink/transactions";
  String appKey = "l7e1a2064e4210450a9801b08a22ee8d27";
  String secretKey = "0dad6869015941d7bf689629af65f6c7";
  late String requestMsg1 =
      '{\n"applicationKey": "$appKey",\n"applicationSecret": "$secretKey"\n}';

  String bid = "086655431885412";
  String mid = "396492940773632";
  String tid = "950030458883012";
  DateTime now = DateTime.now();
  late String ref1 = DateFormat("yyyyMMddhhmmss").format(now);
  late String inv = DateFormat("yyyyMMddhhmmss").format(now);
  late String description = "item demo1";
  late double amount = 10.00;
  String csExtExpiry = "1800";
  String frontendReturnURL = "https://developer.scb";
  String backendReturnURL =
      "https://16fb0121-3d49-4b81-acbd-3c1329f8f3f0.mock.pstmn.io";
  late String requestMsg2 =
      '{\n  "transactionType": "PURCHASE",\n  "transactionSubType": ["BP", "CCFA", "CCIPP"],\n  "sessionValidityPeriod": 1800,\n  "billPayment": {\n    "paymentAmount": $amount,\n    "accountTo": "$bid",\n    "ref1": "$ref1",\n    "ref2": "TESTPWBP",\n    "ref3": "RRN$ref1"\n  },\n  "creditCardFullAmount": {\n    "merchantId": "$mid",\n    "terminalId": "$tid",\n    "orderReference": "$inv",\n    "paymentAmount": $amount\n  },\n  "installmentPaymentPlan": {\n    "merchantId": "$mid",\n    "terminalId": "$tid",\n    "orderReference": "IPP$inv",\n    "paymentAmount": $amount,\n    "tenor": "12",\n    "ippType": "3",\n    "prodCode": "1001"\n  },\n  "merchantMetaData": {\n    "callbackUrl": "$backendReturnURL",\n    "merchantInfo": {\n      "name": "API Tester"\n    }\n  }\n}';

  String respBackToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXJkTm8iOiI0MTExMTFYWFhYWFgxMTExIiwiY2FyZFRva2VuIjoiIiwibG95YWx0eVBvaW50cyI6bnVsbCwibWVyY2hhbnRJRCI6IjAxNDAxMDAwMDAwMDAwMyIsImludm9pY2VObyI6IjIwMjIwNDI0MDAwMDUxIiwiYW1vdW50IjoxMDAwLjAsIm1vbnRobHlQYXltZW50IjpudWxsLCJ1c2VyRGVmaW5lZDEiOiIiLCJ1c2VyRGVmaW5lZDIiOiIiLCJ1c2VyRGVmaW5lZDMiOiIiLCJ1c2VyRGVmaW5lZDQiOiIiLCJ1c2VyRGVmaW5lZDUiOiIiLCJjdXJyZW5jeUNvZGUiOiJUSEIiLCJyZWN1cnJpbmdVbmlxdWVJRCI6IiIsInRyYW5SZWYiOiI0ODczMjg0IiwicmVmZXJlbmNlTm8iOiI0NTEzMDI5IiwiYXBwcm92YWxDb2RlIjoiNjgzNTYzIiwiZWNpIjoiMDUiLCJ0cmFuc2FjdGlvbkRhdGVUaW1lIjoiMjAyMjA1MDMxNTQ1MTgiLCJhZ2VudENvZGUiOiJUQkFOSyIsImNoYW5uZWxDb2RlIjoiVkkiLCJpc3N1ZXJDb3VudHJ5IjoiVVMiLCJpc3N1ZXJCYW5rIjoiQkFOSyIsImluc3RhbGxtZW50TWVyY2hhbnRBYnNvcmJSYXRlIjpudWxsLCJjYXJkVHlwZSI6IkNSRURJVCIsImlkZW1wb3RlbmN5SUQiOiIiLCJwYXltZW50U2NoZW1lIjoiVkkiLCJyZXNwQ29kZSI6IjAwMDAiLCJyZXNwRGVzYyI6IlN1Y2Nlc3MifQ.g61cW9XFyzOuO3bV47g7Y2vUoyfQp6qMib6mpjR4oZI";
  String? tokenValue;
  late final Uri _deeplinkUrl =
      Uri.parse(context.read<PaywiseModels>().deeplinkUrl);
  // "https://info.scb.co.th/scbeasy/easy_app_link.html?URI=" +
  //     context.read<PaywiseModels>().deeplinkUrl);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL() async {
    if (await canLaunchUrlString(
      _deeplinkUrl.toString(),
    )) {
      launchUrlString(_deeplinkUrl.toString());
    }

    print("redirect to deeplink");
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
          body: jsonEncode(
              jsonDecode(context.read<PaywiseModels>().requestMsgQR1)));
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
          context.read<PaywiseModels>().accessToken = responseAccessToken;
          context.read<PaywiseModels>().tokenType = tokenType;
          context.read<PaywiseModels>().respCode =
              responseJson['status']['code'].toString();
          context.read<PaywiseModels>().respDesc =
              responseJson['status']['description'];
        });
        setState(() {
          tokenValue = context.read<PaywiseModels>().accessToken;
        });
        print('${context.read<PaywiseModels>().accessToken}');
        print('$tokenValue\n$bid\n$ref1');
      }
      return "";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createDeeplink() async {
    // step 2 : POST request create Deeplink
    try {
      String tokenValue = context.read<PaywiseModels>().accessToken;
      final response = await http.post(
        Uri.parse(endpointURL2),
        headers: {
          'content-type': 'application/json',
          'requestUId': '7f53b03d-7b9c-42d6-8283-f522ee88ac1c',
          'resourceOwnerId': appKey,
          'authorization': 'Bearer ' + tokenValue,
          'channel': 'scbeasy'
        },
        body:
            jsonEncode(jsonDecode(context.read<PaywiseModels>().requestMsgQR2)),
      );
      final responseJson = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final transactionId = responseJson['data']['transactionId'];
        final deeplinkUrl = responseJson['data']['deeplinkUrl'];

        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        print('Response: $responseJson');
        print('Deeplink Url: $deeplinkUrl');
        print('respCode: ${responseJson['status']['code']}');
        print('respDesc: ${responseJson['status']['description']}');

        setState(() {
          context.read<PaywiseModels>().deeplinkUrl = deeplinkUrl;
          context.read<PaywiseModels>().respCode =
              responseJson['status']['code'].toString();
          context.read<PaywiseModels>().respDesc =
              responseJson['status']['description'];
        });
      } else {
        print('Status Code: ${response.statusCode}');
        print('respCode: ${responseJson['status']['code']}');
        print('respDesc: ${responseJson['status']['description']}');
        setState(() {
          context.read<PaywiseModels>().respCode =
              responseJson['status']['code'].toString();
          context.read<PaywiseModels>().respDesc =
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
      final respToken = await context.read<PaywiseModels>().responseQR2;
      final jwt2 = JWT.verify(
          respToken, SecretKey(context.read<PaywiseModels>().secretKey));

      print('Response Backend Payload: ${jwt2.payload}');

      setState(() {
        context.read<PaywiseModels>().decodedPayload = jwt2.payload.toString();
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
        appBar: AppBar(
          title: const Text('Paywise Deeplink'),
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
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2));
            setState(() {});
          },
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/gbg01.jpg'),
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
                                context.read<PaywiseModels>().requestMsgQR1 =
                                    value;
                              });
                            },
                            onSaved: (value) {
                              context.read<PaywiseModels>().requestMsgQR1 =
                                  value;
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
                              child: context
                                              .read<PaywiseModels>()
                                              .accessToken ==
                                          null &&
                                      context.read<PaywiseModels>().respDesc ==
                                          null
                                  ? const Text(
                                      '{\n  "status": {\n      "code": <Status Code>,\n      "description": <Status Description>\n  },\n  "data": {\n      "accessToken": <Access Token>,\n      "tokenType": <Token Type>,\n      "expiresIn": <...>,\n      "expiresAt": <...>\n  }\n}',
                                      style: TextStyle(color: Colors.yellow),
                                    )
                                  : context.read<PaywiseModels>().accessToken !=
                                          null
                                      ? RichText(
                                          text: TextSpan(
                                              text:
                                                  '{\n  "accessToken": "${context.read<PaywiseModels>().accessToken}",',
                                              style: const TextStyle(
                                                  color: Colors.cyanAccent,
                                                  fontFamily: 'SukhumvitSet'),
                                              children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      '\n  "tokenType": "${context.read<PaywiseModels>().tokenType}",',
                                                  style: const TextStyle(
                                                      color:
                                                          Colors.orangeAccent,
                                                      fontFamily:
                                                          'SukhumvitSet')),
                                              TextSpan(
                                                  text:
                                                      '\n  "respCode": "${context.read<PaywiseModels>().respCode}",',
                                                  style: TextStyle(
                                                      color: Colors.purple[200],
                                                      fontFamily:
                                                          'SukhumvitSet')),
                                              TextSpan(
                                                  text:
                                                      '\n  "respDesc": "${context.read<PaywiseModels>().respDesc}",\n}',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .lightGreenAccent,
                                                      fontFamily:
                                                          'SukhumvitSet')),
                                            ]))
                                      : context
                                                  .read<PaywiseModels>()
                                                  .respCode ==
                                              "9042"
                                          ? const Text(
                                              'Invalid hash value.',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : context
                                                      .read<PaywiseModels>()
                                                      .respCode ==
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
                            "Message Request - Deeplink",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 16,
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
                                context.read<PaywiseModels>().requestMsgQR2 =
                                    value;
                              });
                            },
                            onSaved: (value) {
                              context.read<PaywiseModels>().requestMsgQR2 =
                                  value;
                            },
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await createDeeplink();
                                },
                                child: const Text(
                                  "POST Request Create Deeplink",
                                )),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Response Body - Deeplink",
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
                              child: context.read<PaywiseModels>().respCode ==
                                          null &&
                                      context.read<PaywiseModels>().respDesc ==
                                          null
                                  ? const Text(
                                      '{\n  "deeplinkUrl": "<Get Deeplink from POST request>"\n}',
                                      style: TextStyle(color: Colors.yellow),
                                    )
                                  : context.read<PaywiseModels>().deeplinkUrl !=
                                          null
                                      ? Column(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text:
                                                      '"respCode": "${context.read<PaywiseModels>().respCode}",',
                                                  style: const TextStyle(
                                                    color: Colors.cyanAccent,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            '\n"respDesc": "${context.read<PaywiseModels>().respDesc}",',
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .orangeAccent,
                                                            fontFamily:
                                                                'SukhumvitSet')),
                                                    TextSpan(
                                                      text:
                                                          '\n"deeplinkUrl": "${context.read<PaywiseModels>().deeplinkUrl}"',
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .lightGreenAccent,
                                                          fontFamily:
                                                              'SukhumvitSet'),
                                                    ),
                                                  ]),
                                              //overflow: TextOverflow.ellipsis,
                                              //maxLines: 5,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                _launchURL();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              6,
                                                      height: 50,
                                                      child: Image.asset(
                                                        "assets/scbez.png",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "Redirect to SCB Easy App",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : context
                                                  .read<PaywiseModels>()
                                                  .respCode ==
                                              "9042"
                                          ? const Text(
                                              'Invalid hash value.',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : context
                                                      .read<PaywiseModels>()
                                                      .respCode ==
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
