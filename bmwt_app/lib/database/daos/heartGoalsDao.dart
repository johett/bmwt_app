import 'package:bmwt_app/database/entities/heartgoals.dart';
import 'package:floor/floor.dart';
import 'dart:core';

@dao
abstract class HeartGoalsDao {
  @Query('SELECT * FROM HeartGoals')
  Future<List<HeartGoals>> getHeartGoals();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateHeartGoals(HeartGoals heart);

  @delete
  Future<void> deleteHeartGoals(HeartGoals heart);

  @insert
  Future<void> insertHeartGoals(HeartGoals heart);
}
