import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static const route = '/home';
  static const routename = 'HomePage';
  
  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            final sp = await SharedPreferences.getInstance();
            sp.remove('username');
            Navigator.of(context).pushReplacementNamed(LoginPage.route);
          },
          child: Text('log out'),
        ),
      ),
    );
  } //build

} //Page