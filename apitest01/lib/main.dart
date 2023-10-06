import 'package:apitest01/models/jwt_models.dart';
import 'package:apitest01/screens/exForm01.dart';
import 'package:flutter/material.dart';
//import 'package:pgw_sdk/models/api_environment.dart';
//import 'package:pgw_sdk/pgw_sdk.dart';
import 'models/paywise_models.dart';
import 'models/qr_models.dart';
import 'package:provider/provider.dart';

import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  //PGWSDK.initialize(APIEnvironment.Sandbox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JWTModels()),
        Provider(create: (context) => APIlog()),
        ChangeNotifierProvider(create: (context) => QRModels()),
        Provider(create: (context) => QRAPIlog()),
        ChangeNotifierProvider(create: (context) => PaywiseModels()),
        Provider(create: (context) => Paywiselog()),
        ChangeNotifierProvider(create: (context) => FormData()),
        Provider(create: (context) => FormData())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'SukhumvitSet',
        ),
        home: const MyHomePage(title: 'Test API ver.1.1.0'),
        //home: const FormPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
