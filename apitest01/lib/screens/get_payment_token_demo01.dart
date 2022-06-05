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

class GetPaymentTokenDemo01 extends StatefulWidget {
  const GetPaymentTokenDemo01({Key? key}) : super(key: key);

  @override
  State<GetPaymentTokenDemo01> createState() => _GetPaymentTokenDemo01State();
}

class _GetPaymentTokenDemo01State extends State<GetPaymentTokenDemo01> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pasteValue = '';

  // List<Site> sites = <Site>[const Site("DEMO"), const Site("Production")];
  // late Site selectedSite;

  String dropdownValue = "DEMO";
  List<String> siteType = [
    'DEMO',
    'Production',
  ];
  String? endpointURL = "https://sandbox-pgw.2c2p.com/payment/4.1/paymentToken";
  String secretKey =
      "7E097B0BEC9E21F61388FF80500A8E0EA926875C55A2C33497636FB1242A06A5";
  DateTime now = DateTime.now();
  late String invNo = DateFormat("yyyyMMddhhmmss").format(now);
  late String requestMsg =
      '{\n"merchantID": "014010000000003",\n"invoiceNo": "$invNo",\n"description": "Test item demo01",\n"amount": 100.00,\n"currencyCode": "THB",\n"frontendReturnUrl": "https://www.2c2p.com",\n"backendReturnUrl": "https://3861159a-13a9-46f3-977f-78d2cd932679.mock.pstmn.io"\n}';

  String respBackToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXJkTm8iOiI0MTExMTFYWFhYWFgxMTExIiwiY2FyZFRva2VuIjoiIiwibG95YWx0eVBvaW50cyI6bnVsbCwibWVyY2hhbnRJRCI6IjAxNDAxMDAwMDAwMDAwMyIsImludm9pY2VObyI6IjIwMjIwNDI0MDAwMDUxIiwiYW1vdW50IjoxMDAwLjAsIm1vbnRobHlQYXltZW50IjpudWxsLCJ1c2VyRGVmaW5lZDEiOiIiLCJ1c2VyRGVmaW5lZDIiOiIiLCJ1c2VyRGVmaW5lZDMiOiIiLCJ1c2VyRGVmaW5lZDQiOiIiLCJ1c2VyRGVmaW5lZDUiOiIiLCJjdXJyZW5jeUNvZGUiOiJUSEIiLCJyZWN1cnJpbmdVbmlxdWVJRCI6IiIsInRyYW5SZWYiOiI0ODczMjg0IiwicmVmZXJlbmNlTm8iOiI0NTEzMDI5IiwiYXBwcm92YWxDb2RlIjoiNjgzNTYzIiwiZWNpIjoiMDUiLCJ0cmFuc2FjdGlvbkRhdGVUaW1lIjoiMjAyMjA1MDMxNTQ1MTgiLCJhZ2VudENvZGUiOiJUQkFOSyIsImNoYW5uZWxDb2RlIjoiVkkiLCJpc3N1ZXJDb3VudHJ5IjoiVVMiLCJpc3N1ZXJCYW5rIjoiQkFOSyIsImluc3RhbGxtZW50TWVyY2hhbnRBYnNvcmJSYXRlIjpudWxsLCJjYXJkVHlwZSI6IkNSRURJVCIsImlkZW1wb3RlbmN5SUQiOiIiLCJwYXltZW50U2NoZW1lIjoiVkkiLCJyZXNwQ29kZSI6IjAwMDAiLCJyZXNwRGVzYyI6IlN1Y2Nlc3MifQ.g61cW9XFyzOuO3bV47g7Y2vUoyfQp6qMib6mpjR4oZI";
  String? tokenValue;
  


  Future<String> encodePayloadJWT() async {
    // step 1
    Map<String, dynamic> newObj =
        jsonDecode(context.read<JWTModels>().requestMsg);
    print(newObj);

    // msgRequest = MsgRequest(newObj['merchantID'], newObj['invoiceNo'],
    //     newObj['description'], newObj['currencyCode'], newObj['amount']);
    final jwt = JWT(
      newObj,
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );

    final token = jwt.sign(SecretKey(context.read<JWTModels>().secretKey));

    print(context.read<JWTModels>().secretKey);
    //print(msgRequest.toJson());
    print(jwt.payload);
    print('Signed token: $token\n');
    context.read<JWTModels>().encodedToken = token;
    setState(() {
      tokenValue = context.read<JWTModels>().encodedToken;
    });

    return token;
  }

  Future<String> requestPaymentToken(String token) async {
    // step 3
    try {
      final response = await http.post(
        Uri.parse(endpointURL!),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'payload': token,
        }),
      );

      if (response.statusCode == 200) {
        // step 4
        final responseJson = convert.jsonDecode(response.body);
        final responseBody = responseJson['payload'];

        print('Response: ${response.body}');
        print('Status Code: ${response.statusCode}');
        print('Response Token: $responseBody');

        if (responseBody == null) {
          print(responseJson['respDesc']);
          setState(() {
            context.read<JWTModels>().respCode = responseJson['respCode'];
            context.read<JWTModels>().respDesc = responseJson['respDesc'];
          });

          // final snackBar = SnackBar(
          //   content: Text(responseJson['respDesc']),
          //   duration: const Duration(seconds: 10),
          //   action: SnackBarAction(
          //     label: 'Close',
          //     onPressed: () {
          //       // Some code to undo the change.
          //       Navigator.pop(context);
          //     },
          //   ),
          // );
          // ignore: deprecated_member_use
          //_scaffoldKey.currentState!.showSnackBar(snackBar);
          return "";
        }
        context.read<JWTModels>().decodedToken = responseBody;

        try {
          // JWT Decode
          final jwt = JWT.verify(
              responseBody, SecretKey(context.read<JWTModels>().secretKey));

          print('Response Payload: ${jwt.payload}');

          setState(() {
            context.read<JWTModels>().decodedPayload = jwt.payload.toString();

            final webPaymentUrl = jwt.payload['webPaymentUrl'];
            context.read<JWTModels>().webPaymentURL =
                jwt.payload['webPaymentUrl'].toString();

            final paymentToken = jwt.payload['paymentToken'];
            context.read<JWTModels>().paymentToken =
                jwt.payload['paymentToken'].toString();

            final respCode = jwt.payload['respCode'];
            context.read<JWTModels>().respCode =
                jwt.payload['respCode'].toString();

            final respDesc = jwt.payload['respDesc'];
            context.read<JWTModels>().respDesc =
                jwt.payload['respDesc'].toString();

            if (respCode == "0000") {
              return webPaymentUrl;
            }
          });
        } on JWTError catch (ex) {
          print(ex.message); // ex: invalid signature
        }
      }

      return "0";
    } catch (ex) {
      print('exception: ' + ex.toString());
      final snackBar = SnackBar(
        content: Text(ex.toString()),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Some code to undo the change.
            Navigator.pop(context);
          },
        ),
      );
      // ignore: deprecated_member_use
      _scaffoldKey.currentState!.showSnackBar(snackBar);
    }

    return "1";
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
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: SingleChildScrollView(
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
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
                        maxLines: 12,
                        initialValue: requestMsg,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color.fromARGB(255, 36, 35, 35),
                          hintText: "Input message request",
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input request message payload.';
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
                                await encodePayloadJWT();
                              }
                            },
                            child: const Text(
                              "JWT Encode",
                            )),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Encoded",
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
                        child: context.read<JWTModels>().encodedToken == null
                            ? const Text(
                                'Tap JWT Encode to get token',
                                style: TextStyle(color: Colors.yellow),
                              )
                            : Text(
                                context.read<JWTModels>().encodedToken ?? "",
                                style: const TextStyle(
                                    color: Colors.yellow, fontSize: 10),
                              ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Request Body",
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
                        child: context.read<JWTModels>().encodedToken == null
                            ? const Text(
                                '{  \n"payload": "<Encoded token from above>"\n}',
                                style: TextStyle(color: Colors.yellow),
                              )
                            : Text(
                                '{  \n"payload": "${context.read<JWTModels>().encodedToken}"\n}',
                                style: const TextStyle(
                                    color: Colors.yellow, fontSize: 10),
                              ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Site",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      DropdownButton<String>(
                        value: dropdownValue,
                        items: siteType
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down),
                        underline:
                            Container(height: 2, color: Colors.transparent),
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            if (newValue == "DEMO") {
                              endpointURL =
                                  'https://sandbox-pgw.2c2p.com/payment/4.1/paymentToken';
                            } else {
                              endpointURL =
                                  'https://pgw.2c2p.com/payment/4.1/paymentToken';
                            }
                          });
                        },
                        
                      ),
                      Text(endpointURL!,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.teal)),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: ElevatedButton(
                            onPressed: () async {
                              await requestPaymentToken(
                                  context.read<JWTModels>().encodedToken);
                            },
                            child: const Text(
                              "POST Request & Decode JWT",
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
                      const Text(
                        "Decoded",
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
                                          .read<JWTModels>()
                                          .decodedToken ==
                                      null &&
                                  context.read<JWTModels>().respDesc == null
                              ? const Text(
                                  '{  \n"webPaymentURL": "<webPaymentToken>"\n"paymentToken": "<paymentToken>"\n"respCode": "<respCode>"\n"respDesc": "<respDesc>"\n}',
                                  style: TextStyle(color: Colors.yellow),
                                )
                              : context.read<JWTModels>().respDesc == "Success"
                                  ? RichText(
                                      text: TextSpan(
                                          text:
                                              '{  \n"webPaymentURL": "${context.read<JWTModels>().webPaymentURL}",',
                                          style: const TextStyle(
                                              color: Colors.cyanAccent),
                                          children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '\n"paymentToken": "${context.read<JWTModels>().paymentToken}",',
                                              style: const TextStyle(
                                                  color: Colors.orangeAccent)),
                                          TextSpan(
                                              text:
                                                  '\n"respCode": "${context.read<JWTModels>().respCode}",',
                                              style: TextStyle(
                                                  color: Colors.purple[200])),
                                          TextSpan(
                                              text:
                                                  '\n"respDesc": "${context.read<JWTModels>().respDesc}",\n}',
                                              style: const TextStyle(
                                                  color:
                                                      Colors.lightGreenAccent)),
                                        ]))
                                  : context.read<JWTModels>().respCode == "9042"
                                      ? const Text(
                                          'Invalid hash value.',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : context.read<JWTModels>().respCode ==
                                              "9007"
                                          ? const Text(
                                              'Merchant id is not found.',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : const Text(
                                              'Decode not success.',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: context.read<JWTModels>().respDesc == "Success"
                              ? ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RedirectPaymentPage(context
                                                    .read<JWTModels>()
                                                    .webPaymentURL)));
                                  },
                                  child: const Text(
                                    "Go to 2c2p payment page",
                                  ))
                              : const Text(
                                  "Please recheck your request message to get valid payment link button.",
                                  style: TextStyle(color: Colors.red),
                                )),
                      const SizedBox(height: 10),
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
                        style: TextStyle(color: Colors.red[900], fontSize: 10),
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
                            context.read<JWTModels>().decodedPayload.toString(),
                            style: const TextStyle(color: Colors.cyanAccent),
                          )),
                      const SizedBox(height: 10),
                    ]),
              )),
        ));
  }
}

// class Site {
//   const Site(this.site);
//   final String site;
// }

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
