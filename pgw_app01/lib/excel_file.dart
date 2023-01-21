import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Excel Demo',
      home: ExcelPage(),
    );
  }
}

Excel parseExcelFile(List<int> bytes) {
  return Excel.decodeBytes(bytes);
}

class ExcelPage extends StatefulWidget {
  const ExcelPage({Key? key}) : super(key: key);

  @override
  _ExcelPageState createState() => _ExcelPageState();
}

class _ExcelPageState extends State<ExcelPage> {
  List<List<dynamic>> _excelData = [];

  @override
  void initState() {
    super.initState();
    _loadExcel();
  }

  void _loadExcel() async {
    print('#####################');
    ByteData data = await rootBundle.load("assets/mid2c2p.xlsx");
    print('data: $data');
    print('#####################');
    // var bytes = data.buffer
    //     .asUint8List(data.offsetInBytes, data.lengthInBytes)
    //     .iterator;
    Uint8List bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    print('byte: $bytes');
    print('#####################');
    // Load the Excel file
    // excel = Excel.decodeBytes(bytes);
    Excel excel = Excel.decodeBytes(bytes);
    print('#####################');
    print('excel: $excel');
    print('#####################');

    // Get the first sheet
    //final sheet = excel.toString();

    // Convert the sheet to a list of lists
    //_excelData = sheet.toString() as List<List>;

    // Set the state to rebuild the widget with the new data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Demo'),
      ),
      body: _excelData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                ],
                rows: _excelData
                    .map((row) => DataRow(
                          cells: [
                            DataCell(Text(row[0])),
                            DataCell(Text(row[1])),
                            DataCell(Text(row[2])),
                          ],
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
