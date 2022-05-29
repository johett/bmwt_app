<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
=======
import 'dart:ffi';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/credentials.dart';
>>>>>>> devjo

class Function1Page extends StatelessWidget {
  Function1Page({Key? key}) : super(key: key);

  static const route = '/function1';
  static const routename = 'Function1Page';
<<<<<<< HEAD
  
=======

>>>>>>> devjo
  @override
  Widget build(BuildContext context) {
    print('${Function1Page.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(Function1Page.routename),
      ),
      body: Center(
<<<<<<< HEAD
        child: Text('Function1 to be implemented'),
=======
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _AverageSteps("week"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Average of last 7 days: ${snapshot.data}');
                } else
                  return CircularProgressIndicator();
              },
            ),
            FutureBuilder(
              future: _DailySteps(0),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Steps today: ${snapshot.data}');
                } else
                  return CircularProgressIndicator();
              },
            ),
          ],
        ),
>>>>>>> devjo
      ),
    );
  } //build

<<<<<<< HEAD
} //Page
=======
// this function returns the daily steps.
//input: days will be substracted from todays date e.g. days=1 is yesterday, days=2 is two days before etc.
  Future<String> _DailySteps(int days) async {
    FitbitActivityTimeseriesDataManager fitbitActivityDataManager =
        FitbitActivityTimeseriesDataManager(
            clientID: FitbitAppCredentials.clientID,
            clientSecret: FitbitAppCredentials.clientSecret,
            type: 'steps');
    final sp = await SharedPreferences.getInstance();

    FitbitActivityTimeseriesAPIURL fitbitActivityApiUrl =
        FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now().subtract(Duration(days: days)),
      userID: sp.getString('username'),
      resource: 'steps',
    );
    final fitbitActivityData = await fitbitActivityDataManager
        .fetch(fitbitActivityApiUrl) as List<FitbitActivityTimeseriesData>;
    return fitbitActivityData.toString().split(",")[3].substring(7).trim();
  }

  //output: returns average steps of the last 7 days or the last 30 days
  // input: range of average can be selected, "week" or "month"
  Future<double> _AverageSteps(String range) async {
    var sum = 0.0;
    var n = 0;
    var dummy;
    var dummy2;

    if (range == "week") {
      n = 7;
    } else {
      n = 30;
    }

    for (var i = 0; i < n; i++) {
      // here we just add as string
      dummy = await _DailySteps(i);
      // parsing to double
      dummy2 = double.parse(dummy);
      print(dummy2);
      //add to the sum
      sum += dummy2;
    }

    return (sum / n).roundToDouble();
  }
} //Page
>>>>>>> devjo
