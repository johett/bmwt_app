import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const routename = 'Your Steps Overview';

  //this int sets the step goal; default 10000
  double stepGoal = 10000.0;
  double dummyNumber = 0;

  late List<_ChartData> data = [];

//initialize variables for the chart
  late TooltipBehavior _tooltip;
  TextEditingController _textFieldController = TextEditingController();
  double? maxChartHeight = 20000;
  // todo: make it dynamic

//general variables for the API call
  var sp;
  var fitbitActivityData;

//variables for the steps
  double averageSteps = 0.0;
  double todaysSteps = 0.0;

  @override
  initState() {
    // one API call for getting the data of one week
    getAllData();

    // initiliaze the data for the chart
    _tooltip = TooltipBehavior(
      enable: true,
      color: Colors.grey,
      header: "Daily steps",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Function1Page.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _Recommendation(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      Icon(
                          snapshot.data.toString().startsWith("Hurray")
                              ? Icons.verified_outlined
                              : Icons.rocket_launch,
                          color: snapshot.data.toString().startsWith("Hurray")
                              ? Colors.green
                              : Colors.red),
                      Flexible(
                          child: Text(
                        '${snapshot.data}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: snapshot.data.toString().startsWith("Hurray")
                                ? Colors.green
                                : Colors.redAccent),
                      )),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator(
                    color: Colors.yellow,
                  );
                }
              },
            ),
            FutureBuilder(
              future: getAllData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SfCartesianChart(
                            isTransposed: true,
                            title: ChartTitle(
                                text: "Daily steps overview of the last 7 days",
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            primaryXAxis: CategoryAxis(labelRotation: 90),
                            primaryYAxis: NumericAxis(
                                numberFormat: NumberFormat.compact(),
                                minimum: 0,
                                maximum: maxChartHeight,
                                interval: 1000,
                                title: AxisTitle(text: "Steps"),
                                plotBands: <PlotBand>[
                                  PlotBand(
                                    isVisible: true,
                                    start: stepGoal,
                                    end: stepGoal,
                                    borderWidth: 2,
                                    borderColor: Colors.blue,
                                    text: "Your personal goal",
                                    textAngle: 0,
                                    horizontalTextAlignment: TextAnchor.end,
                                    verticalTextAlignment: TextAnchor.middle,
                                    textStyle: TextStyle(
                                        color: Colors.blue, fontSize: 12),
                                  ),
                                  PlotBand(
                                    isVisible: true,
                                    start: averageSteps,
                                    end: averageSteps,
                                    borderWidth: 2,
                                    borderColor: Colors.grey,
                                    text: "Average",
                                    horizontalTextAlignment: TextAnchor.end,
                                    verticalTextAlignment: TextAnchor.middle,
                                    textStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  )
                                ]),
                            tooltipBehavior: _tooltip,
                            series: <ChartSeries<_ChartData, String>>[
                              BarSeries<_ChartData, String>(
                                  dataSource: data,
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) => data.y,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  name: 'Test',
                                  color: Color.fromARGB(255, 255, 210, 8))
                            ])
                      ]);
                } else {
                  return const CircularProgressIndicator(
                    color: Colors.yellow,
                  );
                }
              },
            ),
            FutureBuilder(
                future: getAllData(),
                builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timeline,
                        color: Colors.blue,
                      ),
                      FutureBuilder(
                        future: _AverageSteps(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                                'Average of last 7 days: ${snapshot.data}');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  );
                }),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.directions_walk_rounded,
                color: Colors.blue,
              ),
              FutureBuilder(
                future: _getTodaysSteps(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Steps today: ${snapshot.data}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ]),
            FlatButton(
                // foreground
                onPressed: () {},
                child: Row(children: [
                  Text('Your current step goal is: $stepGoal'),
                  IconButton(
                    icon: const Icon(
                      Icons.flag_circle_rounded,
                      color: Colors.blue,
                      size: 50.0,
                    ),
                    tooltip: 'Set your new daily step goal',
                    onPressed: () {
                      setState(() {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Set your new step goal here'),
                            content: TextField(
                              onChanged: (value) {
                                setState(() {
                                  dummyNumber = double.parse(value);
                                });
                              },
                              controller: _textFieldController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "Text Field in Dialog"),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    {Navigator.pop(context, 'Cancel')},
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => setState(() {
                                  Navigator.pop(context, 'Set new goal');
                                  stepGoal = dummyNumber;
                                }),
                                child: const Text('Set new goal'),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                ])),
          ],
        ),
      ),
    );
  } //build

//output: gets all the data with the API call in the beginning, therefore we have less API calls in total
  Future<List<FitbitActivityTimeseriesData>> getAllData() async {
    FitbitActivityTimeseriesDataManager fitbitActivityDataManager =
        FitbitActivityTimeseriesDataManager(
            clientID: FitbitAppCredentials.clientID,
            clientSecret: FitbitAppCredentials.clientSecret,
            type: 'steps');

    sp = await SharedPreferences.getInstance();

    FitbitActivityTimeseriesAPIURL fitbitActivityApiUrl =
        FitbitActivityTimeseriesAPIURL.weekWithResource(
            baseDate: DateTime.now().subtract(const Duration(days: 0)),
            userID: sp.getString('username'),
            resource: 'steps');

    fitbitActivityData = await fitbitActivityDataManager
        .fetch(fitbitActivityApiUrl) as List<FitbitActivityTimeseriesData>;

    var max = 0.0;
//fill the data variable for the chart data
    for (var i = 0; i < 7; i++) {
      data.add(_ChartData(
          DateFormat("EEEE dd.MM.yy").format(DateTime.parse(
              fitbitActivityData[i]
                  .dateOfMonitoring
                  .toString()
                  .substring(0, 10)
                  .toString())),
          fitbitActivityData[i].value!));
      if (fitbitActivityData[i].value! > max) {
        max = fitbitActivityData[i].value!;
      }
    }
    maxChartHeight = max.round() + 1000;
    return fitbitActivityData;
  }

// this function returns the steps of today
  Future<double?> _getTodaysSteps() async {
    await Future.delayed(const Duration(seconds: 2));

    todaysSteps = fitbitActivityData[6].value;

    return fitbitActivityData[6].value;
  }

  //output: returns average steps of the last 7 days or the last 30 days
  // input: range of average can be selected, "week" or "month"
  Future<double?> _AverageSteps() async {
    var fitBitData = await fitbitActivityData;

    List<double?> stepsList = [];
    double? sum = 0.0;

    Timer(Duration(seconds: 1), () {
      for (var i = 0; i < fitBitData.length; i++) {
        //stepsList.add(fitbitActivityData[i].value);
        sum = sum! + fitbitActivityData[i].value!;
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    averageSteps = (sum! / 7).roundToDouble();
    return (sum! / 7).roundToDouble();
  }

// this method gives a recommendation/motivational message based on if the goal is reached or not
  Future<String> _Recommendation() async {
    var today = todaysSteps;

    if (today! < stepGoal) {
      return "You have still some steps to walk to reach your personal step goal. Let's go!";
    } else {
      return "Hurray, your reached your average steps! Keep going to reach your daily goal!";
    }
  }
}
//Page

/* this class defines the data format for the bar chart
*/
class _ChartData {
  _ChartData(this.x, this.y);

// category axis
  String x;
  // numeric axis
  double y;
}
