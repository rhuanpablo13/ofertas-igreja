import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/screens/minha_conta_screen.dart';


class MinhaContaButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return SizedBox(
        height: 100.0,
        child: Card(
           color: Colors.blueGrey,
           child: FlatButton(
              onPressed: () {
                 print('minha conta button');
                 Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MinhaContaScreen())
                 );
              },
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    Text('Minha Conta',
                       textAlign: TextAlign.right,
                       style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: 'Roboto Light'
                       )
                    ),
                    Icon(Icons.account_circle, color: Colors.white, size: 40.0)
                 ],
              )
           ),
        ),
     );
  }
}
