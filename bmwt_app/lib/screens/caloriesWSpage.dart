import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/credentials.dart';

class CaloriesWSPage extends StatefulWidget {
  CaloriesWSPage({Key? key}) : super(key: key);

  static const route = '/calories';
  static const routename = 'CaloriesWSPage';

  @override
  State<CaloriesWSPage> createState() => _CaloriesWSPageState();
}

class _CaloriesWSPageState extends State<CaloriesWSPage> {

  @override
  void initState(){
    super.initState();
  }//initState

  @override
  Widget build(BuildContext context) {
    print('${CaloriesWSPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(CaloriesWSPage.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              FutureBuilder(
              future: _bmrFitbit(),
              builder: (context, snapshot){
                if(snapshot.hasData)
                {
                  return Text('Your BMR calculated by Fitbit is ${snapshot.data}');
                }
                else
                  return CircularProgressIndicator();
              },
              ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: _measuredBMR(),
                  builder:(context,snapshot){
                    if(snapshot.hasData){
                      return Text('BMR: ${snapshot.data}');
                  }
                  else
                    return CircularProgressIndicator();
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
                  child: Text('-10'),
                  ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? measuredBMR=sp.getDouble('measuredBMR')!-1.0;
                    sp.setDouble('measuredBMR', measuredBMR);
                    setState(() {});
                  },
                  child: Text('-1'),
                  ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? measuredBMR=sp.getDouble('measuredBMR')!+1.0;
                    sp.setDouble('measuredBMR', measuredBMR);
                    setState(() {});
                  },
                  child: Text('+1'),
                  ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? measuredBMR=sp.getDouble('measuredBMR')!+10.0;
                    sp.setDouble('measuredBMR', measuredBMR);
                    setState(() {});
                  },
                  child: Text('+10'),
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
                     else
                       return CircularProgressIndicator();
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
                  child: Text('-10'),
                  ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? thresholdCalories=sp.getDouble('thresholdCalories')!-1.0;
                    sp.setDouble('thresholdCalories', thresholdCalories);
                    setState(() {});
                  },
                  child: Text('-1'),
                  ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? thresholdCalories=sp.getDouble('thresholdCalories')!+1.0;
                    sp.setDouble('thresholdCalories', thresholdCalories);
                    setState(() {});
                  },
                  child: Text('+1'),
                  ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () async{
                    final sp = await SharedPreferences.getInstance();
                    double? thresholdCalories=sp.getDouble('thresholdCalories')!+10.0;
                    sp.setDouble('thresholdCalories', thresholdCalories);
                    setState(() {});
                  },
                  child: Text('+10'),
                  ),
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
      sp.setDouble('thresholdCalories', 2500);
      thresholdCalories=2500.0;
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
        date: DateTime.now().subtract(Duration(days: 1)),
        userID: sp.getString('username'),
        resource: 'caloriesBMR',
    );
    final yesterdayBMR = await fitbitActivityTimeseriesDataManager.fetch(fitbitActivityTimeseriesApiUrl) as List<FitbitActivityTimeseriesData>;
    return yesterdayBMR[0].value.toString();
  }
} //Page

