import 'dart:convert';

import 'package:apitest01/models/jwt_models.dart';
import 'package:apitest01/screens/redirect_payment.dart';
import 'package:apitest01/services/jwt_services.dart';
import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

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
  String appKey = "l7e1a2064e4210450a9801b08a22ee8d27";
  String secretKey = "0dad6869015941d7bf689629af65f6c7";
  String? requestMsg1 =
      '{\n"applicationKey": "l7e1a2064e4210450a9801b08a22ee8d27",\n"applicationSecret": "0dad6869015941d7bf689629af65f6c7"\n}';

  String bid = "178616548291167";
  DateTime now = DateTime.now();
  late String ref1 = DateFormat("yyyyMMddhhmmss").format(now);
  String description = "item demo1";
  double amount = 100.00;
  String currencyCode = "THB";
  String frontendReturnURL = "https://www.2c2p.com";
  String backendReturnURL =
      "https://3861159a-13a9-46f3-977f-78d2cd932679.mock.pstmn.io";

  String respBackToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXJkTm8iOiI0MTExMTFYWFhYWFgxMTExIiwiY2FyZFRva2VuIjoiIiwibG95YWx0eVBvaW50cyI6bnVsbCwibWVyY2hhbnRJRCI6IjAxNDAxMDAwMDAwMDAwMyIsImludm9pY2VObyI6IjIwMjIwNDI0MDAwMDUxIiwiYW1vdW50IjoxMDAwLjAsIm1vbnRobHlQYXltZW50IjpudWxsLCJ1c2VyRGVmaW5lZDEiOiIiLCJ1c2VyRGVmaW5lZDIiOiIiLCJ1c2VyRGVmaW5lZDMiOiIiLCJ1c2VyRGVmaW5lZDQiOiIiLCJ1c2VyRGVmaW5lZDUiOiIiLCJjdXJyZW5jeUNvZGUiOiJUSEIiLCJyZWN1cnJpbmdVbmlxdWVJRCI6IiIsInRyYW5SZWYiOiI0ODczMjg0IiwicmVmZXJlbmNlTm8iOiI0NTEzMDI5IiwiYXBwcm92YWxDb2RlIjoiNjgzNTYzIiwiZWNpIjoiMDUiLCJ0cmFuc2FjdGlvbkRhdGVUaW1lIjoiMjAyMjA1MDMxNTQ1MTgiLCJhZ2VudENvZGUiOiJUQkFOSyIsImNoYW5uZWxDb2RlIjoiVkkiLCJpc3N1ZXJDb3VudHJ5IjoiVVMiLCJpc3N1ZXJCYW5rIjoiQkFOSyIsImluc3RhbGxtZW50TWVyY2hhbnRBYnNvcmJSYXRlIjpudWxsLCJjYXJkVHlwZSI6IkNSRURJVCIsImlkZW1wb3RlbmN5SUQiOiIiLCJwYXltZW50U2NoZW1lIjoiVkkiLCJyZXNwQ29kZSI6IjAwMDAiLCJyZXNwRGVzYyI6IlN1Y2Nlc3MifQ.g61cW9XFyzOuO3bV47g7Y2vUoyfQp6qMib6mpjR4oZI";
  String? tokenValue;

  Future<String> getAccessToken() async {
    // step 1 : POST request access token
    final response = await http.post(
      Uri.parse(endpointURL1),
      headers: {
        'content-type': 'application/json',
        'requestUId': '85230887-e643-4fa4-84b2-4e56709c4ac4',
        'resourceOwnerId': appKey
      },
      body: jsonEncode(
          {'applicationKey': appKey, 'applicationSecret': secretKey}),
    );

    if (response.statusCode == 200) {
      final responseJson = convert.jsonDecode(response.body);
      final responseAccessToken = responseJson['data']['accessToken'];
      final tokenType = responseJson['data']['tokenType'];

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');
      print('Response: $responseJson');
      print('Response Access Token: $tokenType $responseAccessToken');
      print('respCode: ${responseJson['status']['code']}');
      print('respDesc: ${responseJson['status']['description']}');
      setState(() {
        context.read<JWTModels>().paymentToken = responseAccessToken;
        context.read<JWTModels>().respCode =
            responseJson['status']['code'].toString();
        context.read<JWTModels>().respDesc =
            responseJson['status']['description'];
      });
      setState(() {
        tokenValue = context.read<JWTModels>().paymentToken;
      });
    }

    return "";
  }

  Future<String> createQR(tokenValue) async {
    // step 2 : POST request create QR link
    final response = await http.post(
      Uri.parse(endpointURL2),
      headers: {
        'content-type': 'application/json',
        'requestUId': '85230887-e643-4fa4-84b2-4e56709c4ac4',
        'resourceOwnerId': appKey,
        'authorization': 'Bearer$tokenValue'
      },
      body: jsonEncode({
        'qrType': 'PP',
        'ppType': 'BILLERID',
        'ppId': bid,
        'amount': '10.00',
        'ref1': ref1,
        'ref2': 'A',
        'ref3': 'RRN',
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = convert.jsonDecode(response.body);
      final qrRawData = responseJson['data']['qrRawData'];
      final qrImage = responseJson['data']['qrImage'];

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');
      print('Response: $responseJson');
      print('QR Base64 Image: $qrImage');
      print('respCode: ${responseJson['status']['code']}');
      print('respDesc: ${responseJson['status']['description']}');
      setState(() {
        context.read<JWTModels>().decodedPayload = qrImage;
        context.read<JWTModels>().respCode =
            responseJson['status']['code'].toString();
        context.read<JWTModels>().respDesc =
            responseJson['status']['description'];
      });
    }

    return "";
  }

  void responseBackend() async {
    try {
      // JWT Decode
      final respToken = await context.read<JWTModels>().response;
      final jwt2 =
          JWT.verify(respToken, SecretKey(context.read<JWTModels>().secretKey));

      print('Response Backend Payload: ${jwt2.payload}');

      setState(() {
        context.read<JWTModels>().decodedPayload = jwt2.payload.toString();
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
        ),
        body: Container(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Secret Key",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          initialValue: secretKey,
                          maxLines: 2,
                          toolbarOptions: const ToolbarOptions(
                              copy: true,
                              cut: true,
                              paste: true,
                              selectAll: true),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color.fromARGB(255, 36, 35, 35),
                            hintText: "Input secret key",
                          ),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please input secret key.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              context.read<JWTModels>().secretKey = value;
                            });
                          },
                          onSaved: (value) {
                            context.read<JWTModels>().secretKey = value;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Message Request",
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
                              color: Colors.white, fontSize: 13),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please input request message.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              context.read<JWTModels>().requestMsg = value;
                            });
                          },
                          onSaved: (value) {
                            context.read<JWTModels>().requestMsg = value;
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
                          "Respond Body",
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
                            child: context.read<JWTModels>().decodedToken ==
                                        null &&
                                    context.read<JWTModels>().respDesc == null
                                ? const Text(
                                    '{\n  "status": {\n      "code": 1000,\n      "description": "Success"\n  },\n  "data": {\n      "accessToken": "69b04f79-89ed-4e87-a368-88c19c8423cc",\n      "tokenType": "Bearer",\n      "expiresIn": 21600,\n      "expiresAt": 1654301258\n  }\n}',
                                    style: TextStyle(color: Colors.yellow),
                                  )
                                : context.read<JWTModels>().respDesc ==
                                        "Success"
                                    ? RichText(
                                        text: TextSpan(
                                            text:
                                                '{  \n"tokenType": <tokenType>,',
                                            style: const TextStyle(
                                                color: Colors.cyanAccent),
                                            children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '\n"paymentToken": "${context.read<JWTModels>().paymentToken}",',
                                                style: const TextStyle(
                                                    color:
                                                        Colors.orangeAccent)),
                                            TextSpan(
                                                text:
                                                    '\n"respCode": "${context.read<JWTModels>().respCode}",',
                                                style: TextStyle(
                                                    color: Colors.purple[200])),
                                            TextSpan(
                                                text:
                                                    '\n"respDesc": "${context.read<JWTModels>().respDesc}",\n}',
                                                style: const TextStyle(
                                                    color: Colors
                                                        .lightGreenAccent)),
                                          ]))
                                    : context.read<JWTModels>().respCode ==
                                            "9042"
                                        ? const Text(
                                            'Invalid hash value.',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : context.read<JWTModels>().respCode ==
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
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: ElevatedButton(
                              onPressed: () async {
                                await createQR(
                                    context.read<JWTModels>().paymentToken);
                              },
                              child: const Text(
                                "POST Request Create QR Code",
                              )),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Response",
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
                            child: Text(
                              context.read<JWTModels>().decodedToken == null &&
                                      context.read<JWTModels>().respDesc == null
                                  ? '{  \n"payload": "<Response token from POST request>"\n}'
                                  : context.read<JWTModels>().respDesc ==
                                          "Success"
                                      ? '{  \n"payload": "${context.read<JWTModels>().decodedToken}"\n}'
                                      : '{  \n"respCode": "${context.read<JWTModels>().respCode}"\n"respDesc": "${context.read<JWTModels>().respDesc}"\n}',
                              style: const TextStyle(
                                  color: Colors.yellow, fontSize: 10),
                            )),
                        const SizedBox(height: 5),
                        const Divider(
                          thickness: 1,
                        ),
                        const Text(
                          "After payment successful",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Backend Response Token",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          initialValue: respBackToken,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color.fromARGB(255, 244, 245, 198),
                            hintText:
                                "Input response token you get from your server",
                          ),
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 10),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please input response token.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              context.read<JWTModels>().response = value;
                            });
                          },
                          onSaved: (value) {
                            context.read<JWTModels>().response = value;
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
                                  responseBackend();
                                }
                              },
                              child: const Text(
                                "Decode Response Backend Notification",
                              )),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                            ),
                            child: Text(
                              context
                                  .read<JWTModels>()
                                  .decodedPayload
                                  .toString(),
                              style: const TextStyle(color: Colors.cyanAccent),
                            )),
                        const SizedBox(height: 10),
                      ]),
                )),
          ),
        ));
  }
}

class Site {
  const Site(this.site);
  final String site;
}

class MsgRequest {
  String merchantId;
  String invoiceNo;
  String description;
  double amount;
  String currencyCode;

  MsgRequest(this.merchantId, this.invoiceNo, this.description,
      this.currencyCode, this.amount);
  Map<String, dynamic> toJson() => {
        "merchantID": merchantId,
        "invoiceNo": invoiceNo,
        "description": description,
        "amount": amount,
        "currencyCode": currencyCode,
      };
}
