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
  void initState() {
    super.initState();
  } //initState

  @override
  Widget build(BuildContext context) {
    print('${CaloriesHomePage.routename} built');
    return Scaffold(
      //backgroundColor: Color(0xFF2196F3),
      appBar: AppBar(
        title: const Text(CaloriesHomePage.routename),
      ),
      body: Center(
        child: SizedBox(
          height: 350,
          width: 300,
          child: Center(
            child: Container(
              //color: Color(0xFFFFE082),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 99, 0, 68), width: 5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      FutureBuilder(
                      future: _bmrFitbit(),  //method that will retrive the BMR value from FitBit
                      builder: (context, snapshot) {
                        if(snapshot.hasData)
                        {
                          return Text('Your BMR calculated by Fitbit is ${snapshot.data}',style: TextStyle(fontSize: 16));
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
                          future: _measuredBMR(),  //BMR insert by the user, for example if he/she knows it from a more specific visits
                          builder:(context,snapshot){
                            if(snapshot.hasData){
                              return Text('BMR: ${snapshot.data}', style: TextStyle(fontSize: 20),);
                          }
                          else
                            return CircularProgressIndicator();
                          }
                          ),
                      ],
                    ),
                    Row( //buttons to vary the bmr
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async{
                            final sp = await SharedPreferences.getInstance();
                            double? measuredBMR=sp.getDouble('measuredBMR')!-10.0;
                            sp.setDouble('measuredBMR', measuredBMR);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
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
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
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
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
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
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
                          child: Text('+10'),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         FutureBuilder(
                           future: _thresholdCalories(), //calories of the diet the user is following
                           builder: (context, snapshot){
                             if(snapshot.hasData){
                               return Text('Diet kcal per day: ${snapshot.data}',style: TextStyle(fontSize: 20));
                             }
                             else
                               return CircularProgressIndicator();
                           },
                           ),
                      ],
                    ),
                    Row( //buttons to vary the calories of the diet
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async{
                            final sp = await SharedPreferences.getInstance();
                            double? thresholdCalories=sp.getDouble('thresholdCalories')!-10.0;
                            sp.setDouble('thresholdCalories', thresholdCalories);
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
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
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
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
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
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
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
                          child: Text('+10'),
                          ),
                      ],
                    ),
                    SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async{  //navigate to the following page, sending some values to it (BMR and diet calories)
                            final sp = await SharedPreferences.getInstance();
                            double thresholdCalories=sp.getDouble('thresholdCalories')!;
                            double? measuredBMR=sp.getDouble('measuredBMR')!+10.0;
                            Navigator.pushNamed(context, CaloriesWSPage.route, arguments: SendData2(thresholdCalories, measuredBMR));
                          },
                          child: Text('Go to Weeks Summary page', style: TextStyle(fontSize: 20),),
                          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 99, 0, 68)),
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> _measuredBMR() async {  //retrive the value of the measured BMR from shared preferences
    final sp = await SharedPreferences.getInstance();
    double? measuredBMR = sp.getDouble('measuredBMR');
    if (measuredBMR == null) {
      sp.setDouble('measuredBMR', 1800);
      measuredBMR = 1800.0;
    }
    return measuredBMR.toString();
  }

  Future<String> _thresholdCalories() async {  //retrive the diet calories from shared preferences
    final sp = await SharedPreferences.getInstance();
    double? thresholdCalories = sp.getDouble('thresholdCalories');
    if (thresholdCalories == null) {
      sp.setDouble('thresholdCalories', 3000);
      thresholdCalories = 3000.0;
    }
    return thresholdCalories.toString();
  }

  Future<String> _bmrFitbit() async {  //retrive the BMR computed by fitbit
    FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager =
        FitbitActivityTimeseriesDataManager(
      clientID: FitbitAppCredentials.clientID,
      clientSecret: FitbitAppCredentials.clientSecret,
      type: 'caloriesBMR',
    );
    final sp = await SharedPreferences.getInstance();
    FitbitActivityTimeseriesAPIURL fitbitActivityTimeseriesApiUrl =
        FitbitActivityTimeseriesAPIURL.dayWithResource(
      date: DateTime.now().subtract(const Duration(days: 1)),
      userID: sp.getString('username'),
      resource: 'caloriesBMR',
    );
    final yesterdayBMR = await fitbitActivityTimeseriesDataManager.fetch(
        fitbitActivityTimeseriesApiUrl) as List<FitbitActivityTimeseriesData>;
    sp.setDouble('fitbitBMR', yesterdayBMR[0].value!);
    return yesterdayBMR[0].value.toString();
  }
} //Page

