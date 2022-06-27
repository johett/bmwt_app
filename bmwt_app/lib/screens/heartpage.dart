import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeartPage extends StatefulWidget {
  HeartPage({Key? key}) : super(key: key);

  static const route = '/heart';
  static const routename = 'HeartPage';

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  String? HR;
  @override
  void initState() {
    HR = '1';
    super.initState();
    //Check if the user is already logged in before rendering the login page
  } //initState

  @override
  Widget build(BuildContext context) {
    print('${HeartPage.routename} built');
    return Scaffold(
        appBar: AppBar(
          title: Text(HeartPage.routename),
        ),
        body: Column(children: [
          ElevatedButton(onPressed: _getHeartRateNow, child: Text('button')),
          Text('$HR')
        ]));
  }
  // functions

  Future<String> _getHeartRateNow() async {
    FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(
      clientID: FitbitAppCredentials.clientID,
      clientSecret: FitbitAppCredentials.clientSecret,
    );
    final sp = await SharedPreferences.getInstance();
    FitbitHeartAPIURL fitbitHeartApiUrl = FitbitHeartAPIURL.dayWithUserID(
      date: DateTime.now(),
      userID: sp.getString('username'),
    );
    print(DateTime.now().toString());
    List<FitbitData> fitbitHeartData =
        await fitbitHeartDataManager.fetch(fitbitHeartApiUrl);
    FitbitHeartData? fitbitHeartData2 = fitbitHeartData[0] as FitbitHeartData;
    print(fitbitHeartData2.toString());
    HR = fitbitHeartData2.restingHeartRate.toString();
    setState(() {
      HR = fitbitHeartData2.restingHeartRate.toString();
    });
    return fitbitHeartData2.restingHeartRate.toString();
  }
} //Page

