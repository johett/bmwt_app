import 'package:bmwt_app/screens/lastWeekHeart.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/screens/loginpage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HP3 extends StatefulWidget {
  HP3({Key? key}) : super(key: key);

  static const route = '/hp3';
  static const routename = 'HP3';

  @override
  State<HP3> createState() => _HP3State();
}

class _HP3State extends State<HP3> {
  String HR = '0';
  String Calories = '0';
  String minutesFatBurn = '0';
  String minutesCardio = '0';
  String minutesPeak = '0';
  FitbitHeartData? heart = null;

  @override
  void initState() {
    _getData();
    super.initState();
    //Check if the user is already logged in before rendering the login page
  } //ini

  @override
  Widget build(BuildContext context) {
    if (heart == null) {
      return new Scaffold(
        appBar: AppBar(title: Text("loading...")),
      );
    }

    print('${HP3.routename} built');
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
          Expanded(
              child: Page(
                  HR, Calories, minutesCardio, minutesPeak, minutesFatBurn))
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
  // functions

  Future<FitbitHeartData> getTodayHeart() async {
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
    print(fitbitHeartData2);
    return fitbitHeartData2;
  }

  Future<void> _getHeartRateNow(FitbitHeartData h) async {
    setState(() {
      HR = h.restingHeartRate.toString();
    });
  }

  Future<void> _getMinutesFatBurnNow(FitbitHeartData h) async {
    setState(() {
      minutesFatBurn = h.minutesFatBurn.toString();
    });
  }

  Future<void> _getMinutesCardioNow(FitbitHeartData h) async {
    setState(() {
      minutesCardio = h.minutesCardio.toString();
    });
  }

  Future<void> _getMinutesPeakNow(FitbitHeartData h) async {
    setState(() {
      minutesPeak = h.minutesPeak.toString();
    });
  }

  Future<void> _getCaloriesNow(FitbitHeartData h) async {
    setState(() {
      Calories = h.caloriesCardio.toString();
    });
  }

  Future<void> _getData() async {
    FitbitHeartData h = await getTodayHeart();
    setState(() {
      heart = h;
    });
    await _getHeartRateNow(heart!);
    await _getMinutesFatBurnNow(heart!);
    await _getMinutesCardioNow(heart!);
    await _getMinutesPeakNow(heart!);
    await _getCaloriesNow(heart!);
  }
} //Page

//**********************************PAGE */
class Page extends StatelessWidget {
  final String hr;
  final String minutesCardio;
  final String minutesPeak;
  final String minutesFatBurn;
  final String caloriesCardio;

  Page(this.hr, this.caloriesCardio, this.minutesCardio, this.minutesPeak,
      this.minutesFatBurn) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeartRateWidget(hr),
        CaloriesCardioWidget(caloriesCardio),
        MinutesCardioWidget(minutesCardio),
        MinutesPeakWidget(minutesPeak),
        MinutesFatBurnWidget(minutesFatBurn)
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
              Icons.heart_broken,
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
        child: Text('${caloriesCardio}', style: const TextStyle(fontSize: 18)),
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
