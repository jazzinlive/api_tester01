import 'dart:io';
import 'dart:core';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({Key? key}) : super(key: key);

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  String _fileName = 'No Selected File';
  String _tableName = 'No Table';

  void _openFilePicker() async {
    try {
      // Open the file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        print('#####################');
        print('result: ${result}');
        print('#####################');

        String? fileName = result.files.first.name;
        print('#####################');
        print('fileName: $fileName');
        print('#####################');

        setState(() {
          _fileName = fileName;
        });
      } else {
        // User canceled the picker
      }

      // Update the state with the selected file name
      setState(() {
        _fileName = _fileName;
      });

      // Read the .xlsx file and get the values from each row and column of the table
      // TODO: add code to read the .xlsx file and get the values from the table

    } catch (e) {
      print(e);
    }
  }

  void _readFileFromAsset() async {
    ByteData data = await rootBundle.load("assets/mid2c2p.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
    print('#####################');
    print('excel: ${excel.tables}');
    print('#####################');

    // for (var table in excel.tables.keys) {
    //   print('###############################################################');
    //   print("table: $table"); //sheet Name
    //   print(excel.tables[table]!.maxCols);
    //   print(excel.tables[table]!.maxRows);
    //   for (var row in excel.tables[table]!.rows) {
    //     print("rowData: $row");
    //   }
    //   print('###############################################################');

    //   setState(() {
    //     _tableName = table;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload File"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('File Name: $_fileName'),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Upload File'),
              onPressed: _openFilePicker,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Read File'),
              onPressed: _readFileFromAsset,
            ),
            const SizedBox(height: 20),
            Text('Sheet Name: $_tableName'),
          ],
        ),
      ),
    );
  }
}
