import 'package:bmwt_app/utility/credentials.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// body is managed by CardManager
  @override
  Widget build(BuildContext context) {
    print('${LastWeekHeart.routename} built');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            LastWeekHeart.routename,
          ),
        ),
        body: CardManager());
    ;
  }

  //*FUNCTIONS*********************/

}

// manages the page
class CardManager extends StatefulWidget {
  CardManager({Key? key}) : super(key: key);
  @override
  State<CardManager> createState() => _CardManager();
}

class _CardManager extends State<CardManager> {
  List<FitbitHeartData>? data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder(
                future: getLastWeekHearts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    data = snapshot.data as List<FitbitHeartData>;
                    return new Scaffold(
                      body: SingleChildScrollView(
                        child: Column(children: [
                          for (int i = 0; i < data!.length; i++)
                            HeartCard(data: data![i])
                        ]),
                      ),
                    );
                  } else {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                })));
  }

// This function fetches data regarding previous week
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
}

//****************************HEARTCARD************************************** */
class HeartCard extends StatefulWidget {
  final FitbitHeartData? data;
  HeartCard({Key? key, required this.data}) : super(key: key);
  @override
  State<HeartCard> createState() => _HeartCard();
}

class _HeartCard extends State<HeartCard> {
  @override
  void initState() {
    super.initState();
  }

// This widget visualizes the data passed upon
  @override
  Widget build(BuildContext context) {
    body:
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Date:  ${widget.data!.dateOfMonitoring.toString().substring(0, 10)} ',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Cardio: ${widget.data!.caloriesCardio!.roundToDouble().toString()}',
                    ),
                    Text(
                      'Minutes Cardio: ${widget.data!.minutesCardio.toString()}',
                    ),
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Minutes Peak: ${widget.data!.minutesPeak.toString()}',
                  ),
                  Text(
                    'Minutes burning fat: ${widget.data!.minutesFatBurn.toString()} ',
                  ),
                ])
              ]),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ),
    );
  }
}
