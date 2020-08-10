import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/buttons/dizimo_button.dart';
import 'package:ofertasigrejaflutter/buttons/doar_button.dart';
import 'package:ofertasigrejaflutter/buttons/historico_button.dart';
import 'package:ofertasigrejaflutter/buttons/minha_conta_button.dart';
import 'package:ofertasigrejaflutter/buttons/ofertar_button.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_home_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<UserModel>(
       builder: (context, child, model) {
         return Scaffold(
           appBar: AppBar(
             title: Text('App Igrejas Ofertas'),
             centerTitle: true,
             actions: <Widget>[

               // botão de logout
               FlatButton(
                 child: Text(model.isLogged() ? 'Sair' : 'Login'),
                 textColor: Colors.white,
                 onPressed: () {
                   if (model.isLogged()) {
                     model.signOut();
                   }
                   Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginHomeScreen())
                   );
                 },
               )
             ],
             leading: Container(), // hide arrow button back
           ),

           body: ListView(
             children: <Widget>[
               Container(
                 height: 100.0,
                 alignment: Alignment.center,
                 child: Text(model.isLogged() ? "O que deseja fazer, ${_getFirstName(model.name)} ?" : 'Olá, seja bem vindo', textAlign: TextAlign.center,
                   style: TextStyle(
                      fontSize: 20.0
                   ),
                 ),
               ),

               MinhaContaButton(),
               OfertarButton(model),
               DizimoButton(),
               DoarButton(),
               HistoricoButton(),
             ],
           ),
         );
       }
    );
  }


  String _getFirstName(String name) {
    if (name == null || name.isEmpty) {
      return '';
    }
    return name.split(' ')[0];
  }




}
