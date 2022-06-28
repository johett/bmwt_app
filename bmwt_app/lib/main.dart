import 'package:bmwt_app/screens/changeHeartGoals.dart';
import 'package:bmwt_app/screens/homepage.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:bmwt_app/screens/calorieshomepage.dart';
import 'package:bmwt_app/screens/caloriesWSpage.dart';
import 'package:bmwt_app/screens/caloriesDaypage.dart';
import 'package:bmwt_app/screens/heartpage.dart';
import 'package:bmwt_app/screens/StepPage.dart';
import 'package:bmwt_app/screens/function2page.dart';
import 'package:bmwt_app/screens/HP3.dart';
import 'package:bmwt_app/screens/lastWeekHeart.dart';
import 'package:bmwt_app/screens/userPage.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/database/database.dart';
import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //This is a special method that use WidgetFlutterBinding to interact with the Flutter engine.
  //This is needed when you need to interact with the native core of the app.
  //Here, we need it since when need to initialize the DB before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  //This opens the database.
  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  //This creates a new DatabaseRepository from the AppDatabase instance just initialized
  final databaseRepository = DatabaseRepository(database: database);
  //Here, we run the app and we provide to the whole widget tree the instance of the DatabaseRepository.
  //That instance will be then shared through the platform and will be unique.
  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: (context) => databaseRepository,
    child: MyApp(),
  ));
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color accent =
        Color.fromARGB(255, 194, 221, 244); //Color.fromARGB(255, 2, 86, 152);
    Color base = Colors.white;
    Color darkBase = Color.fromARGB(255, 99, 0, 68);
    Color textColor = Color.fromARGB(255, 61, 58, 55);
    return MaterialApp(
      theme: ThemeData(
        focusColor: accent,
        primaryColor: base,
        primaryColorDark: darkBase,
        scaffoldBackgroundColor: base,
        bottomAppBarColor: darkBase,
        backgroundColor: base,
        appBarTheme: AppBarTheme(
            color: darkBase,
            titleTextStyle: TextStyle(color: accent, fontSize: 26)),
        iconTheme: IconThemeData(color: accent),
        textTheme: TextTheme(
            //Changes text data
            bodyText2: TextStyle(fontSize: 16, color: textColor)),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: darkBase,
          selectedItemColor: accent,
          unselectedItemColor: accent,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      //Approach 2:
      //This specifies the app entrypoint
      initialRoute: LoginPage.route,
      //This maps names to the set of routes within the app
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        HomePage.route: (context) => const HomePage(),
        CaloriesHomePage.route: (context) => const CaloriesHomePage(),
        HeartPage.route: (context) => HeartPage(),
        HP3.route: (context) => HP3(),
        ChangeHeartGoals.route: (context) => ChangeHeartGoals(),
        LastWeekHeart.route: (context) => LastWeekHeart(),
        CaloriesWSPage.route: (context) => const CaloriesWSPage(),
        CaloriesDayPage.route: (context) => const CaloriesDayPage(),
        StepPage.route: (context) => StepsPage(),
        UserPage.route: (context) => UserPage(),
        Function2Page.route: (context) => const Function2Page(),
      },
    );
  } //build
}//MyApp