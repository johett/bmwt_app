//import 'dart:html';

import 'dart:math';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utility/credentials.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({Key? key}) : super(key: key);

  static const route = '/calorieshome';
  static const routename = 'CaloriesHomePage';

  @override
  State<StepsPage> createState() => Function1Page();
}

class Function1Page extends State<StepsPage> {
  static const route = '/function1';
  static const routename = 'Function1Page';
  double? maxChartHeight = 20000;
  late List<_ChartData> data;
  /*= [
    _ChartData('A', 1000),
    _ChartData('B', 3000),
    _ChartData('C', 0),
    _ChartData('D', 0),
    _ChartData('E', 0),
    _ChartData('X', 0),
    _ChartData('Y', 0)
  ]; */

  late TooltipBehavior? _tooltip = TooltipBehavior(enable: true);

  @override
  initState() {
    // initiliaze the data for the chart
    _WeeklySteps();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('${Function1Page.routename} built');

    return Scaffold(
      appBar: AppBar(
        title: const Text(Function1Page.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*FutureBuilder(
              future: _WeeklySteps(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Weekly overview: ${snapshot.data}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ), */

            FutureBuilder(
              future: _Recommendation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            SfCartesianChart(
                isTransposed: true,
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                    minimum: 0, maximum: maxChartHeight, interval: 1000),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  BarSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      name: 'Gold',
                      color: Color.fromRGBO(8, 142, 255, 1))
                ]),
            FutureBuilder(
              future: _AverageSteps(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Average of last 7 days: ${snapshot.data}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            FutureBuilder(
              future: _DailySteps(0),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Steps today: ${snapshot.data}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  } //build

// this function returns the daily steps.
//input: days will be substracted from todays date e.g. days=1 is yesterday, days=2 is two days before etc.
  Future<double?> _DailySteps(int days) async {
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
    return fitbitActivityData[0].value;
  }

  //outout: steps of a week
  //Future<List<double?>>
  void _WeeklySteps() async {
    FitbitActivityTimeseriesDataManager fitbitActivityDataManager =
        FitbitActivityTimeseriesDataManager(
            clientID: FitbitAppCredentials.clientID,
            clientSecret: FitbitAppCredentials.clientSecret,
            type: 'steps');
    final sp = await SharedPreferences.getInstance();

    FitbitActivityTimeseriesAPIURL fitbitActivityApiUrl =
        FitbitActivityTimeseriesAPIURL.weekWithResource(
      baseDate: DateTime.now().subtract(const Duration(days: 0)),
      userID: sp.getString('username'),
      resource: 'steps',
    );
    final fitbitActivityData = await fitbitActivityDataManager
        .fetch(fitbitActivityApiUrl) as List<FitbitActivityTimeseriesData>;

    List<double?> stepsList = [];

    for (var i = 0; i < fitbitActivityData.length; i++) {
      stepsList.add(fitbitActivityData[i].value);

      //fill chart data with new data entries
      data[i].y = fitbitActivityData[i].value!;
      print("data in datalist number $i :" + data[i].y.toString());
      print("steps at day $i :" + fitbitActivityData[i].value!.toString());
    }

    maxChartHeight = stepsList.reduce(
        (curr, next) => curr! > double.parse(next.toString()) ? curr : next);
    //print(maxChartHeight);

    //return stepsList;
  }

  //output: returns average steps of the last 7 days or the last 30 days
  // input: range of average can be selected, "week" or "month"
  Future<double?> _AverageSteps() async {
    FitbitActivityTimeseriesDataManager fitbitActivityDataManager =
        FitbitActivityTimeseriesDataManager(
            clientID: FitbitAppCredentials.clientID,
            clientSecret: FitbitAppCredentials.clientSecret,
            type: 'steps');
    final sp = await SharedPreferences.getInstance();

    FitbitActivityTimeseriesAPIURL fitbitActivityApiUrl =
        FitbitActivityTimeseriesAPIURL.weekWithResource(
      baseDate: DateTime.now()
          .subtract(const Duration(days: 1)), //today is not included in average
      userID: sp.getString('username'),
      resource: 'steps',
    );
    final fitbitActivityData = await fitbitActivityDataManager
        .fetch(fitbitActivityApiUrl) as List<FitbitActivityTimeseriesData>;
    //return fitbitActivityData.toString().split(",")[3].substring(7).trim();

    List<double?> stepsList = [];
    double? sum = 0.0;

    for (var i = 0; i < fitbitActivityData.length; i++) {
      //stepsList.add(fitbitActivityData[i].value);
      sum = sum! + fitbitActivityData[i].value!;
    }

    return (sum! / 7).roundToDouble();
  }

  Future<String> _Recommendation() async {
    var averageSteps = await _AverageSteps();
    var todaysSteps = await _DailySteps(0); // steps today

    if (todaysSteps! < averageSteps!) {
      return "You have still some steps to make to reach your average steps. Let's go!";
    } else {
      return "Hurray, your reached your average steps! Keep going to reach your daily goal!";
    }
  }
} //Page

class _ChartData {
  _ChartData(this.x, this.y);

  String x;
  double y;
}
