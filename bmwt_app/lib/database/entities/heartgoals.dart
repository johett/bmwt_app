import 'package:floor/floor.dart';

//Here, we are saying to floor that this is a class that defines an entity

@Entity(primaryKeys: ['id'])
class HeartGoals {
  //the identifier of the week to which this day belong
  final int id;
  //the identifier of the day of the week
  final int goalCalories;
  final int minutesCardio;
  final int minutesPeak;
  final int minutesBurningFat;

  //Default constructor
  HeartGoals(this.id, this.goalCalories, this.minutesCardio, this.minutesPeak,
      this.minutesBurningFat);
}//CaloriesWS