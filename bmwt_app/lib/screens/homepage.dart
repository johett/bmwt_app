import 'package:bmwt_app/screens/heartpage.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/screens/calorieswspage.dart';
import 'package:bmwt_app/screens/function1page.dart';
import 'package:bmwt_app/screens/function2page.dart';
import 'package:bmwt_app/screens/HP2.dart';
import 'package:bmwt_app/screens/HP3.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home';
  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CaloriesWSPage.route);
              },
              child: const Text('To caloriesWS page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Function1Page.route);
              },
              child: const Text('Function 1'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Function2Page.route);
              },
              child: const Text('Function 2'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, HP3.route);
              },
              child: const Text('Heart'),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('bmwt_app')),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
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
