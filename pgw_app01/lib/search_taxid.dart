import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaxIdSearchPage extends StatefulWidget {
  const TaxIdSearchPage({Key? key}) : super(key: key);

  @override
  State<TaxIdSearchPage> createState() => _TaxIdSearchPageState();
}

class _TaxIdSearchPageState extends State<TaxIdSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Search by TAX ID",
              style: TextStyle(
                  fontFamily: 'Petchlamoon',
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            const TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tax ID',
                  hintText: 'ex. 0105558080781'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            const Text(
              "Merchant Name",
              style: TextStyle(
                  fontFamily: 'Petchlamoon',
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Shopee Pay",
              style: TextStyle(fontFamily: 'Petchlamoon', fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  "Open Date",
                  style: TextStyle(
                      fontFamily: 'Petchlamoon',
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "2022-02",
                  style: TextStyle(fontFamily: 'Petchlamoon', fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8)),
                    height: 80,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            "Transaction",
                            style: TextStyle(
                                fontFamily: 'Petchlamoon',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "250",
                            style: TextStyle(
                                fontFamily: 'Petchlamoon',
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8)),
                    height: 80,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            "MSV",
                            style: TextStyle(
                                fontFamily: 'Petchlamoon',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "12,508,520",
                            style: TextStyle(
                                fontFamily: 'Petchlamoon',
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Read Excel File'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontFamily: 'Petchlamoon'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
