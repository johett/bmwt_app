import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Function1Page extends StatelessWidget {
  Function1Page({Key? key}) : super(key: key);

  static const route = '/function1';
  static const routename = 'Function1Page';
  
  @override
  Widget build(BuildContext context) {
    print('${Function1Page.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(Function1Page.routename),
      ),
      body: Center(
        child: Text('Function1 to be implemented'),
      ),
    );
  } //build

} //Page