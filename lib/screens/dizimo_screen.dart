import 'package:flutter/material.dart';

class DizimoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
           title: Text('Dizimar'),
           centerTitle: true,
        ),
        body: Container(color: Colors.lightGreen,),
     );
  }
}
