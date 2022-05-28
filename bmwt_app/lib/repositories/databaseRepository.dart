import 'package:bmwt_app/database/database.dart';
import 'package:bmwt_app/database/entities/caloriesWS.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier{

  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //This method wraps the findAllCaloriesWS() method of the DAO
  Future<List<CaloriesWS>> findAllCaloriesWS() async{
    final results = await database.caloriesWSDao.findAllCaloriesWS();
    return results;
  }//findAllMeals

  //This method wraps the insertCaloriesWS() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> insertMeal(CaloriesWS caloriesWS)async {
    await database.caloriesWSDao.insertCaloriesWS(caloriesWS);
    notifyListeners();
  }//insertMeal

  //This method wraps the deleteCaloriesWS() method of the DAO. 
  //Then, it notifies the listeners that something changed.
  Future<void> removeCaloriesWS(CaloriesWS caloriesWS) async{
    await database.caloriesWSDao.deleteCaloriesWS(caloriesWS);
    notifyListeners();
  }//removeMeal

}//DatabaseRepository