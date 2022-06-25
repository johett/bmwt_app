import 'package:bmwt_app/screens/heartpage.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/screens/calorieswspage.dart';
import 'package:bmwt_app/screens/function1page.dart';
import 'package:bmwt_app/screens/function2page.dart';
import 'package:bmwt_app/screens/HP2.dart';
import 'package:bmwt_app/screens/HP3.dart';
import 'package:bmwt_app/screens/DBTest.dart';
import 'package:bmwt_app/assets/customIcons/my_flutter_app_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home';
  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    int _index = 2;
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.routename,
            style: TextStyle(color: Color.fromARGB(255, 233, 86, 32))),
        backgroundColor: Color.fromARGB(255, 44, 0, 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color.fromARGB(255, 233, 86, 32),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 44, 0, 30),
          fixedColor: Color.fromARGB(255, 233, 86, 32),
          currentIndex: _index,
          // ignore: prefer_const_constructors
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'Calories',
            ),
            BottomNavigationBarItem(
              icon: Icon(MyFlutterApp.heart),
              label: 'Heart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stop),
              label: 'DB Test',
            )
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, CaloriesWSPage.route);
            }
            if (index == 1) {
              Navigator.pushNamed(context, HP3.route);
            }
            if (index == 4) {
              Navigator.pushNamed(context, DBTest.route);
            }
          }),
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
