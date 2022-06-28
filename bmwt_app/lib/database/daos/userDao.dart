import 'package:bmwt_app/database/entities/userData.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class UserDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the caloriesWS table
  @Query('SELECT * FROM UserData')
  Future<List<UserData>> getUser();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(UserData user);
  //Query #3: DELETE -> this allows to delete a CaloriesDay from the table
  @delete
  Future<void> deleteUser(UserData user);
}//MealDao