import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmwt_app/database/entities/heart.dart';
import 'package:bmwt_app/database/database.dart';

class LastWeekHeart extends StatefulWidget {
  const LastWeekHeart({Key? key}) : super(key: key);

  static const route = '/lastWeekHeart';
  static const routename = 'Last week heart data';

  @override
  State<LastWeekHeart> createState() => _LastWeekHeart();
}

class _LastWeekHeart extends State<LastWeekHeart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('${LastWeekHeart.routename} built');
    return Scaffold(
        appBar: AppBar(
          title: Text(LastWeekHeart.routename),
        ),
        body: CardManager());
    ;
  }

  //*FUNCTIONS*********************/

}

class CardManager extends StatefulWidget {
  CardManager({Key? key}) : super(key: key);
  @override
  State<CardManager> createState() => _CardManager();
}

class _CardManager extends State<CardManager> {
  List<FitbitHeartData>? data;
  @override
  void initState() {
    gethearts();
    super.initState();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return new Scaffold(
        appBar: AppBar(title: Text("loading")),
      );
    } else {
      body:
      return Column(
        children: [
          Card(data: data![0]),
          Card(data: data![1]),
          Card(data: data![2]),
          Card(data: data![3]),
          Card(data: data![4]),
          Card(data: data![5]),
          Card(data: data![6]),
        ],
      );
    }
  }

  Future<List<FitbitHeartData>> getLastWeekHearts() async {
    FitbitHeartDataManager fitbitHeartDataManager = FitbitHeartDataManager(
      clientID: FitbitAppCredentials.clientID,
      clientSecret: FitbitAppCredentials.clientSecret,
    );
    final sp = await SharedPreferences.getInstance();
    FitbitHeartAPIURL fitbitHeartApiUrl = FitbitHeartAPIURL.weekWithUserID(
      baseDate: DateTime.now().subtract(Duration(days: 1)),
      userID: sp.getString('username'),
    );
    List<FitbitData> fitbitHeartData =
        await fitbitHeartDataManager.fetch(fitbitHeartApiUrl);
    return fitbitHeartData as List<FitbitHeartData>;
  }

  Future<void> gethearts() async {
    data = await getLastWeekHearts();
    setState(() {
      data = data;
    });
  }
}

class Card extends StatefulWidget {
  final FitbitHeartData? data;
  Card({Key? key, required this.data}) : super(key: key);
  @override
  State<Card> createState() => _Card();
}

class _Card extends State<Card> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    body:
    return Column(
      children: [
        Text(widget.data!.dateOfMonitoring.toString()),
        Text(widget.data!.caloriesCardio.toString()),
        Text(widget.data!.minutesCardio.toString()),
        Text(widget.data!.minutesPeak.toString()),
        Text(widget.data!.minutesFatBurn.toString()),
      ],
    );
  }
}
