
import 'package:apitest01/screens/qr_api_qr30.dart';
import 'package:apitest01/screens/qr_api_qrall.dart';
import 'package:apitest01/screens/qr_api_qrcs.dart';
import 'package:flutter/material.dart';



class QRPayment extends StatefulWidget {
  const QRPayment({Key? key}) : super(key: key);

  @override
  State<QRPayment> createState() => _QRPaymentState();
}

class _QRPaymentState extends State<QRPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

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
