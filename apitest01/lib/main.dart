import 'package:apitest01/models/jwt_models.dart';
import 'package:flutter/material.dart';
import 'package:pgw_sdk/models/api_environment.dart';
import 'package:pgw_sdk/pgw_sdk.dart';
import 'models/qr_models.dart';
import 'screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PGWSDK.initialize(APIEnvironment.Sandbox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JWTModels()),
        ChangeNotifierProvider(create: (context) => QRModels()),
        Provider(create: (context) => APIlog())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: 'SukhumvitSet',
            
        ),
        home: MyHomePage(title: 'Test API ver.1.1.0'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


