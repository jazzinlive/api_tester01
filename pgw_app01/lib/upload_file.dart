import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String fileName = 'No file selected';
  List<List<dynamic>>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fileName),
            ElevatedButton(
              child: Text('Upload .xlsx file'),
              onPressed: () async {
                // Show the file picker and get the selected file
                FilePickerResult? filePath =
                    (await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                ));

                // Update the file name
                setState(() {
                  fileName = filePath.toString().split('/').last;
                  //fileName = filePath.toString();
                });

                // Read the .xlsx file and get the data
                var bytes = await File(filePath.toString()).readAsBytes();
                var excel = Excel.decodeBytes(bytes);
                data = excel.tables[excel.tables.keys.first]!.rows;

                // Display the values from each row and column
                for (var i = 0; i < data!.length; i++) {
                  for (var j = 0; j < data![i].length; j++) {
                    print(data![i][j]);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
