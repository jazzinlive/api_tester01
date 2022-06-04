import 'package:flutter/material.dart';

class QRModels extends ChangeNotifier {
  String? _secretKey;
  String? _mid;
  String? _tid;
  String? _invNo;
  String? _description;
  double? _amount;
  String? _requestMsgQR1;
  String? _requestMsgQR2;
  String? _accessToken;
  String? _tokenType;
  String? _endpointURL;
  String? _responseQR1;
  String? _responseQR2;
  String? _decodedToken;
  String? _decodedPayload;
  String? _qrPaymentURL;
  String? _paymentToken;
  String? _respCode;
  String? _respDesc;
  List<QRAPIlog>? _logList = [];

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

  get tid => _tid;
  set tid(value) {
    _tid = value;
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

  get requestMsgQR1 => _requestMsgQR1;
  set requestMsgQR1(value) {
    _requestMsgQR1 = value;
    notifyListeners();
  }

  get requestMsgQR2 => _requestMsgQR2;
  set requestMsgQR2(value) {
    _requestMsgQR2 = value;
    notifyListeners();
  }

  get accessToken => _accessToken;
  set accessToken(value) {
    _accessToken = value;
    notifyListeners();
  }

  get tokenType => _tokenType;
  set tokenType(value) {
    _tokenType = value;
    notifyListeners();
  }

  get endpointURL => _endpointURL;
  set endpointURL(value) {
    _endpointURL = value;
    notifyListeners();
  }

  get responseQR1 => _responseQR1;
  set responseQR1(value) {
    _responseQR1 = value;
    notifyListeners();
  }

  get responseQR2 => _responseQR2;
  set responseQR2(value) {
    _responseQR2 = value;
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

  get qrPaymentURL => _qrPaymentURL;
  set qrPaymentURL(value) {
    _qrPaymentURL = value;
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
    _logList = value as List<QRAPIlog>;
    notifyListeners();
  }

  void addLog(QRAPIlog value) {
    _logList!.add(value);
    notifyListeners();
  }
}

class QRAPIlog {
  QRAPIlog(
      {this.secretKey,
      this.mid,
      this.tid,
      this.invNo,
      this.description,
      this.amount,
      this.requestMsgQR1,
      this.requestMsgQR2,
      this.accessToken,
      this.tokenType,
      this.endpointURL,
      this.responseQR1,
      this.responseQR2,
      this.decodedToken,
      this.decodedPayload,
      this.qrPaymentURL,
      this.paymentToken,
      this.respCode,
      this.respDesc});
  String? secretKey;
  String? mid;
  String? tid;
  String? invNo;
  String? description;
  double? amount;
  String? requestMsgQR1;
  String? requestMsgQR2;
  String? accessToken;
  String? tokenType;
  String? endpointURL;
  String? responseQR1;
  String? responseQR2;
  String? decodedToken;
  String? decodedPayload;
  String? qrPaymentURL;
  String? paymentToken;
  String? respCode;
  String? respDesc;
}
