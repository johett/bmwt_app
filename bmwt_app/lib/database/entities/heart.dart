import 'package:floor/floor.dart';

@entity
class Heart {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? heartBeat;
  final String dateTime;
  final int? minutesCardio;

  Heart(this.id, this.heartBeat, this.dateTime, this.minutesCardio);
}//Heart