import 'package:bmwt_app/screens/heartpage.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/screens/calorieswspage.dart';
import 'package:bmwt_app/screens/StepPage.dart';
import 'package:bmwt_app/screens/function2page.dart';
import 'package:bmwt_app/screens/HP2.dart';
import 'package:bmwt_app/screens/HP3.dart';
import 'package:bmwt_app/screens/DBTest.dart';
import 'package:bmwt_app/assets/customIcons/my_flutter_app_icons.dart';
import 'package:bmwt_app/screens/changeHeartGoals.dart';
import '../database/database.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home';
  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {
    String? name = 'giacomo';
    int _index = 2;
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        HomePage.routename,
        style: TextStyle(color: Colors.white),
      )),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColorDark,
                Theme.of(context).focusColor
              ],
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight,
              stops: [0.2, 1]),
        ),
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
          child: FutureBuilder(
            future: getName(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                name = snapshot.data as String;
                return Text('Welcome back ${name}',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                    ));
              } else {
                return Text('Welcome back',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                    ));
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
              icon: Icon(Icons.directions_walk),
              label: 'Steps',
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
            if (index == 2) {
              Navigator.pushNamed(context, StepPage.route);
            }
            if (index == 3) {
              Navigator.pushNamed(context, ChangeHeartGoals.route);
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
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Logout'),
                          content: Text(
                              'Are you sure you want to Logout? All your data will be lost!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final sp =
                                    await SharedPreferences.getInstance();
                                sp.remove('username');
                                await FitbitConnector.unauthorize(
                                  clientID: FitbitAppCredentials.clientID,
                                  clientSecret:
                                      FitbitAppCredentials.clientSecret,
                                );

                                //to make the database empty when the user logout
                                final AppDatabase database =
                                    await $FloorAppDatabase
                                        .databaseBuilder('app_database.db')
                                        .build();
                                final calorieswsDao = database.caloriesWSDao;
                                final dataToDeleteWS =
                                    await calorieswsDao.findAllCaloriesWS();
                                for (var item in dataToDeleteWS) {
                                  await calorieswsDao.deleteCaloriesWS(item);
                                }
                                final caloriesdayDao = database.caloriesDayDao;
                                final dataToDeleteDay =
                                    await caloriesdayDao.findAllCaloriesDay();
                                for (var item in dataToDeleteDay) {
                                  await caloriesdayDao.deleteCaloriesDay(item);
                                }

                                Navigator.of(context)
                                    .pushReplacementNamed(LoginPage.route);
                              },
                              child: Text('Yes'),
                            )
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  } //build

  Future<String?> getName() async {
    final sp = await SharedPreferences.getInstance();
    String? name = sp.getString('username');
    print(sp.toString());
    return name;
  }
} //Page
