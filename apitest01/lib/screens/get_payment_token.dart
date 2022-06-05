import 'package:apitest01/screens/get_payment_token_demo01.dart';
import 'package:apitest01/screens/get_payment_token_demo02.dart';
import 'package:flutter/material.dart';

import 'get_payment_token_sandbox.dart';

class GetPaymentTokenPage extends StatefulWidget {
  const GetPaymentTokenPage({Key? key}) : super(key: key);

  @override
  State<GetPaymentTokenPage> createState() => _GetPaymentTokenPageState();
}

class _GetPaymentTokenPageState extends State<GetPaymentTokenPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Get Payment Token'),
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
              Tab(icon: Icon(Icons.sunny), text: "Sandbox"),
              Tab(icon: Icon(Icons.developer_mode), text: "Demo01"),
              Tab(icon: Icon(Icons.developer_board), text: "Demo02"),
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
              GetPaymentToken(),
              GetPaymentTokenDemo01(),
              GetPaymentTokenDemo02()
            ],
          ),
        ),
      ),
    );
  }
}
