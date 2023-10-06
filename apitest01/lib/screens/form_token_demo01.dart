// ignore_for_file: unused_local_variable

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

class FormTokenDemo01 extends StatefulWidget {
  const FormTokenDemo01({Key? key}) : super(key: key);

  @override
  State<FormTokenDemo01> createState() => _FormTokenDemo01State();
}

class _FormTokenDemo01State extends State<FormTokenDemo01> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  String pasteValue = '';

  String dropdownValue = "DEMO";
  String holder = "";
  List<String> siteType = [
    'DEMO',
    'Production',
  ];
  String? endpointURL = "https://sandbox-pgw.2c2p.com/payment/4.1/paymentToken";
  String secretKey =
      "7E097B0BEC9E21F61388FF80500A8E0EA926875C55A2C33497636FB1242A06A5";
  DateTime now = DateTime.now();
  String mid = "014010000000003";
  late String invNo = "DM01" + DateFormat("yyyyMMddhhmmss").format(now);
  String description = "Demo01 item";
  double? amount;
  String currencyCode = "THB";
  String frontendReturnUrl = "https://flutter.dev/";
  String backendReturnUrl =
      "https://16fb0121-3d49-4b81-acbd-3c1329f8f3f0.mock.pstmn.io";

  late final String requestMsg =
      '{\n"merchantID": "${Provider.of<JWTModels>(context, listen: false).mid}",\n"invoiceNo": "${Provider.of<JWTModels>(context, listen: false).invNo}",\n"description": "${Provider.of<JWTModels>(context, listen: false).description}",\n"amount": ${Provider.of<JWTModels>(context, listen: false).amount},\n"currencyCode": "$currencyCode",\n"frontendReturnUrl": "$frontendReturnUrl",\n"backendReturnUrl": "$backendReturnUrl"\n}';

  String respBackToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXJkTm8iOiI0MTExMTFYWFhYWFgxMTExIiwiY2FyZFRva2VuIjoiIiwibG95YWx0eVBvaW50cyI6bnVsbCwibWVyY2hhbnRJRCI6IjAxNDAxMDAwMDAwMDAwMyIsImludm9pY2VObyI6IjIwMjIwNDI0MDAwMDUxIiwiYW1vdW50IjoxMDAwLjAsIm1vbnRobHlQYXltZW50IjpudWxsLCJ1c2VyRGVmaW5lZDEiOiIiLCJ1c2VyRGVmaW5lZDIiOiIiLCJ1c2VyRGVmaW5lZDMiOiIiLCJ1c2VyRGVmaW5lZDQiOiIiLCJ1c2VyRGVmaW5lZDUiOiIiLCJjdXJyZW5jeUNvZGUiOiJUSEIiLCJyZWN1cnJpbmdVbmlxdWVJRCI6IiIsInRyYW5SZWYiOiI0ODczMjg0IiwicmVmZXJlbmNlTm8iOiI0NTEzMDI5IiwiYXBwcm92YWxDb2RlIjoiNjgzNTYzIiwiZWNpIjoiMDUiLCJ0cmFuc2FjdGlvbkRhdGVUaW1lIjoiMjAyMjA1MDMxNTQ1MTgiLCJhZ2VudENvZGUiOiJUQkFOSyIsImNoYW5uZWxDb2RlIjoiVkkiLCJpc3N1ZXJDb3VudHJ5IjoiVVMiLCJpc3N1ZXJCYW5rIjoiQkFOSyIsImluc3RhbGxtZW50TWVyY2hhbnRBYnNvcmJSYXRlIjpudWxsLCJjYXJkVHlwZSI6IkNSRURJVCIsImlkZW1wb3RlbmN5SUQiOiIiLCJwYXltZW50U2NoZW1lIjoiVkkiLCJyZXNwQ29kZSI6IjAwMDAiLCJyZXNwRGVzYyI6IlN1Y2Nlc3MifQ.g61cW9XFyzOuO3bV47g7Y2vUoyfQp6qMib6mpjR4oZI";
  String? tokenValue;

  Future<String> encodePayloadJWT() async {
    print("################# Request Msg is prepared #################");
    print("Request Msg Update : $requestMsg");

    // step 1 : convert string to json object
    print(
        "################# step 1 : convert string requestMsg to json object #################");

    Map<String, dynamic> newObj = jsonDecode(requestMsg!);

    print("newObj: $newObj");
    print("newObj mid: ${newObj['merchantID']}");
    print("newObj invNo: ${newObj['invoiceNo']}");
    print("newObj description: ${newObj['description']}");
    print("newObj amount: ${newObj['amount']}");
    print("newObj currencyCode: ${newObj['currencyCode']}");

    // step 2 : encrypt to JWT
    print("################# step 2 : encrypt by JWT #################");
    final jwt = JWT(
      newObj,
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );
    final token = jwt.sign(SecretKey(context.read<JWTModels>().secretKey));

    print("Secret Key: ${context.read<JWTModels>().secretKey}");
    print("JWT Payload: ${jwt.payload}");
    print('Signed token: $token\n');
    context.read<JWTModels>().encodedToken = token;
    setState(() {
      tokenValue = context.read<JWTModels>().encodedToken;
    });

    // step 3 : POST API
    print("################# step 3 : POST API #################");
    try {
      final response = await http.post(
        Uri.parse(endpointURL!),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'payload': token,
        }),
      );

      if (response.statusCode == 200) {
        final responseJson = convert.jsonDecode(response.body);
        final responseBodyToken = responseJson['payload'];

        print('Status Code: ${response.statusCode}');
        print('Response.body: ${response.body}');
        print('ResponseJson: $responseJson');
        print('Response Token: $responseBodyToken');

        if (responseBodyToken == null) {
          print("respCode: ${responseJson['respCode']}");
          print("respDesc: ${responseJson['respDesc']}");
          setState(() {
            context.read<JWTModels>().respCode = responseJson['respCode'];
            context.read<JWTModels>().respDesc = responseJson['respDesc'];
          });
          return "";
        }
        context.read<JWTModels>().decodedToken = responseBodyToken;

        // step 4 : decrypt JWT to json (get webPaymentURL)
        print(
            "################# step 4 : decrypt JWT to json (get webPaymentURL) #################");
        try {
          final jwt = JWT.verify(responseBodyToken,
              SecretKey(context.read<JWTModels>().secretKey));

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
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RedirectPaymentPage(
                              context.read<JWTModels>().webPaymentURL)))
                  .then((value) => setState(() {
                        print("Set State Work!!!!!!!!");
                      }));
            }
          });
        } on Exception catch (ex) {
          print(ex); // ex: invalid signature
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
      //_scaffoldKey.currentState!.showSnackBar(snackBar);
    }

    return "";
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
        } on Exception catch (ex) {
          print(ex); // ex: invalid signature
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

      //_scaffoldKey.currentState!.showSnackBar(snackBar);
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
    } on Exception catch (ex) {
      print(ex); // ex: invalid signature
    }
  }

  var jwts = JWTServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Redirect Payment'),
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
                      children: <Widget>[
                        Text(requestMsg),
                        Text(
                          'Merchant ID : ${Provider.of<JWTModels>(context).mid}',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Secret Key : ${Provider.of<JWTModels>(context).invNo}',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Description : ${Provider.of<JWTModels>(context).description}',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          'Amount : ${Provider.of<JWTModels>(context).amount}',
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Secret Key",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          initialValue:
                              context.read<JWTModels>().secretKey ?? secretKey,
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
                        Row(
                          children: [
                            const Expanded(
                                flex: 1, child: Text('Merchant ID :')),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  initialValue:
                                      context.read<JWTModels>().mid ?? mid,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color.fromARGB(255, 36, 35, 35),
                                    hintText: "Input merchant ID",
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input request message payload.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      context.read<JWTModels>().mid = value;
                                    });
                                  },
                                  onSaved: (value) {
                                    context.read<JWTModels>().mid = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Expanded(
                                flex: 1, child: Text('Invoice no. :')),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  initialValue:
                                      context.read<JWTModels>().invNo ?? invNo,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color.fromARGB(255, 36, 35, 35),
                                    hintText: "Input invoice no.",
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input request message payload.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      context.read<JWTModels>().invNo = value;
                                    });
                                  },
                                  onSaved: (value) {
                                    context.read<JWTModels>().invNo = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Expanded(
                                flex: 1, child: Text('Description :')),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  initialValue:
                                      context.read<JWTModels>().description ??
                                          description,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color.fromARGB(255, 36, 35, 35),
                                    hintText: "Input description",
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input request message payload.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      context.read<JWTModels>().description =
                                          value;
                                    });
                                  },
                                  onSaved: (value) {
                                    context.read<JWTModels>().description =
                                        value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Expanded(flex: 1, child: Text('Amount :')),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 40,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: context
                                      .read<JWTModels>()
                                      .amount
                                      .toString(),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Color.fromARGB(255, 36, 35, 35),
                                    hintText: "Input amount",
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input request message payload.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      context.read<JWTModels>().amount =
                                          double.parse(value);
                                    });
                                  },
                                  onSaved: (value) {
                                    context.read<JWTModels>().amount =
                                        double.parse(value!);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ////////// SAVE BUTTON //////////
                        MaterialButton(
                          color: Colors.teal,
                          onPressed: () {
                            // เก็บข้อมูลลงใน Model
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                            setState(() {
                              print("Save data & Set State!!!!!");
                              print(
                                  '{\n"merchantID": "${Provider.of<JWTModels>(context, listen: false).mid}",\n"invoiceNo": "${Provider.of<JWTModels>(context, listen: false).invNo}",\n"description": "${Provider.of<JWTModels>(context, listen: false).description}",\n"amount": ${Provider.of<JWTModels>(context, listen: false).amount},\n"currencyCode": "$currencyCode",\n"frontendReturnUrl": "$frontendReturnUrl",\n"backendReturnUrl": "$backendReturnUrl"\n}');
                            });
                          },
                          child: const Text('Submit'),
                        ),
                        ////////// SAVE BUTTON //////////

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

                        ////////// CHECK OUT BUTTON //////////
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: ElevatedButton(
                              onPressed: () {
                                encodePayloadJWT();
                              },
                              child: const Text(
                                "Redirect Payment Page",
                              )),
                        ),
                        ////////// CHECK OUT BUTTON //////////

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
