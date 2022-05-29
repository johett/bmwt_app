import 'package:bmwt_app/database/entities/caloriesDay.dart';
import 'package:bmwt_app/database/entities/caloriesWS.dart';
import 'package:bmwt_app/utility/senData2.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/databaseRepository.dart';
import '../utility/credentials.dart';
import '../utility/sendData.dart';
import 'caloriesDaypage.dart';

class CaloriesWSPage extends StatelessWidget {
  CaloriesWSPage({Key? key}) : super(key: key);

  static const route = '/caloriesWS';
  static const routename = 'CaloriesWSPage';
  
  @override
  Widget build(BuildContext context) {
    final i = ModalRoute.of(context)!.settings.arguments! as SendData2;
    final double dietCalories = i.thresholdCalories;
    final double measBMR = i.caloriesBMR;

    print('${CaloriesWSPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(CaloriesWSPage.routename),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final list = await Provider.of<DatabaseRepository>(context, listen: false).findAllCaloriesWS();
          int weeksInDB = list.length;
          FitbitActivityTimeseriesDataManager fitbitActivityTimeseriesDataManager = FitbitActivityTimeseriesDataManager(
            clientID: FitbitAppCredentials.clientID,
            clientSecret: FitbitAppCredentials.clientSecret,
            type: 'calories'
          );
          final sp = await SharedPreferences.getInstance();
          FitbitActivityTimeseriesAPIURL fitbitActivityTimeseriesApiUrl = FitbitActivityTimeseriesAPIURL.weekWithResource(
            baseDate: DateTime.now().subtract(Duration(days: 7*weeksInDB+1)),
            userID: sp.getString('username'),
            resource: 'calories',
          );
          final weekToBeProcessed = await fitbitActivityTimeseriesDataManager.fetch(fitbitActivityTimeseriesApiUrl) as List<FitbitActivityTimeseriesData>;
          final fitbitBMR = sp.getDouble('fitbitBMR');
          int dayOfTheWeek=0;
          double? activityAverage=0;
          int notnull=0;

          for(var item in weekToBeProcessed)
          {
            double? correctedActivityCalories = _correctCalories(item.value, fitbitBMR!);
            await Provider.of<DatabaseRepository>(context, listen: false).insertCaloriesDay(
              CaloriesDay(
                weeksInDB,
                dayOfTheWeek,
                DateTime.now().subtract(Duration(days: 7*weeksInDB+1+6)),
                DateTime.now().subtract(Duration(days: 7*weeksInDB+1)),
                DateTime.now().subtract(Duration(days: 7*weeksInDB+1+(6-dayOfTheWeek))),
                correctedActivityCalories,
              )
            );
            if(correctedActivityCalories!=null){
              activityAverage=activityAverage!+correctedActivityCalories;
              notnull++;
            }
            dayOfTheWeek++;
          }

          if(notnull!=0){
            activityAverage=activityAverage!/notnull;
          }
          else
            activityAverage=0;

          await Provider.of<DatabaseRepository>(context, listen: false).insertCaloriesWS(
            CaloriesWS(
              weeksInDB,
              DateTime.now().subtract(Duration(days: 7*weeksInDB+1+6)), 
              DateTime.now().subtract(Duration(days: 7*weeksInDB+1)), 
              activityAverage,
            )
          );
          },
          child: Icon(Icons.add)),
      
      body: Center(
        child: 
        Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          return FutureBuilder(
            future: dbr.findAllCaloriesWS(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<CaloriesWS>;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final caloriesWS = data[index];
                      return ListTile(
                            title: Text('From: ${caloriesWS.startDay.day}/${caloriesWS.startDay.month}/${caloriesWS.startDay.year} To: ${caloriesWS.lastDay.day}/${caloriesWS.startDay.month}/${caloriesWS.startDay.year}'),
                            subtitle: (caloriesWS.activityCalories==null)?
                                Text('No data avaiables'):
                                ((caloriesWS.activityCalories!+measBMR)>dietCalories)?
                                  Text('Deficit of ${(caloriesWS.activityCalories!+measBMR-dietCalories).toInt()} kcal on average per day'):
                                  Text('Surplus of ${(dietCalories-caloriesWS.activityCalories!-measBMR).toInt()} kcal on average per day'),
                            trailing: (index==data.length-1)?
                              ElevatedButton(
                                onPressed: () async{
                                  final caloriesDayToDelete = await Provider.of<DatabaseRepository>(context, listen: false).findAllCaloriesDayOfAWeek(caloriesWS.id);
                                  for(var calDay in caloriesDayToDelete){
                                    await Provider.of<DatabaseRepository>(context, listen: false).deleteCaloriesDay(calDay);
                                  }
                                  await Provider.of<DatabaseRepository>(context, listen: false).removeCaloriesWS(caloriesWS);
                                },
                                child: Icon(MdiIcons.delete)
                              ):
                              Icon(MdiIcons.nullIcon),
                            onTap: (){
                              Navigator.pushNamed(context, CaloriesDayPage.route, arguments: SendData(index,dietCalories,measBMR));
                            },
                            
                          );
                    },
                );
              }
              else
                return CircularProgressIndicator();
            },//builder of FutureBuilder
          );
        }),
      ),
    );
  } //build

  double? _correctCalories(double? calories, double fitbitBMR){
    if(calories!=null){
      double fitbitActivityCalories = calories - fitbitBMR;
      double LB = fitbitActivityCalories/1.535;
      double UB = fitbitActivityCalories/0.957;
      return (UB+LB)/2;
    }
    else 
      return null;
  }

} //CaloriesWSPage
