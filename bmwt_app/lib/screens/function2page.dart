import 'package:flutter/material.dart';

class Function2Page extends StatelessWidget {
  const Function2Page({Key? key}) : super(key: key);

  static const route = '/function2';
  static const routename = 'Function2Page';
  
  @override
  Widget build(BuildContext context) {
    print('${Function2Page.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(Function2Page.routename),
      ),
      body: const Center(
        child: Text('Function2Page to be implemented'),
      ),
    );
  } //build

} //Page