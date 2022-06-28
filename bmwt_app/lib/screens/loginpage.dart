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
        child: Center(
          child: SizedBox(
            height: 150,
            width: 300,
            child: Container(
                  color: Color.fromARGB(255, 252, 252, 252),
              child: Column(
                children: [
                  Text('Welcome to BMWT Project App',style: TextStyle(fontSize: 20),),
                  SizedBox(
                    height:20,
                  ),
                  Text('Keep monitored your health status!', style: TextStyle(fontSize: 18),),
                  SizedBox(
                    height:20,
                  ),
                  ElevatedButton( //pressing this bottom it will let you authenticate into fitbit server using fitbitter methods
                    onPressed: () async{
                    String? userId = await FitbitConnector.authorize(
                      context: context,
                      clientID: FitbitAppCredentials.clientID,
                      clientSecret: FitbitAppCredentials.clientSecret,
                      redirectUri: FitbitAppCredentials.redirectUri,
                      callbackUrlScheme: FitbitAppCredentials.callbackUrlScheme,
                      );
                      if(userId!=null){ //once authenticated you will be redirect to homepage and the id will be saved for authentication persistance
                        final sp = await SharedPreferences.getInstance();
                        sp.setString('username', userId);  
                        Navigator.of(context).pushReplacementNamed(HomePage.route);
                      }
                    },
                  child: Text('Login',style: TextStyle(fontSize: 20),),
                  style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } } //Page