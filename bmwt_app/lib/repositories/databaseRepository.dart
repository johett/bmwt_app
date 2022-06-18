import 'package:bmwt_app/database/database.dart';
import 'package:bmwt_app/database/entities/caloriesDay.dart';
import 'package:bmwt_app/database/entities/caloriesWS.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //*********************CaloriesWS************************ */

  //This method wraps the findAllCaloriesWS() method of the DAO
  Future<List<CaloriesWS>> findAllCaloriesWS() async{
    final results = await database.caloriesWSDao.findAllCaloriesWS();
    return results;
  }

  //This method wraps the insertCaloriesWS() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertCaloriesWS(CaloriesWS caloriesWS)async {
    await database.caloriesWSDao.insertCaloriesWS(caloriesWS);
    notifyListeners();
  }

  //This method wraps the deleteCaloriesWS() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> removeCaloriesWS(CaloriesWS caloriesWS) async{
    await database.caloriesWSDao.deleteCaloriesWS(caloriesWS);
    notifyListeners();
  }

  //*********************CaloriesDay************************ */

  //This method wraps the findAllCaloriesDay() method of the DAO
  Future<List<CaloriesDay>> findAllCaloriesDay() async{
    final results = await database.caloriesDayDao.findAllCaloriesDay();
    return results;
  }


  //This method wraps the findAllCaloriesDayOfAWeek() method of the DAO
  Future<List<CaloriesDay>> findAllCaloriesDayOfAWeek(int idWeek) {
    final results = database.caloriesDayDao.findAllCaloriesDayOfAWeek(idWeek);
    return results;
  }


  //This method wraps the insertCaloriesDay() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertCaloriesDay(CaloriesDay caloriesDay)async {
    await database.caloriesDayDao.insertCaloriesDay(caloriesDay);
    //notifyListeners();
  }

  //This method wraps the deleteCaloriesDay() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> deleteCaloriesDay(CaloriesDay caloriesDay) async{
    await database.caloriesDayDao.deleteCaloriesDay(caloriesDay);
    //notifyListeners();
  }
}//DatabaseRepository