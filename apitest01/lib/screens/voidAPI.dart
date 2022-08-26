import 'package:apitest01/screens/void_demo01.dart';
import 'package:apitest01/screens/get_payment_token_demo02.dart';
import 'package:apitest01/screens/void_sandbox.dart';
import 'package:flutter/material.dart';

import 'get_payment_token_sandbox.dart';

class VoidAPI extends StatefulWidget {
  const VoidAPI({Key? key}) : super(key: key);

  @override
  State<VoidAPI> createState() => _VoidAPIState();
}

class _VoidAPIState extends State<VoidAPI> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Void API'),
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
          child: TabBarView(
            children: [VoidSandbox(), VoidDemo01(), GetPaymentTokenDemo02()],
          ),
        ),
      ),
    );
  }
}
