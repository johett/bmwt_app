import 'package:bmwt_app/database/entities/caloriesWS.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class CaloriesWSDao {

  //Query #1: SELECT -> this allows to obtain all the entries of the caloriesWS table
  @Query('SELECT * FROM CaloriesWS')
  Future<List<CaloriesWS>> findAllCaloriesWS();

  //Query #2: INSERT -> this allows to add a CaloriesWS in the table
  @insert
  Future<void> insertCaloriesWS(CaloriesWS caloriesWS);

  //Query #3: DELETE -> this allows to delete a CaloriesWS from the table
  @delete
  Future<void> deleteCaloriesWS(CaloriesWS caloriesWS);
  
}//MealDao