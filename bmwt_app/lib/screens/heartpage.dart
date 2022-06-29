import 'package:bmwt_app/database/entities/heartGoals.dart';
import 'package:bmwt_app/screens/changeHeartGoals.dart';
import 'package:bmwt_app/screens/lastWeekHeart.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/assets/customIcons/my_flutter_app_icons.dart';

import '../repositories/databaseRepository.dart';

class HeartPage extends StatelessWidget {
  HeartPage({Key? key}) : super(key: key);

  static const route = '/heartPage';
  static const routename = 'HeartPage';

  @override
  Widget build(BuildContext context) {
    print('${HeartPage.routename} built');
    return Scaffold(
        body: Center(
            //fetch heart Data
            child: FutureBuilder(
      future: getTodayHeart(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Today's heart status"),
            ),
            body: Row(
              children: [
                //Button to call Page regarding last week data
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LastWeekHeart.route);
                  },
                  icon: Icon(Icons.arrow_left_rounded),
                ),
                // Calling widget named Page
                Expanded(
                  child: Page(snapshot.data as FitbitHeartData),
                  flex: 1,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          );
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    )));
  }

  // functions
//Function to get heart data
  Future<FitbitHeartData?> getTodayHeart() async {
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
    FitbitHeartData? heart = fitbitHeartData[0] as FitbitHeartData;
    print(heart);
    return heart;
  }
} //Page

//**********************************PAGE */
class Page extends StatelessWidget {
  final FitbitHeartData h;

  Page(this.h) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Consumer<DatabaseRepository>(builder: ((context, dbr, child) {
        // Check for goals regarding the Heart
        return FutureBuilder(
            initialData: null,
            future: dbr.getHeartGoals(),
            builder: ((context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                var goals = snapshot.data as List<HeartGoals>;
                if (goals.length == 0) {
                  // If no heart  goals are present these are initialized(calories: 500, Minutes cardio:10, minutesPeak:10, minutes burning fat:10)
                  goals.add(HeartGoals(0, 500, 10, 10, 10));
                }
                //Page layout
                return Column(
                  children: [
                    HeartRateWidget(h.restingHeartRate.toString()),
                    CaloriesCardioWidget(
                        h.caloriesCardio.toString(), goals[0].goalCalories),
                    MinutesCardioWidget(
                        h.minutesCardio.toString(), goals[0].minutesCardio),
                    MinutesPeakWidget(
                        h.minutesPeak.toString(), goals[0].minutesPeak),
                    MinutesFatBurnWidget(h.minutesFatBurn.toString(),
                        goals[0].minutesBurningFat),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ChangeHeartGoals.route);
                        },
                        child: Text('Change goals'))
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                );
              } else
                return Scaffold(
                    body: Center(
                  child: CircularProgressIndicator(),
                ));
            }));
      }))),
    );
  }
}
//*******************************************Widgets */

//Creates heartrate at rest
class HeartRateWidget extends StatelessWidget {
  final String hr;

  HeartRateWidget(this.hr) {}

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Heart Rate at rest",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Icon(
              MyFlutterApp.heart,
              color: Color.fromARGB(255, 197, 17, 17),
              size: 60,
            ),
            Text(
              '${hr}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
          alignment: AlignmentDirectional.center,
        ),
      ),
    ]);
  }
}

// creates minutes at cardio, values is passed onto by Page Widget, progress is visualized with linear progress indicator
class MinutesCardioWidget extends StatelessWidget {
  final String minutesCardio;
  double progress = 0;
  int goal;
  MinutesCardioWidget(this.minutesCardio, this.goal) {
    progress = double.parse(minutesCardio);
    (goal != 0)
        ? progress = progress / goal
        : progress = 1; // to avoid division by zero
    if (progress >= 1) {
      progress = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Minutes at cardio", style: const TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text('${minutesCardio} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Theme.of(context).focusColor,
        ),
      )
    ]);
  }
}

class CaloriesCardioWidget extends StatelessWidget {
  final String caloriesCardio;
  double progress = 0;
  int goal;
  CaloriesCardioWidget(this.caloriesCardio, this.goal) {
    progress = double.parse(caloriesCardio);
    (goal != 0) ? progress = progress / goal : progress = 1;
    progress = progress / goal;
    if (progress >= 1) {
      progress = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Calories burned at cardio", style: const TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
            '${double.parse(caloriesCardio).toStringAsFixed(1)} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Theme.of(context).focusColor,
        ),
      )
    ]);
  }
}

class MinutesPeakWidget extends StatelessWidget {
  final String minutesPeak;
  double progress = 0;
  int goal;
  MinutesPeakWidget(this.minutesPeak, this.goal) {
    progress = double.parse(minutesPeak);
    (goal != 0) ? progress = progress / goal : progress = 1;
    progress = progress / goal;
    if (progress >= 1) {
      progress = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Minutes at peak", style: const TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text('${minutesPeak} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Theme.of(context).focusColor,
        ),
      )
    ]);
  }
}

class MinutesFatBurnWidget extends StatelessWidget {
  final String minutesFatBurn;
  double progress = 0;
  int goal;
  MinutesFatBurnWidget(this.minutesFatBurn, this.goal) {
    progress = double.parse(minutesFatBurn);
    (goal != 0) ? progress = progress / goal : progress = 1;
    progress = progress / goal;
    if (progress >= 1) {
      progress = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Minutes burning fat", style: const TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text('${minutesFatBurn} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Theme.of(context).focusColor,
        ),
      )
    ]);
  }
}
