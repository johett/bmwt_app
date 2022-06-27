import 'package:bmwt_app/database/entities/heart.dart';
import 'package:floor/floor.dart';

@dao
abstract class HeartDao {
  @Query('SELECT * FROM Heart')
  Future<List<Heart>> findAllHearts();

  @Query('SELECT * From Heart WHERE dateTime = :dateTime')
  Future<Heart?> getHeartByDate(String dateTime);

  @insert
  Future<void> insertHeart(Heart heart);

  @delete
  Future<void> deleteHeart(Heart heart);
}
