import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:bmwt_app/database/entities/heartGoals.dart';
import 'package:bmwt_app/database/database.dart';
import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DBTest extends StatelessWidget {
  DBTest({Key? key}) : super(key: key);

  static const route = '/DBTest';
  static const routeName = 'DBTest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Consumer<DatabaseRepository>(
        builder: ((context, dbr, child) {
          return FutureBuilder(
              initialData: null,
              future: dbr.getHeartGoals(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as List<HeartGoals>;
                  return Text(data[0].minutesPeak.toString());
                } else
                  return Text("ERROR");
              });
        }),
      )),
    );
  }
} //Page