import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Function2Page extends StatelessWidget {
  Function2Page({Key? key}) : super(key: key);

  static const route = '/function2';
  static const routename = 'Function2Page';
  
  @override
  Widget build(BuildContext context) {
    print('${Function2Page.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(Function2Page.routename),
      ),
      body: Center(
        child: Text('Function2Page to be implemented'),
      ),
    );
  } //build

} //Page