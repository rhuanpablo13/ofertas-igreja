import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:ofertasigrejaflutter/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class MinhaContaScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return SignupScreen(boAlteracao: true);
  }
}
