import 'package:floor/floor.dart';

@entity
class UserData {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  final String? surname;
  final int? height;
  final double? weight;

  UserData(this.id, this.name, this.surname, this.height, this.weight);
}//Heart