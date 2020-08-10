import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages {

   static void showAlertDialog(String msg, BuildContext context) {
      showDialog(
         context: context,
         builder: (BuildContext context) {
            return AlertDialog(
               title: Text('Alerta'),
               content: Text(msg),
               actions: <Widget>[
                  FlatButton(
                     child: Text('Ok'),
                     onPressed: () {
                        Navigator.of(context).pop();
                     },
                  )
               ],
            );
         }
      );
   }


   static void showSnackBarSuccess(String msg, GlobalKey<ScaffoldState> scaffoldKey, Color color, Duration duration) {
      scaffoldKey.currentState.showSnackBar(
         SnackBar(content: Text(msg),
            backgroundColor: color,
            duration: duration
         )
      );
   }


}