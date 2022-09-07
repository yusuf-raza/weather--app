import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'WeatherForecast.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherForecast(),
      theme: ThemeData(
        textTheme: TextTheme(
          //bodyText1: TextStyle(color: Colors.blueGrey),
           // bodyText2: TextStyle(color: Colors.white)
        ),
        brightness: Brightness.dark
      ),
    );
  }
}

