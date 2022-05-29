import 'package:bmwt_app/database/entities/caloriesDay.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class CaloriesDayDao {

  //Query #1: SELECT -> this allows to obtain all the entries of the caloriesWS table
  @Query('SELECT * FROM CaloriesDay')
  Future<List<CaloriesDay>> findAllCaloriesDay();


  //Query #2: SELECT -> this allows to obtain all the entries of the caloriesWS table with idWeek specified
  @Query('SELECT * FROM CaloriesDay WHERE idWeek = :idWeek')
  Future<List<CaloriesDay>> findAllCaloriesDayOfAWeek(int idWeek);

  //Query #2: INSERT -> this allows to add a CaloriesDay in the table
  @insert
  Future<void> insertCaloriesDay(CaloriesDay caloriesDay);

  //Query #3: DELETE -> this allows to delete a CaloriesDay from the table
  @delete
  Future<void> deleteCaloriesDay(CaloriesDay caloriesDay);
  
}//MealDao