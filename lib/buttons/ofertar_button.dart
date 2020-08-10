import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/models/user_model.dart';
import 'package:ofertasigrejaflutter/screens/oferta_screen.dart';


class OfertarButton extends StatelessWidget {

   final UserModel model;
   OfertarButton(this.model);

   @override
   Widget build(BuildContext context) {
     return SizedBox(
        height: 100.0,
        child: Card(
           color: Colors.green,
           child: FlatButton(
              onPressed: () {
                 print('ofertar button');
                 Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OfertaScreen(model))
                 );
              },
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    Text('Ofertar',
                       textAlign: TextAlign.right,
                       style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: 'Roboto Light'
                       )
                    ),
                    Icon(Icons.monetization_on, color: Colors.white, size: 40.0)
                 ],
              )
           ),
        ),
     );
   }
}
