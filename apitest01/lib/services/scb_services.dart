import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

class SCBServices {
  String domain = "https://sandbox-pgw.2c2p.com/payment/4.1/paymentToken";

  String clientId = 'JT04';
  String secret =
      "CD229682D3297390B9F66FF4020B758F4A5E625AF4992E5D75D311D6458B38E2";

  // step 1 variable json payload data
  // step 2 payload data => jwt token
  // step 3 call webservices body payload is jwt token
  // step 4 decode jwt token
  // step 5 open website

  Future<String> encodePayloadJWT() async {
    // step 1
    try {
      final jwt = JWT({
        "merchantID": clientId,
        "invoiceNo": "999911111119991",
        "description": "item 10000",
        "amount": 1000.00,
        "currencyCode": "THB"
      });

      final skey = SecretKey(secret);

      // step 2
      final token = jwt.sign(skey);

      return token;
    } catch (e) {
      rethrow;
    }
  }

  // for getting the access token from 2c2p
  Future<String> requestPaymentToken(String token) async {
    // step 3
    try {
      final response = await http.post(
        Uri.parse(domain),
        headers: {
          HttpHeaders.acceptHeader: 'text/plain',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: token,
      );

      if (response.statusCode == 200) {
        // step 4
        final responseJson = convert.jsonDecode(response.body);
        final payload = responseJson['payload'];

        final jwt = JWT.verify(
            payload,
            SecretKey(
                "CD229682D3297390B9F66FF4020B758F4A5E625AF4992E5D75D311D6458B38E2"));
        //print('Payload: ${jwt.payload}');
        final webPaymentUrl = jwt.payload['webPaymentUrl'];
        final respCode = jwt.payload['respCode'];

        if (respCode == "0000") {
          return webPaymentUrl;
        }
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with 2c2p
  Future<Map<String, String>> createSCBPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(
          Uri.parse("$domain/partners/sandbox/v3/deeplink/transactions"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        throw Exception("0");
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return "0";
    } catch (e) {
      rethrow;
    }
  }
}
