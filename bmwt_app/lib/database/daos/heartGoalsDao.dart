import 'package:bmwt_app/database/entities/heartGoals.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class HeartGoalsDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the caloriesWS table
  @Query('SELECT * FROM HeartGoals')
  Future<List<HeartGoals>> getHeartGoals();

  @Query('SELECT * FROM HeartGoals WHERE id = :id')
  Future<List<HeartGoals>> getHeartGoalsbyID(int id);
  //Query #2: INSERT -> this allows to add a CaloriesDay in the table
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertHeartGoals(HeartGoals heartGoals);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateHeartGoals(HeartGoals heartGoals);

  //Query #3: DELETE -> this allows to delete a CaloriesDay from the table
  @delete
  Future<void> deleteHeartGoals(HeartGoals heartGoals);
}//MealDao