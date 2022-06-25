import 'package:bmwt_app/screens/lastWeekHeart.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/assets/customIcons/my_flutter_app_icons.dart';

class HP3 extends StatelessWidget {
  HP3({Key? key}) : super(key: key);

  static const route = '/hp3';
  static const routename = 'HP3';

  @override
  Widget build(BuildContext context) {
    print('${HP3.routename} built');
    return Scaffold(
        body: Center(
            child: FutureBuilder(
      future: getTodayHeart(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Today'),
            ),
            body: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LastWeekHeart.route);
                    },
                    icon: Icon(Icons.arrow_left_rounded)),
                Expanded(child: Page(snapshot.data as FitbitHeartData))
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
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
    return Column(
      children: [
        HeartRateWidget(h.restingHeartRate.toString()),
        CaloriesCardioWidget(h.caloriesCardio.toString()),
        MinutesCardioWidget(h.minutesCardio.toString()),
        MinutesPeakWidget(h.minutesPeak.toString()),
        MinutesFatBurnWidget(h.minutesFatBurn.toString())
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              size: 48,
            ),
            Text(
              '${hr}',
              style: const TextStyle(fontSize: 18),
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
  MinutesCardioWidget(this.minutesCardio) {
    progress = double.parse(minutesCardio);
    progress = progress / 30;
    if (progress >= 1) {
      progress = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("minutes at cardio", style: const TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${minutesCardio}', style: const TextStyle(fontSize: 18)),
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
  CaloriesCardioWidget(this.caloriesCardio) {
    progress = double.parse(caloriesCardio);
    progress = progress / 300;
    if (progress >= 1) {
      progress = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("calories burned at cardio", style: const TextStyle(fontSize: 20)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${double.parse(caloriesCardio).round()}',
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
  MinutesPeakWidget(this.minutesPeak) {
    progress = double.parse(minutesPeak);
    progress = progress / 15;
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
        child: Text('${minutesPeak}', style: const TextStyle(fontSize: 18)),
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
  MinutesFatBurnWidget(this.minutesFatBurn) {
    progress = double.parse(minutesFatBurn);
    progress = progress / 5;
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
        child: Text('${minutesFatBurn}', style: const TextStyle(fontSize: 18)),
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
