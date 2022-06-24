import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bmwt_app/repositories/databaseRepository.dart';
import 'package:bmwt_app/database/entities/heartgoals.dart';

class HP3 extends StatelessWidget {
  HP3({Key? key}) : super(key: key);

  static const route = '/hp3';
  static const routename = 'HP3';

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
                  return Text(data[0].calories.toString());
                } else
                  return Text("ERROR");
              });
        }),
      )),
    );
  }
  // functions

} //Page