import 'dart:convert';

import 'package:apitest01/models/jwt_models.dart';
import 'package:apitest01/screens/redirect_payment.dart';
import 'package:apitest01/services/jwt_services.dart';
import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class GetPaymentToken extends StatefulWidget {
  const GetPaymentToken({Key? key}) : super(key: key);

  @override
  State<GetPaymentToken> createState() => _GetPaymentTokenState();
}

class _GetPaymentTokenState extends State<GetPaymentToken> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String pasteValue = '';

  List<Site> sites = <Site>[const Site("DEMO"), const Site("Production")];
  late Site selectedSite;

  String dropdownValue = "DEMO";
  String holder = "";
  List<String> siteType = [
    'DEMO',
    'Production',
  ];
  String? endpointURL = "https://sandbox-pgw.2c2p.com/payment/4.1/paymentToken";

  String requestMsg =
      '{"merchantID": "JT04","invoiceNo": "20220424","description": "Test item","amount": 2000.00,"currencyCode": "THB"}';

  dynamic requestMsgJson = {
    "merchantID": "JT04",
    "invoiceNo": "20220424",
    "description": "Test item",
    "amount": 2000.00,
    "currencyCode": "THB"
  };

  MsgRequest msgRequest =
      MsgRequest('JT04', '2022042400005', 'item 1', 'THB', 12000);

  String? tokenValue;
  String secretKey =
      "CD229682D3297390B9F66FF4020B758F4A5E625AF4992E5D75D311D6458B38E2";

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  Future<String> encodePayloadJWT() async {
    // step 1
    Map<String, dynamic> newObj =
        jsonDecode(context.read<JWTModels>().requestMsg);
    print(newObj);

    msgRequest = MsgRequest(newObj['merchantID'], newObj['invoiceNo'],
        newObj['description'], newObj['currencyCode'], newObj['amount']);
    final jwt = JWT(
      newObj,
      //msgRequest.toJson(),
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );

    final token = jwt.sign(SecretKey(context.read<JWTModels>().secretKey));
    //print(requestMsgJson);
    print(context.read<JWTModels>().secretKey);
    print(msgRequest.toJson());
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

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${responseBody}');

        if (responseBody == null) {
          print(responseJson['respDesc']);
          setState(() {
            context.read<JWTModels>().respCode = responseJson['respCode'];
            context.read<JWTModels>().respDesc = responseJson['respDesc'];
          });
          // context.read<JWTModels>().respCode = responseJson['respCode'];
          // context.read<JWTModels>().respDesc = responseJson['respDesc'];
          final snackBar = SnackBar(
            content: Text(responseJson['respDesc']),
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
          //_scaffoldKey.currentState!.showSnackBar(snackBar);
          return "";
        }
        context.read<JWTModels>().decodedToken = responseBody;

        try {
          // JWT Decode
          final jwt = JWT.verify(
              responseBody, SecretKey(context.read<JWTModels>().secretKey));

          print('Response Body: ${jwt.payload}');

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
        } on JWTExpiredError {
          print('jwt expired');
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

  var jwts = JWTServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          fillColor: Color.fromARGB(255, 244, 245, 198),
                          hintText: "Input secret key",
                        ),
                        style: TextStyle(color: Colors.red[900]),
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
                        maxLines: 5,
                        initialValue: requestMsg,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color.fromARGB(255, 244, 245, 198),
                          hintText: "Input message request",
                        ),
                        style: TextStyle(color: Colors.red[900]),
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
                                style: const TextStyle(color: Colors.yellow),
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
                                style: const TextStyle(color: Colors.yellow),
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
                        icon: const Icon(Icons.arrow_drop_down),
                        underline:
                            Container(height: 2, color: Colors.transparent),
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        onChanged: (data) {
                          setState(() {
                            dropdownValue = data!;
                            if (data == "DEMO") {
                              endpointURL =
                                  'https://sandbox-pgw.2c2p.com/payment/4.1/paymentToken';
                            } else {
                              endpointURL =
                                  'https://pgw.2c2p.com/payment/4.1/paymentToken';
                            }
                          });
                        },
                        items: siteType
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
                                    //     &&
                                    // context.read<JWTModels>().respCode ==
                                    //     0000
                                    ? '{  \n"payload": "${context.read<JWTModels>().decodedToken}"\n}'
                                    : '{  \n"respCode": "${context.read<JWTModels>().respCode}"\n"respDesc": "${context.read<JWTModels>().respDesc}"\n}',
                            style: const TextStyle(color: Colors.yellow),
                          )),
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
                    ]),
              )),
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
