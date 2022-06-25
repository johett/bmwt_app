import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = '/login';
  static const routename = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  }//initState
  
  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('username') != null){
      //If 'username is set, push the HomePage
      Navigator.of(context).pushReplacementNamed(HomePage.route);
    }//if
  }//_checkLogin

  @override
  Widget build(BuildContext context) {
    print('${LoginPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(LoginPage.routename),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
          String? userId = await FitbitConnector.authorize(
            context: context,
            clientID: FitbitAppCredentials.clientID,
            clientSecret: FitbitAppCredentials.clientSecret,
            redirectUri: FitbitAppCredentials.redirectUri,
            callbackUrlScheme: FitbitAppCredentials.callbackUrlScheme,
            );
          if(userId!=null){
            final sp = await SharedPreferences.getInstance();
            sp.setString('username', userId);
            Navigator.of(context).pushReplacementNamed(HomePage.route);
          }
        },child: const Text('Login'),),
      ),
    );
  } } //Page