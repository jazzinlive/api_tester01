import 'package:flutter/material.dart';
import 'package:pgw_app01/search_taxid.dart';
import 'package:pgw_app01/upload.dart';
import 'package:pgw_app01/upload_file.dart';

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
      //home: UploadPage(),
      //home: FileUploadPage(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PGW Profit & Loss"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Welcome Back!'),
                        Text('Guys'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: GridView.count(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                          backgroundColor: Color.fromARGB(255, 55, 28, 100)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload_file),
                          Text('Upload File'),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FileUploadPage()));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                          backgroundColor: Color.fromARGB(255, 55, 28, 100)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.monetization_on),
                          Text('P & L'),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TaxIdSearchPage()));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                          backgroundColor: Color.fromARGB(255, 55, 28, 100)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload_file),
                          Text('Upload File'),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FileUploadPage()));
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                          backgroundColor: Color.fromARGB(255, 55, 28, 100)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.monetization_on),
                          Text('P & L'),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TaxIdSearchPage()));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class MenuButton extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Function onPressed;

//   const MenuButton({
//     Key? key,
//     required this.icon,
//     required this.text,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () {
//           onPressed;
//         },
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(icon),
//             const SizedBox(height: 8.0),
//             Text(text),
//           ],
//         ),
//       ),
//     );
//   }
// }
