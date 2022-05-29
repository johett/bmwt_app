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

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
