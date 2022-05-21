import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
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
        child: Text('Home page'),
        ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('bmwt_app')
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              
              onTap: () async{
                final sp = await SharedPreferences.getInstance();
                sp.remove('username');
                await FitbitConnector.unauthorize(
                  clientID: FitbitAppCredentials.clientID,
                  clientSecret: FitbitAppCredentials.clientSecret,
                  );
                Navigator.of(context).pushReplacementNamed(LoginPage.route);
              },
            ),
          ],
        ),
      ),
    );
  } //build

} //Page
