import 'package:floor/floor.dart';

@entity
class HeartGoals {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int calories;
  final int minutesPeak;
  final int minutesBurningFat;
  final int minutesCardio;

  HeartGoals(this.id, this.calories, this.minutesBurningFat, this.minutesPeak,
      this.minutesCardio);
}//Heart