import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:bmwt_app/screens/calorieshomepage.dart';
import 'package:bmwt_app/screens/heartpage.dart';
import 'package:bmwt_app/screens/userPage.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/screens/calorieswspage.dart';
import 'package:bmwt_app/screens/StepPage.dart';
import 'package:bmwt_app/screens/function2page.dart';
import 'package:bmwt_app/assets/customIcons/my_flutter_app_icons.dart';
import 'package:bmwt_app/screens/changeHeartGoals.dart';
import '../database/database.dart';
import 'package:bmwt_app/database/entities/userData.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = '/home';
  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: FutureBuilder(
                future: getBattery(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    String batteryLevel = snapshot.data as String;
                    print(batteryLevel);
                    return Text('Fitbit battery level: ${batteryLevel}',
                        style: TextStyle(
                            fontSize: 14,
                            color: batteryLevel == 'Low'
                                ? Colors.red
                                : Colors.white));
                  } else
                    return Text('');
                },
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: Consumer<DatabaseRepository>(
                    builder: (context, dbr, child) {
                  return FutureBuilder(
                      future: dbr.getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<UserData> user = snapshot.data as List<UserData>;
                          if (user.length != 0 && user[0].name != null) {
                            return Column(
                              children: [
                                Text('Welcome back ${user[0].name}',
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                    )),
                                Text('to ActiStep',
                                    style: TextStyle(
                                      fontSize: 36,
                                      color: Colors.white,
                                    )),
                                Text('Your next step to a more active life',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ))
                              ],
                            );
                          } else {
                            return Text('Your next step to a more active life',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ));
                          }
                        } else {
                          return Text('Welcome back',
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                              ));
                        }
                      });
                })),
          ],
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
              icon: Icon(Icons.person),
              label: 'User',
            )
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, CaloriesHomePage.route);
            }
            if (index == 1) {
              Navigator.pushNamed(context, HeartPage.route);
            }
            if (index == 2) {
              Navigator.pushNamed(context, StepPage.route);
            }

            if (index == 3) {
              Navigator.pushNamed(context, UserPage.route);
            }
          }),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 99, 0, 68),
                ),
                child: Text('')),
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
                                Navigator.pop(context);
                                Navigator.pop(context);
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

  Future<String?> getBattery() async {
    final sp = await SharedPreferences.getInstance();
    String? name = sp.getString('username');
    FitbitDeviceDataManager manager = FitbitDeviceDataManager(
      clientID: FitbitAppCredentials.clientID,
      clientSecret: FitbitAppCredentials.clientSecret,
    );
    FitbitDeviceAPIURL fitbitDeviceAPIURL =
        FitbitDeviceAPIURL.withUserID(userID: name);
    List<FitbitData> data = await manager.fetch(fitbitDeviceAPIURL);
    FitbitDeviceData device = data[0] as FitbitDeviceData;
    return device.batteryLevel;
  }
} //Page
