import 'package:bmwt_app/database/entities/caloriesDay.dart';
import 'package:bmwt_app/utility/sendData.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../repositories/databaseRepository.dart';

class CaloriesDayPage extends StatelessWidget {
  CaloriesDayPage({Key? key}) : super(key: key);

  static const route = '/caloriesDay';
  static const routename = 'CaloriesDayPage';
  
  @override
  Widget build(BuildContext context) {
    print('${CaloriesDayPage.routename} built');
    final i = ModalRoute.of(context)!.settings.arguments! as SendData;
    final indexOfWeek = i.indexOfWeek;
    final dietCalories = i.dietCalories;
    final measBMR = i.caloriesBMR;
    
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(CaloriesDayPage.routename),
      ),
      body: Center(
        child:
          Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          return FutureBuilder(
            future: dbr.findAllCaloriesDayOfAWeek(indexOfWeek),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<CaloriesDay>;
                return ListView.separated(
                     separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.blue, thickness: 10,),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final caloriesDay = data[index];
                      return ListTile(
                            tileColor: Color(0xFFFFE082),
                            style: ListTileStyle.list,
                            leading: Text('${index+1}', style: TextStyle(color: Colors.blue, fontSize: 20) ),
                            title: Text('Day: ${caloriesDay.day.day}/${caloriesDay.day.month}/${caloriesDay.day.year}'),
                            subtitle: (caloriesDay.activityCalories==null)?
                                Text('No data avaiables'):
                                ((caloriesDay.activityCalories!+measBMR)>dietCalories)?
                                  Text('Deficit of ${(caloriesDay.activityCalories!+measBMR-dietCalories).toInt()} kcal',style: TextStyle(color: Colors.red)):
                                  Text('Surplus of ${(dietCalories-caloriesDay.activityCalories!-measBMR).toInt()} kcal',style: TextStyle(color: Colors.green)),
                          );
                    }
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

} //Page