import 'package:bmwt_app/database/entities/heartGoals.dart';
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

class HP3 extends StatelessWidget {
  HP3({Key? key}) : super(key: key);

  static const route = '/hp3';
  static const routename = 'HP3';
  Color base = Color.fromARGB(255, 119, 41, 83);
  Color darkBase = Color.fromARGB(255, 44, 0, 30);
  Color accent = Color.fromARGB(255, 233, 86, 32);

  @override
  Widget build(BuildContext context) {
    TextStyle accentText = TextStyle(color: accent);
    print('${HP3.routename} built');
    return Scaffold(
        body: Center(
            child: FutureBuilder(
      future: getTodayHeart(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: base,
            appBar: AppBar(
              title: Text('Today', style: accentText),
              backgroundColor: darkBase,
            ),
            body: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LastWeekHeart.route);
                  },
                  icon: Icon(Icons.arrow_left_rounded),
                  color: accent,
                ),
                Expanded(child: Page(snapshot.data as FitbitHeartData))
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          );
        } else {
          return Scaffold(
              backgroundColor: darkBase,
              body: Center(
                  child: CircularProgressIndicator(
                color: accent,
              )));
        }
      },
    )));
  }
  // functions

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
        return FutureBuilder(
            initialData: null,
            future: dbr.getHeartGoals(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var goals = snapshot.data as List<HeartGoals>;
                return Column(
                  children: [
                    HeartRateWidget(h.restingHeartRate.toString()),
                    CaloriesCardioWidget(
                        h.caloriesCardio.toString(), goals[0].goalCalories),
                    MinutesCardioWidget(
                        h.minutesCardio.toString(), goals[0].minutesCardio),
                    MinutesPeakWidget(
                        h.minutesPeak.toString(), goals[0].minutesPeak),
                    MinutesFatBurnWidget(
                        h.minutesFatBurn.toString(), goals[0].minutesBurningFat)
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
        padding: const EdgeInsets.all(8.0),
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

class MinutesCardioWidget extends StatelessWidget {
  final String minutesCardio;
  double progress = 0;
  int goal;
  MinutesCardioWidget(this.minutesCardio, this.goal) {
    progress = double.parse(minutesCardio);
    progress = progress / goal;
    if (progress >= 1) {
      progress = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("Minutes at cardio", style: const TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${minutesCardio} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Colors.blueGrey,
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
        padding: const EdgeInsets.all(8.0),
        child: Text('${caloriesCardio} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Colors.blueGrey,
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
        padding: const EdgeInsets.all(8.0),
        child: Text('${minutesPeak} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Colors.blueGrey,
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
        padding: const EdgeInsets.all(8.0),
        child: Text('${minutesFatBurn} / ${goal}',
            style: const TextStyle(fontSize: 18)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
        child: LinearProgressIndicator(
          value: progress,
          color: progress == 1 ? Colors.green : Colors.amber,
          backgroundColor: Colors.blueGrey,
        ),
      )
    ]);
  }
}