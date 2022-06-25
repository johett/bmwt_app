import 'package:bmwt_app/screens/homepage.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:bmwt_app/screens/calorieshomepage.dart';
import 'package:bmwt_app/screens/caloriesWSpage.dart';
import 'package:bmwt_app/screens/caloriesDaypage.dart';
import 'package:bmwt_app/screens/function1page.dart';
import 'package:bmwt_app/screens/function2page.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/database/database.dart';
import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';

void main() async {
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
    child: const MyApp(),
  ));
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
        LoginPage.route: (context) => const LoginPage(),
        HomePage.route: (context) => const HomePage(),
        CaloriesHomePage.route: (context) => const CaloriesHomePage(),
        CaloriesWSPage.route: (context) => const CaloriesWSPage(),
        CaloriesDayPage.route: (context) => const CaloriesDayPage(),
        Function1Page.route: (context) => StepsPage(),
        Function2Page.route: (context) => const Function2Page(),
      },
    );
  } //build
}//MyApp