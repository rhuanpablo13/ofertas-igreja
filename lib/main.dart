import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:ofertasigrejaflutter/screens/home_screen.dart';
import 'package:ofertasigrejaflutter/screens/login_home_screen.dart';
import 'package:ofertasigrejaflutter/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScopedModel<UserModel>(
        // Tudo que estiver abaixo do ScopedModel vai ter acesso ao model
        model: UserModel(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
             visualDensity: VisualDensity.adaptivePlatformDensity,
             primaryColor: Color.fromARGB(255, 0, 144, 222),
             fontFamily: 'Roboto Regular',
          ),
          debugShowCheckedModeBanner: false,
          home: LoginHomeScreen()
        ),
    );
  }
}