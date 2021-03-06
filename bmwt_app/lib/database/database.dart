//Imports that are necessary to the code generator of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:bmwt_app/database/typeConverters/dateTimeConverter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'package:bmwt_app/database/daos/caloriesWSDao.dart';
import 'package:bmwt_app/database/entities/caloriesWS.dart';
import 'package:bmwt_app/database/daos/caloriesDayDao.dart';
import 'package:bmwt_app/database/entities/caloriesDay.dart';
import 'package:bmwt_app/database/entities/heart.dart';
import 'package:bmwt_app/database/daos/heartDao.dart';
import 'package:bmwt_app/database/daos/heartGoalsDao.dart';
import 'package:bmwt_app/database/entities/heartGoals.dart';
import 'package:bmwt_app/database/daos/userDao.dart';
import 'package:bmwt_app/database/entities/userData.dart';

//The generated code will be in database.g.dart
part 'database.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity, i.e., Meal.
//We also added a TypeConverter to manage the DateTime of a Meal entry, since DateTimes are not natively
//supported by Floor.
@TypeConverters([DateTimeConverter])
//
@Database(
    version: 1,
    entities: [CaloriesWS, CaloriesDay, Heart, UserData, HeartGoals])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  CaloriesWSDao get caloriesWSDao;
  CaloriesDayDao get caloriesDayDao;
  HeartDao get heartDao;
  UserDao get userDao;
  HeartGoalsDao get heartGoalsDao;
}//AppDatabase