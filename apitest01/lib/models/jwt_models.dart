import 'package:flutter/material.dart';

class JWTModels extends ChangeNotifier {
  String? _secretKey;
  String? _mid;
  String? _invNo;
  String? _description;
  double? _amount = 20;
  String? _requestMsg;
  String? _encodedToken;
  String? _requestBody;
  String? _endpointURL;
  String? _response;
  String? _decodedToken;
  String? _decodedPayload;
  String? _webPaymentURL;
  String? _paymentToken;
  String? _respCode;
  String? _respDesc;
  List<APIlog>? _logList = [];

  get secretKey => _secretKey;
  set secretKey(value) {
    _secretKey = value;
    notifyListeners();
  }

  get mid => _mid;
  set mid(value) {
    _mid = value;
    notifyListeners();
  }

  get invNo => _invNo;
  set invNo(value) {
    _invNo = value;
    notifyListeners();
  }

  get description => _description;
  set description(value) {
    _description = value;
    notifyListeners();
  }

  get amount => _amount;
  set amount(value) {
    _amount = double.parse(value.toString());
    notifyListeners();
  }

  get requestMsg => _requestMsg;
  set requestMsg(value) {
    _requestMsg = value;
    notifyListeners();
  }

  get encodedToken => _encodedToken;
  set encodedToken(value) {
    _encodedToken = value;
    notifyListeners();
  }

  get requestBody => _requestBody;
  set requestBody(value) {
    _requestBody = value;
    notifyListeners();
  }

  get endpointURL => _endpointURL;
  set endpointURL(value) {
    _endpointURL = value;
    notifyListeners();
  }

  get response => _response;
  set response(value) {
    _response = value;
    notifyListeners();
  }

  get decodedToken => _decodedToken;
  set decodedToken(value) {
    _decodedToken = value;
    notifyListeners();
  }

  get decodedPayload => _decodedPayload;
  set decodedPayload(value) {
    _decodedPayload = value;
    notifyListeners();
  }

  get webPaymentURL => _webPaymentURL;
  set webPaymentURL(value) {
    _webPaymentURL = value;
    notifyListeners();
  }

  get paymentToken => _paymentToken;
  set paymentToken(value) {
    _paymentToken = value;
    notifyListeners();
  }

  get respCode => _respCode;
  set respCode(value) {
    _respCode = value;
    notifyListeners();
  }

  get respDesc => _respDesc;
  set respDesc(value) {
    _respDesc = value;
    notifyListeners();
  }

  List<dynamic>? get jwtLog => _logList;
  set logList(List<dynamic>? value) {
    _logList = value as List<APIlog>;
    notifyListeners();
  }

  void addLog(APIlog value) {
    _logList!.add(value);
    notifyListeners();
  }
}

class APIlog {
  APIlog(
      {this.secretKey,
      this.mid,
      this.invNo,
      this.description,
      this.amount,
      this.requestMsg,
      this.encodedToken,
      this.requestBody,
      this.endpointURL,
      this.response,
      this.decodedToken,
      this.decodedPayload,
      this.webPaymentURL,
      this.paymentToken,
      this.respCode,
      this.respDesc});
  String? secretKey;
  String? mid;
  String? invNo;
  String? description;
  double? amount;
  String? requestMsg;
  String? encodedToken;
  String? requestBody;
  String? endpointURL;
  String? response;
  String? decodedToken;
  String? decodedPayload;
  String? webPaymentURL;
  String? paymentToken;
  String? respCode;
  String? respDesc;
}
