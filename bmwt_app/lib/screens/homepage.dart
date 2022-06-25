import 'package:bmwt_app/database/database.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/screens/calorieshomepage.dart';
import 'package:bmwt_app/screens/function1page.dart';
import 'package:bmwt_app/screens/function2page.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, CaloriesHomePage.route);
              }, 
              child: Text('To caloriesWS page'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Function1Page.route);
              }, 
              child: Text('Function 1'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Function2Page.route);
              }, 
              child: Text('Function 2'),
              )
          ],
        ),
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
              
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to Logout? All your data will be lost!'),
                    actions: [
                      TextButton(
                        onPressed:(){
                          Navigator.pop(context);
                        },
                        child: 
                          Text('No'),
                      ),
                      TextButton(
                        onPressed:() async{
                          final sp = await SharedPreferences.getInstance();
                          sp.remove('username');
                          await FitbitConnector.unauthorize(
                            clientID: FitbitAppCredentials.clientID,
                            clientSecret: FitbitAppCredentials.clientSecret,
                          );

                        //to make the database empty when the user logout
                        final AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
                        final calorieswsDao = database.caloriesWSDao;
                        final dataToDeleteWS = await calorieswsDao.findAllCaloriesWS();
                        for(var item in dataToDeleteWS){
                          await calorieswsDao.deleteCaloriesWS(item);
                        }
                        final caloriesdayDao = database.caloriesDayDao;
                        final dataToDeleteDay = await caloriesdayDao.findAllCaloriesDay();
                        for(var item in dataToDeleteDay){
                          await caloriesdayDao.deleteCaloriesDay(item);
                        }

                          Navigator.of(context).pushReplacementNamed(LoginPage.route);
                        },
                        child: 
                          Text('Yes'),
                      )
                    ],
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  } //build

} //Page