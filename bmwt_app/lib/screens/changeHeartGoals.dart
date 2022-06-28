import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bmwt_app/database/entities/heartGoals.dart';
import 'package:provider/provider.dart';

import '../repositories/databaseRepository.dart';

class ChangeHeartGoals extends StatefulWidget {
  ChangeHeartGoals({Key? key}) : super(key: key);

  static const route = '/changeHeartGoals';
  static const routename = 'Change your Heart Goals';

  @override
  State<ChangeHeartGoals> createState() => _ChangeHeartGoalsState();
}

class _ChangeHeartGoalsState extends State<ChangeHeartGoals> {
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController calControl = TextEditingController();
  TextEditingController cardioControl = TextEditingController();
  TextEditingController peakControl = TextEditingController();
  TextEditingController bFatControl = TextEditingController();

  late int calories;
  late int cardio;
  late int peak;
  late int bFat;

  @override
  Widget build(BuildContext context) {
    print('${ChangeHeartGoals.routename} built');

    return Scaffold(
        appBar: AppBar(
          title: Text('${ChangeHeartGoals.routename}'),
        ),
        body: Center(
            child: Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          return FutureBuilder(
              initialData: null,
              future: dbr.getHeartGoals(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as List<HeartGoals>;
                  if (data.length == 0) {
                    calories = 500;
                    cardio = 10;
                    peak = 10;
                    bFat = 10;
                  } else {
                    calories = data[0].goalCalories;
                    cardio = data[0].minutesCardio;
                    peak = data[0].minutesPeak;
                    bFat = data[0].minutesPeak;
                  }

                  return Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          NTile(
                            text: 'calories',
                            control: calControl,
                          ),
                          NTile(
                            text: 'Cardio minutes',
                            control: cardioControl,
                          ),
                          NTile(
                            text: 'peak minutes',
                            control: peakControl,
                          ),
                          NTile(
                            text: 'fat burning minutes',
                            control: bFatControl,
                          ),
                          ElevatedButton(
                              onPressed: () => saveAndQuit(),
                              child: Text("save and quit"))
                        ],
                      ),
                    ),
                  );
                } else {
                  return Scaffold(
                    body: Center(child: Text('There was an error')),
                  );
                }
              });
        })));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    calControl.dispose();
    cardioControl.dispose();
    peakControl.dispose();
    bFatControl.dispose();
    super.dispose();
  }

  Future<void> saveAndQuit() async {
    bool error = false;
    String pattern = r'^(\d*)$';
    RegExp regex = RegExp(pattern);
    if (calControl.text != '') {
      if (!regex.hasMatch(calControl.value.text)) {
        setState(() {
          error = true;
        });
      } else {
        calories = int.parse(calControl.value.text);
      }
    }
    if (cardioControl.text != '') {
      if (!regex.hasMatch(cardioControl.value.text)) {
        error = true;
      } else {
        cardio = int.parse(cardioControl.value.text);
      }
    }
    if (peakControl.text != '') {
      if (!regex.hasMatch(peakControl.value.text)) {
        error = true;
      } else {
        peak = int.parse(peakControl.value.text);
      }
    }
    if (bFatControl.text != '') {
      if (!regex.hasMatch(bFatControl.value.text)) {
        error = true;
      } else {
        bFat = int.parse(bFatControl.value.text);
      }
    }
    if (error == false) {
      HeartGoals g = HeartGoals(0, calories, cardio, peak, bFat);
      await Provider.of<DatabaseRepository>(context, listen: false)
          .insertHeartGoals(g);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Insert integers only',
          ),
          actions: [
            TextButton(
                onPressed: () {
                  error = false;
                  Navigator.pop(context);
                },
                child: Text('Close'))
          ],
        ),
        barrierDismissible: false,
      );
    }
  }
}

//* NTILE******************************************/
class NTile extends StatefulWidget {
  final String text;
  TextEditingController control;
  NTile({Key? key, required this.text, required this.control})
      : super(key: key);

  @override
  State<NTile> createState() => _NTile();
}

class _NTile extends State<NTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(widget.text),
          TextField(
            controller: widget.control,
            keyboardType: TextInputType.number,
          )
        ],
      ),
    );
  }
}
