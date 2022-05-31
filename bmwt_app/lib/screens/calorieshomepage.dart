import 'package:bmwt_app/screens/caloriesWSpage.dart';
import 'package:bmwt_app/utility/senData2.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/credentials.dart';

class CaloriesHomePage extends StatefulWidget {
  const CaloriesHomePage({Key? key}) : super(key: key);

  static const route = '/calorieshome';
  static const routename = 'CaloriesHomePage';

  @override
  State<CaloriesHomePage> createState() => _CaloriesHomePageState();
}

class _CaloriesHomePageState extends State<CaloriesHomePage> {

  @override
  void initState(){
    super.initState();
  }//initState

  @override
  Widget build(BuildContext context) {
    print('${CaloriesHomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(CaloriesHomePage.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              FutureBuilder(
              future: _bmrFitbit(),
              builder: (context, snapshot) {
                if(snapshot.hasData)
                {
                  return Text('Your BMR calculated by Fitbit is ${snapshot.data}');
                }
                else {
                  return const CircularProgressIndicator();
                }
              },
              ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: _measuredBMR(),
                  builder:(context,snapshot){
                    if(snapshot.hasData){
                      return Text('BMR: ${snapshot.data}');
                  }
                  else {
                      return const CircularProgressIndicator();
                    }
                  }
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? measuredBMR=sp.getDouble('measuredBMR')!-10.0;
                    sp.setDouble('measuredBMR', measuredBMR);
                    setState(() {});
                  },
                  child: const Text('-10'),
                  ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? measuredBMR=sp.getDouble('measuredBMR')!-1.0;
                    sp.setDouble('measuredBMR', measuredBMR);
                    setState(() {});
                  },
                  child: const Text('-1'),
                  ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? measuredBMR=sp.getDouble('measuredBMR')!+1.0;
                    sp.setDouble('measuredBMR', measuredBMR);
                    setState(() {});
                  },
                  child: const Text('+1'),
                  ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? measuredBMR=sp.getDouble('measuredBMR')!+10.0;
                    sp.setDouble('measuredBMR', measuredBMR);
                    setState(() {});
                  },
                  child: const Text('+10'),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 FutureBuilder(
                   future: _thresholdCalories(),
                   builder: (context, snapshot){
                     if(snapshot.hasData){
                       return Text('Diet kcal per day: ${snapshot.data}');
                     }
                     else {
                       return const CircularProgressIndicator();
                     }
                   },
                   ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? thresholdCalories=sp.getDouble('thresholdCalories')!-10.0;
                    sp.setDouble('thresholdCalories', thresholdCalories);
                    setState(() {});
                  },
                  child: const Text('-10'),
                  ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? thresholdCalories=sp.getDouble('thresholdCalories')!-1.0;
                    sp.setDouble('thresholdCalories', thresholdCalories);
                    setState(() {});
                  },
                  child: const Text('-1'),
                  ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? thresholdCalories=sp.getDouble('thresholdCalories')!+1.0;
                    sp.setDouble('thresholdCalories', thresholdCalories);
                    setState(() {});
                  },
                  child: const Text('+1'),
                  ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? thresholdCalories=sp.getDouble('thresholdCalories')!+10.0;
                    sp.setDouble('thresholdCalories', thresholdCalories);
                    setState(() {});
                  },
                  child: const Text('+10'),
                  ),
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double thresholdCalories=sp.getDouble('thresholdCalories')!;
                    double? measuredBMR=sp.getDouble('measuredBMR')!+10.0;
                    Navigator.pushNamed(context, CaloriesWSPage.route, arguments: SendData2(thresholdCalories, measuredBMR));
                  },
                  child: const Text('Go to Weeks Summary page'),
                )
              ],
            )

          ],
        ),
      ),
    );
  } 

  Future<String> _measuredBMR() async
  {
    final sp = await SharedPreferences.getInstance();
    double? measuredBMR =sp.getDouble('measuredBMR');
    if(measuredBMR == null){
      sp.setDouble('measuredBMR', 1800);
      measuredBMR=1800.0;
    }
    return measuredBMR.toString();
  }

  Future<String> _thresholdCalories() async
  {
    final sp = await SharedPreferences.getInstance();
    double? thresholdCalories =sp.getDouble('thresholdCalories');
    if(thresholdCalories == null){
      sp.setDouble('thresholdCalories', 3000);
      thresholdCalories=3000.0;
    }
    return thresholdCalories.toString();
  }

  Future<String> _bmrFitbit() async{
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(
        clientID: FitbitAppCredentials.clientID,
        clientSecret: FitbitAppCredentials.clientSecret,
        type: 'caloriesBMR',
    );
    final sp = await SharedPreferences.getInstance();
    FitbitActivityTimeseriesAPIURL fitbitActivityTimeseriesApiUrl = FitbitActivityTimeseriesAPIURL.dayWithResource(
        date: DateTime.now().subtract(const Duration(days: 1)),
        userID: sp.getString('username'),
        resource: 'caloriesBMR',
    );
    final yesterdayBMR = await fitbitActivityTimeseriesDataManager.fetch(fitbitActivityTimeseriesApiUrl) as List<FitbitActivityTimeseriesData>;
    sp.setDouble('fitbitBMR', yesterdayBMR[0].value!);
    return yesterdayBMR[0].value.toString();
  }
} //Page

