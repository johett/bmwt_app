import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity
@entity
class CaloriesWS {
  //id will be the primary key of the table. Moreover, it will be autogenerated.
  //id is nullable since it is autogenerated.
  @PrimaryKey()
  final int id; 

  //The first day of the week
  final DateTime startDay;

  //The last day of the week
  final DateTime lastDay;

  //The calories burned by activity in a day of the week
   final double? activityCalories;

  //Default constructor
  CaloriesWS(this.id, this.startDay, this.lastDay, this.activityCalories);
  
}//CaloriesWS
