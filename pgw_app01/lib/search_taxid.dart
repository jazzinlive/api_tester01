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
    return Container();
  }

  // Future processInsertDatabase() async {
  //   String xlsxAsset = 'assets/MID.xlsx';
  //   ByteData data = await rootBundle.load(xlsxAsset);
  //   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //   var excel = Excel.decodeBytes(bytes);
  //   List nameSheets = [];
  //   for (var item in excel.tables.keys) {
  //     nameSheets.add(item);
  //   }
  //   int times = 0;
  //   // print('### namesheet ==>> $nameSheets');
  //   for (var item in excel.tables[nameSheets[1]]!.rows) {
  //     // print('### row ==>> $item');
  //     List datas = item;
  //     // print('### datas ==>> $datas');

  //     if (times > 0) {
  //       for (var item2 in datas) {
  //         // print('### nameSheet ==> ${item2!.sheetName}');
  //         print('### ข้อมูลใช้ได้ ==>> ${item2!.value}');
  //       }
  //     }
  //     times++;
  //   }
  // }
}
