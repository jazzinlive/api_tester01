import 'dart:math';

import 'package:apitest01/screens/get_payment_token.dart';
import 'package:apitest01/screens/qr_api.dart';
import 'package:flutter/material.dart';

import 'form_token_demo01.dart';

class MyHomePage extends StatefulWidget {
  
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/gbg00.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma())),
        child: Stack(
          children: [
            const Positioned(
                top: 75,
                left: 20,
                child: Text(
                  'PGW',
                  style: TextStyle(fontSize: 50, fontFamily: 'HWTArtzW00'),
                )),
            const Positioned(
                top: 120,
                left: 20,
                child: Text(
                  'API Tester',
                  style: TextStyle(fontSize: 35, fontFamily: 'HWTArtzW00'),
                )),
            const Positioned(
                top: 153,
                left: 20,
                child: Text(
                  'Ver. 1.1.0',
                  style: TextStyle(fontSize: 20, fontFamily: 'HWTArtzW00'),
                )),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color.fromARGB(255, 6, 73, 77)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const GetPaymentTokenPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/2c2plogo.png', width: 80),
                              const SizedBox(width: 10),
                              const Text(
                                'Redirect PGW',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color.fromARGB(255, 6, 73, 77)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const FormTokenDemo01(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/2c2plogo.png', width: 80),
                              const SizedBox(width: 10),
                              const Text(
                                'Redirect PGW - Form',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color.fromARGB(255, 52, 2, 92)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const QRPayment(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/scblogo.png', width: 100),
                              const SizedBox(width: 10),
                              Image.asset('assets/qr-code.png', width: 25),
                              const SizedBox(width: 10),
                              const Text(
                                'QR API',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color.fromARGB(255, 52, 2, 92)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const GetPaymentTokenPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/scblogo.png', width: 100),
                              const SizedBox(width: 10),
                              const Text(
                                'Paywise',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const GetPaymentTokenPage(),
                            ),
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.yellow[400]!.withOpacity(0.8),
                                    Colors.orange.withOpacity(0.8),
                                    Colors.teal.withOpacity(0.8),
                                    Colors.purple[900]!.withOpacity(0.8),
                                  ]),
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset('assets/scbez.png', width: 30),
                                const SizedBox(width: 5),
                                Image.asset('assets/kplus.png', width: 30),
                                const SizedBox(width: 5),
                                Image.asset('assets/ktb.png', width: 30),
                                const SizedBox(width: 5),
                                Image.asset('assets/uchoose.png', width: 30),
                                const SizedBox(width: 5),
                                Image.asset('assets/bbl.png', width: 30),
                                const SizedBox(width: 10),
                                const Text(
                                  'Cross-Bank Deeplink',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: const Color.fromARGB(255, 52, 2, 92)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const GetPaymentTokenPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/scblogo.png', width: 100),
                              const SizedBox(width: 10),
                              const Text(
                                'LEGO',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }

  
}
