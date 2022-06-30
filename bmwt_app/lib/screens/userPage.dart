import 'dart:async';

import 'package:bmwt_app/database/entities/userData.dart';
import 'package:flutter/material.dart';
import 'package:bmwt_app/database/entities/heartGoals.dart';
import 'package:provider/provider.dart';

import '../repositories/databaseRepository.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  static const route = '/userPage';
  static const routename = 'User ';

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  @override
  void initState() {
    super.initState();
  }

//controllers
  final formKey = GlobalKey<FormState>();
  TextEditingController nameControl = TextEditingController();
  TextEditingController surnameControl = TextEditingController();
  TextEditingController heightControl = TextEditingController();
  TextEditingController weightControl = TextEditingController();

//data
  String? name = null;
  String? surname = null;
  int? height = null;
  double? weight = null;

  @override
  Widget build(BuildContext context) {
    print('${UserPage.routename} built');

    return Scaffold(
        appBar: AppBar(
          title: Text('${UserPage.routename}'),
        ),
        body: Center(
            child: Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          return FutureBuilder(
              initialData: null,
              //checks for user data in database
              future: dbr.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as List<UserData>;
                  if (data.length != 0) {
                    if (data[0].name != null) {
                      // if data exists
                      name = data[0].name as String;
                    }

                    if (data[0].surname != null) {
                      surname = data[0].surname as String;
                    }
                    if (data[0].height != null) {
                      height = data[0].height as int;
                    }
                    if (data[0].weight != null) {
                      weight = data[0].weight as double;
                    }
                  }
                }

                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        NameTile(
                          text: 'Name',
                          control: nameControl,
                          hint:
                              name != null ? name : '', // check for null values
                        ),
                        NameTile(
                          text: 'Surname',
                          control: surnameControl,
                          hint: surname != null ? surname : '',
                        ),
                        NTile(
                          text: 'Height in cm',
                          control: heightControl,
                          hint: height != null ? height.toString() : '',
                        ),
                        NTile(
                          text: 'Weight in Kg',
                          control: weightControl,
                          hint: weight != null ? weight.toString() : '',
                        ),
                        (height is int &&
                                height != 0 &&
                                weight is double &&
                                height != null &&
                                weight != null)
                            ? Text(
                                'Your BMI is: ${(weight! / (height! * height!) * 10000).toStringAsFixed(2)}.')
                            : Text('Insert height and weight to see your BMI'),
                        ElevatedButton(
                            onPressed: () => saveAndQuit(),
                            child: Text("Save"),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 99, 0, 68)))
                      ],
                    ),
                  ),
                );
              });
        })));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nameControl.dispose();
    surnameControl.dispose();
    heightControl.dispose();
    weightControl.dispose();
    super.dispose();
  }

  Future<void> saveAndQuit() async {
    bool error = false;
    String pattern = r'^(\d*)$'; // checks for digits only
    RegExp regex = RegExp(pattern);

    if (nameControl.text != '') {
      name = nameControl.value.text;
      //name and surname can have any characters
    }

    if (surnameControl.text != '') {
      surname = surnameControl.value.text;
    }

    if (heightControl.text != '') {
      if (!regex.hasMatch(heightControl.value.text)) {
        error = true;
      } else {
        height = int.parse(heightControl.value.text);
      }
    }
    if (weightControl.text != '') {
      if (!regex.hasMatch(weightControl.value.text)) {
        error = true;
      } else {
        weight = double.parse(weightControl.value.text);
      }
    }
    if (error == false) {
      UserData g = UserData(0, name, surname, height, weight);
      await Provider.of<DatabaseRepository>(context, listen: false)
          .insertUser(g);
    } else {
      showDialog(
        // if error is true a show dialog is called
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
  final String? hint;
  TextEditingController control;
  NTile(
      {Key? key, required this.text, required this.control, required this.hint})
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
          Text('${widget.text} : ${widget.hint}'),
          TextField(
            controller: widget.control,
            keyboardType: TextInputType.number,
            maxLength: 10,
          )
        ],
      ),
    );
  }
}

class NameTile extends StatefulWidget {
  final String text;
  final String? hint;
  TextEditingController control;
  NameTile(
      {Key? key, required this.text, required this.control, required this.hint})
      : super(key: key);

  @override
  State<NameTile> createState() => _NameTile();
}

class _NameTile extends State<NameTile> {
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
          Text('${widget.text} : ${widget.hint}'),
          TextField(
            controller: widget.control,
            maxLength: 10,
          )
        ],
      ),
    );
  }
}
