// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CaloriesWSDao? _caloriesWSDaoInstance;

  CaloriesDayDao? _caloriesDayDaoInstance;

  HeartDao? _heartDaoInstance;

  UserDao? _userDaoInstance;

  HeartGoalsDao? _heartGoalsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CaloriesWS` (`id` INTEGER NOT NULL, `startDay` INTEGER NOT NULL, `lastDay` INTEGER NOT NULL, `activityCalories` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CaloriesDay` (`idWeek` INTEGER NOT NULL, `idDayOfTheWeek` INTEGER NOT NULL, `startDay` INTEGER NOT NULL, `lastDay` INTEGER NOT NULL, `day` INTEGER NOT NULL, `activityCalories` REAL, PRIMARY KEY (`idWeek`, `idDayOfTheWeek`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Heart` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `heartBeat` INTEGER, `dateTime` TEXT NOT NULL, `minutesCardio` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `surname` TEXT, `height` INTEGER, `weight` REAL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `HeartGoals` (`id` INTEGER NOT NULL DEFAULT 0, `goalCalories` INTEGER NOT NULL DEFAULT 500, `minutesCardio` INTEGER NOT NULL DEFAULT 10, `minutesPeak` INTEGER NOT NULL DEFAULT 10, `minutesBurningFat` INTEGER NOT NULL DEFAULT 10, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CaloriesWSDao get caloriesWSDao {
    return _caloriesWSDaoInstance ??= _$CaloriesWSDao(database, changeListener);
  }

  @override
  CaloriesDayDao get caloriesDayDao {
    return _caloriesDayDaoInstance ??=
        _$CaloriesDayDao(database, changeListener);
  }

  @override
  HeartDao get heartDao {
    return _heartDaoInstance ??= _$HeartDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  HeartGoalsDao get heartGoalsDao {
    return _heartGoalsDaoInstance ??= _$HeartGoalsDao(database, changeListener);
  }
}

class _$CaloriesWSDao extends CaloriesWSDao {
  _$CaloriesWSDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _caloriesWSInsertionAdapter = InsertionAdapter(
            database,
            'CaloriesWS',
            (CaloriesWS item) => <String, Object?>{
                  'id': item.id,
                  'startDay': _dateTimeConverter.encode(item.startDay),
                  'lastDay': _dateTimeConverter.encode(item.lastDay),
                  'activityCalories': item.activityCalories
                }),
        _caloriesWSDeletionAdapter = DeletionAdapter(
            database,
            'CaloriesWS',
            ['id'],
            (CaloriesWS item) => <String, Object?>{
                  'id': item.id,
                  'startDay': _dateTimeConverter.encode(item.startDay),
                  'lastDay': _dateTimeConverter.encode(item.lastDay),
                  'activityCalories': item.activityCalories
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CaloriesWS> _caloriesWSInsertionAdapter;

  final DeletionAdapter<CaloriesWS> _caloriesWSDeletionAdapter;

  @override
  Future<List<CaloriesWS>> findAllCaloriesWS() async {
    return _queryAdapter.queryList('SELECT * FROM CaloriesWS',
        mapper: (Map<String, Object?> row) => CaloriesWS(
            row['id'] as int,
            _dateTimeConverter.decode(row['startDay'] as int),
            _dateTimeConverter.decode(row['lastDay'] as int),
            row['activityCalories'] as double?));
  }

  @override
  Future<void> insertCaloriesWS(CaloriesWS caloriesWS) async {
    await _caloriesWSInsertionAdapter.insert(
        caloriesWS, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCaloriesWS(CaloriesWS caloriesWS) async {
    await _caloriesWSDeletionAdapter.delete(caloriesWS);
  }
}

class _$CaloriesDayDao extends CaloriesDayDao {
  _$CaloriesDayDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _caloriesDayInsertionAdapter = InsertionAdapter(
            database,
            'CaloriesDay',
            (CaloriesDay item) => <String, Object?>{
                  'idWeek': item.idWeek,
                  'idDayOfTheWeek': item.idDayOfTheWeek,
                  'startDay': _dateTimeConverter.encode(item.startDay),
                  'lastDay': _dateTimeConverter.encode(item.lastDay),
                  'day': _dateTimeConverter.encode(item.day),
                  'activityCalories': item.activityCalories
                }),
        _caloriesDayDeletionAdapter = DeletionAdapter(
            database,
            'CaloriesDay',
            ['idWeek', 'idDayOfTheWeek'],
            (CaloriesDay item) => <String, Object?>{
                  'idWeek': item.idWeek,
                  'idDayOfTheWeek': item.idDayOfTheWeek,
                  'startDay': _dateTimeConverter.encode(item.startDay),
                  'lastDay': _dateTimeConverter.encode(item.lastDay),
                  'day': _dateTimeConverter.encode(item.day),
                  'activityCalories': item.activityCalories
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CaloriesDay> _caloriesDayInsertionAdapter;

  final DeletionAdapter<CaloriesDay> _caloriesDayDeletionAdapter;

  @override
  Future<List<CaloriesDay>> findAllCaloriesDay() async {
    return _queryAdapter.queryList('SELECT * FROM CaloriesDay',
        mapper: (Map<String, Object?> row) => CaloriesDay(
            row['idWeek'] as int,
            row['idDayOfTheWeek'] as int,
            _dateTimeConverter.decode(row['startDay'] as int),
            _dateTimeConverter.decode(row['lastDay'] as int),
            _dateTimeConverter.decode(row['day'] as int),
            row['activityCalories'] as double?));
  }

  @override
  Future<List<CaloriesDay>> findAllCaloriesDayOfAWeek(int idWeek) async {
    return _queryAdapter.queryList(
        'SELECT * FROM CaloriesDay WHERE idWeek = ?1',
        mapper: (Map<String, Object?> row) => CaloriesDay(
            row['idWeek'] as int,
            row['idDayOfTheWeek'] as int,
            _dateTimeConverter.decode(row['startDay'] as int),
            _dateTimeConverter.decode(row['lastDay'] as int),
            _dateTimeConverter.decode(row['day'] as int),
            row['activityCalories'] as double?),
        arguments: [idWeek]);
  }

  @override
  Future<void> insertCaloriesDay(CaloriesDay caloriesDay) async {
    await _caloriesDayInsertionAdapter.insert(
        caloriesDay, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCaloriesDay(CaloriesDay caloriesDay) async {
    await _caloriesDayDeletionAdapter.delete(caloriesDay);
  }
}

class _$HeartDao extends HeartDao {
  _$HeartDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _heartInsertionAdapter = InsertionAdapter(
            database,
            'Heart',
            (Heart item) => <String, Object?>{
                  'id': item.id,
                  'heartBeat': item.heartBeat,
                  'dateTime': item.dateTime,
                  'minutesCardio': item.minutesCardio
                }),
        _heartDeletionAdapter = DeletionAdapter(
            database,
            'Heart',
            ['id'],
            (Heart item) => <String, Object?>{
                  'id': item.id,
                  'heartBeat': item.heartBeat,
                  'dateTime': item.dateTime,
                  'minutesCardio': item.minutesCardio
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Heart> _heartInsertionAdapter;

  final DeletionAdapter<Heart> _heartDeletionAdapter;

  @override
  Future<List<Heart>> findAllHearts() async {
    return _queryAdapter.queryList('SELECT * FROM Heart',
        mapper: (Map<String, Object?> row) => Heart(
            row['id'] as int?,
            row['heartBeat'] as int?,
            row['dateTime'] as String,
            row['minutesCardio'] as int?));
  }

  @override
  Future<Heart?> getHeartByDate(String dateTime) async {
    return _queryAdapter.query('SELECT * From Heart WHERE dateTime = ?1',
        mapper: (Map<String, Object?> row) => Heart(
            row['id'] as int?,
            row['heartBeat'] as int?,
            row['dateTime'] as String,
            row['minutesCardio'] as int?),
        arguments: [dateTime]);
  }

  @override
  Future<void> insertHeart(Heart heart) async {
    await _heartInsertionAdapter.insert(heart, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteHeart(Heart heart) async {
    await _heartDeletionAdapter.delete(heart);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userDataInsertionAdapter = InsertionAdapter(
            database,
            'UserData',
            (UserData item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'surname': item.surname,
                  'height': item.height,
                  'weight': item.weight
                }),
        _userDataDeletionAdapter = DeletionAdapter(
            database,
            'UserData',
            ['id'],
            (UserData item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'surname': item.surname,
                  'height': item.height,
                  'weight': item.weight
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserData> _userDataInsertionAdapter;

  final DeletionAdapter<UserData> _userDataDeletionAdapter;

  @override
  Future<List<UserData>> getUser() async {
    return _queryAdapter.queryList('SELECT * FROM UserData',
        mapper: (Map<String, Object?> row) => UserData(
            row['id'] as int?,
            row['name'] as String?,
            row['surname'] as String?,
            row['height'] as int?,
            row['weight'] as double?));
  }

  @override
  Future<void> insertUser(UserData user) async {
    await _userDataInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(UserData user) async {
    await _userDataDeletionAdapter.delete(user);
  }
}

class _$HeartGoalsDao extends HeartGoalsDao {
  _$HeartGoalsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _heartGoalsInsertionAdapter = InsertionAdapter(
            database,
            'HeartGoals',
            (HeartGoals item) => <String, Object?>{
                  'id': item.id,
                  'goalCalories': item.goalCalories,
                  'minutesCardio': item.minutesCardio,
                  'minutesPeak': item.minutesPeak,
                  'minutesBurningFat': item.minutesBurningFat
                }),
        _heartGoalsDeletionAdapter = DeletionAdapter(
            database,
            'HeartGoals',
            ['id'],
            (HeartGoals item) => <String, Object?>{
                  'id': item.id,
                  'goalCalories': item.goalCalories,
                  'minutesCardio': item.minutesCardio,
                  'minutesPeak': item.minutesPeak,
                  'minutesBurningFat': item.minutesBurningFat
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<HeartGoals> _heartGoalsInsertionAdapter;

  final DeletionAdapter<HeartGoals> _heartGoalsDeletionAdapter;

  @override
  Future<List<HeartGoals>> getHeartGoals() async {
    return _queryAdapter.queryList('SELECT * FROM HeartGoals',
        mapper: (Map<String, Object?> row) => HeartGoals(
            row['id'] as int,
            row['goalCalories'] as int,
            row['minutesCardio'] as int,
            row['minutesPeak'] as int,
            row['minutesBurningFat'] as int));
  }

  @override
  Future<List<HeartGoals>> getHeartGoalsbyID(int id) async {
    return _queryAdapter.queryList('SELECT * FROM HeartGoals WHERE id = ?1',
        mapper: (Map<String, Object?> row) => HeartGoals(
            row['id'] as int,
            row['goalCalories'] as int,
            row['minutesCardio'] as int,
            row['minutesPeak'] as int,
            row['minutesBurningFat'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertHeartGoals(HeartGoals heartGoals) async {
    await _heartGoalsInsertionAdapter.insert(
        heartGoals, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteHeartGoals(HeartGoals heartGoals) async {
    await _heartGoalsDeletionAdapter.delete(heartGoals);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
