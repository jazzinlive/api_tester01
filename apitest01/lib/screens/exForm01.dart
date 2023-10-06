import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // เริ่มต้นข้อมูลใน Local Stage Provider
    Provider.of<FormData>(context, listen: false).name = '';
    Provider.of<FormData>(context, listen: false).age = '';
    Provider.of<FormData>(context, listen: false).phone = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ฟอร์มกรอกข้อมูล'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // แสดงข้อมูล
            Text(
              'Merchant ID : ${Provider.of<FormData>(context).name}',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              'Secret Key : ${Provider.of<FormData>(context).age}',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              'Description : ${Provider.of<FormData>(context).phone}',
              style: const TextStyle(fontSize: 20.0),
            ),
            // ช่องกรอกชื่อ
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Merchant ID',
              ),
            ),
            // ช่องกรอกอายุ
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Secret Key',
              ),
            ),
            // ช่องกรอกเบอร์โทร
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            // ปุ่มกด submit
            MaterialButton(
              color: Colors.cyan,
              onPressed: () {
                // เก็บข้อมูลลงใน Local Stage Provider
                Provider.of<FormData>(context, listen: false).name =
                    _nameController.text;
                Provider.of<FormData>(context, listen: false).age =
                    _ageController.text;
                Provider.of<FormData>(context, listen: false).phone =
                    _phoneController.text;

                // แสดงข้อมูลใน Text
                setState(() {});
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class FormData with ChangeNotifier {
  String? name;
  String? age;
  String? phone;

  FormData({this.name, this.age, this.phone});

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setAge(String age) {
    this.age = age;
    notifyListeners();
  }

  void setPhone(String phone) {
    this.phone = phone;
    notifyListeners();
  }
}
