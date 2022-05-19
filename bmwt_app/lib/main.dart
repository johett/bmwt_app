import 'package:bmwt_app/screens/homepage.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        //Approach 2:
        //This specifies the app entrypoint
        initialRoute: LoginPage.route,
        //This maps names to the set of routes within the app
        routes: {
          LoginPage.route: (context) => LoginPage(),
          HomePage.route: (context) => HomePage(),
        },
    );
  } //build
}//MyApp