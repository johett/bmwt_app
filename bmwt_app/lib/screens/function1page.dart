import 'dart:async';
import 'dart:math';

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
  // this var helps me to delay the loading time of the barchart
  var _isLoading = false;
  //this int sets the step goal; default 10000
  double stepGoal = 1000.0;
  double dummyNumber = 0;

  late List<_ChartData> data = [];

  late TooltipBehavior _tooltip;
  late _WeeklySteps getChartData = _WeeklySteps();
  TextEditingController _textFieldController = TextEditingController();

  double? maxChartHeight = 20000;
  // todo: make it dynamic

  var sp;
  var fitbitActivityData;

  @override
  initState() {
    // one API call for getting the data of one week
    getAllData();

    // initiliaze the data for the chart

    //fill chart data with new data entries
    //Function1Page().data[i].y = fitbitActivityData[i].value!;

    getChartData.inputList(fitbitActivityData);

    //data = getChartData.fetchedData;
    _isLoading = true;

    _tooltip =
        TooltipBehavior(enable: true, color: Colors.grey, header: "Steps on");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('${Function1Page.routename} built');

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
            Row(children: [
              _isLoading
                  ? SfCartesianChart(
                      isTransposed: true,
                      title: ChartTitle(
                          text: "Daily steps overview of the last 7 days",
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: maxChartHeight,
                          interval: 1000,
                          title: AxisTitle(text: "Steps")),
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
                  : const CircularProgressIndicator()
            ]),
            Row(
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
                      return Text('Average of last 7 days: ${snapshot.data}');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.directions_walk_rounded,
                color: Colors.blue,
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

//gets all the data with the API call in the beginning, therefore we have less API calls in total
  void getAllData() async {
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
  }

// this function returns the daily steps.
//input: days will be substracted from todays date e.g. days=1 is yesterday, days=2 is two days before etc.
  Future<double?> _DailySteps(int days) async {
    await Future.delayed(const Duration(seconds: 2));

    return fitbitActivityData[0].value;
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
    return (sum! / 7).roundToDouble();
  }

  Future<String> _Recommendation() async {
    var averageSteps = await _AverageSteps();
    var todaysSteps = await _DailySteps(0); // steps today

    if (todaysSteps! < stepGoal) {
      return "You have still some steps to walk to reach your personal step goal. Let's go!";
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

//TODO:make this class in an own folder
class _WeeklySteps {
  _WeeklySteps();
  List<_ChartData> fetchedData = [];

  void inputList(var fitbitActivityData) async {
    //SET input parameters
    //List<_ChartData> data = Function1Page().data;
    Timer(Duration(seconds: 1), () {
      for (var i = 0; i < 7; i++) {
        fetchedData.add(_ChartData(fitbitActivityData[i].dateTime.toString(),
            fitbitActivityData[i].value!));
        print("DEBUG" + fetchedData[i].y.toString());

        //fill chart data with new data entries
        //Function1Page().data[i].y = fitbitActivityData[i].value!;

      }
    });

    //TODO: dynamic chart height
    /* maxChartHeight = stepsList.reduce(
        (curr, next) => curr! > double.parse(next.toString()) ? curr : next); */
    //print(maxChartHeight);
  }

  List<_ChartData> getChartData() {
    return fetchedData;
  }
}
