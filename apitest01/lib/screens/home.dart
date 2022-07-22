import 'dart:math';

import 'package:apitest01/screens/get_payment_token.dart';
import 'package:apitest01/screens/paywise.dart';
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'SCB Payment Gateway',
                  style: TextStyle(fontSize: 30, fontFamily: 'HWTArtzW00'),
                ),
                const Text(
                  'API Tester',
                  style: TextStyle(fontSize: 25, fontFamily: 'HWTArtzW00'),
                ),
                const Text(
                  'Ver. 1.1.5',
                  style: TextStyle(fontSize: 15, fontFamily: 'HWTArtzW00'),
                ),
                const SizedBox(
                  height: 50,
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
                            builder: (BuildContext context) => const Paywise(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/scblogo.png', width: 100),
                          const SizedBox(width: 10),
                          Image.asset('assets/scbez.png', width: 40),
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
                          padding: EdgeInsets.zero,
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
                          width: double.infinity,
                          height: double.infinity,
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
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }

  
}
