import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity

@Entity(primaryKeys: ['idWeek', 'idDayOfTheWeek'])
class CaloriesDay {

  //the identifier of the week to which this day belong
  final int idWeek; 

  //the identifier of the day of the week
  final int idDayOfTheWeek; 

  //The first day of the week
  final DateTime startDay;

  //The last day of the week
  final DateTime lastDay;

  //The actual day of the week
  final DateTime day;

  //The calories burned by activity in this day of the week
   final double? activityCalories;

  //Default constructor
  CaloriesDay(this.idWeek, this.idDayOfTheWeek, this.startDay, this.lastDay, this.day, this.activityCalories);
  
}//CaloriesWS