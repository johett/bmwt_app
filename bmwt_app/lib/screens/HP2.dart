import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/database/entities/heart.dart';
import 'package:bmwt_app/database/database.dart';

class HP2 extends StatefulWidget {
  const HP2({Key? key}) : super(key: key);

  static const route = '/heart2';
  static const routename = 'HeartPage';

  @override
  State<HP2> createState() => _HP2();
}

class _HP2 extends State<HP2> {
  @override
  void initState() {
    super.initState();
  } //initState

  @override
  Widget build(BuildContext context) {
    print('${HP2.routename} built');
    return Scaffold(
        appBar: AppBar(
          title: Text(HP2.routename),
        ),

        // ignore: prefer_const_literals_to_create_immutables
        body: Center(
            child: FutureBuilder(
                future: _getCaloriesToday(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('${snapshot.data}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                })));
  } //Build

  // functions

  Future<void> getTodayHeartData() async {
    FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(
      clientID: FitbitAppCredentials.clientID,
      clientSecret: FitbitAppCredentials.clientSecret,
    );
    final sp = await SharedPreferences.getInstance();
    FitbitHeartAPIURL fitbitHeartApiUrl = FitbitHeartAPIURL.dayWithUserID(
      date: DateTime.now(),
      userID: sp.getString('username'),
    );
    List<FitbitData> fitbitHeartData =
        await fitbitHeartDataManager.fetch(fitbitHeartApiUrl);
    FitbitHeartData fitbitHeartData2 = fitbitHeartData[0] as FitbitHeartData;
    Heart heart = Heart(null, fitbitHeartData2.restingHeartRate,
        DateTime.now().toString(), fitbitHeartData2.minutesCardio);
    await Provider.of<DatabaseRepository>(context, listen: false)
        .insertHeart(heart);
  }

  Future<void> _getCaloriesToday() async {
    final heart = await Provider.of<DatabaseRepository>(context, listen: false)
        .getHeartByDay(DateTime.now().toString());
  }
} //Page


     
