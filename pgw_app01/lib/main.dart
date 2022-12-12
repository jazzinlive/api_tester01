// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_excel/excel.dart';
//import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 55, 28, 100),
            titleTextStyle: TextStyle(
                fontFamily: 'Petchlamoon',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      home: const MyHomePage(title: 'ACQ Profit & Loss'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> rowdetail = [];

  _importFromExcel() async {
    String xlsxAsset = "assets/MID.xlsx";
    ByteData data = await rootBundle.load("assets/MID.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {}
    }
  }
  // Future<String> readTable(String path) async {
  //   return await rootBundle.
  //String xlsxAsset = "assets/MID.xlsx";
  //ByteData data = await rootBundle.load("assets/MID.xlsx");
  //var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  //var excel = Excel.decodeBytes(bytes);

  // for (var table in excel.tables.keys) {
  //   print(table); //sheet Name
  //print(excel.tables[table]!.maxCols);
  //print(excel.tables[table]!.maxRows);
  // for (var row in excel.tables[table]!.rows) {
  //   print("$row");
  // }
  // }
  //List nameSheets = [];

  // for (var item in excel.tables.keys) {
  //   nameSheets.add(item);
  // }
  // int times = 0;
  // print('### namesheet ==>> $nameSheets');
  // for (var item in excel.tables[nameSheets[1]]!.rows) {
  //   print('### row ==>> $item');
  //   List datas = item;
  //   print('### datas ==>> $datas');

  //   if (times > 0) {
  //     for (var item2 in datas) {
  //       print('### nameSheet ==> ${item2!.sheetName}');
  //       print('### ข้อมูลใช้ได้ ==>> ${item2!.value}');
  //     }
  //   }
  //   times++;
  // }
  //}

  @override
  void initState() {
    //processInsertDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Search by TAX ID",
              style: TextStyle(
                  fontFamily: 'Petchlamoon',
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tax ID',
                  hintText: 'ex. 0105558080781'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            Text(
              "Merchant Name",
              style: TextStyle(
                  fontFamily: 'Petchlamoon',
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Shopee Pay",
              style: TextStyle(fontFamily: 'Petchlamoon', fontSize: 13),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
            SizedBox(height: 10),
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
                        children: <Widget>[
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
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8)),
                    height: 80,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Read Excel File'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontFamily: 'Petchlamoon'),
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
