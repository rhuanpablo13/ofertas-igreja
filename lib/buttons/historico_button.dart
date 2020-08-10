import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/screens/historico_screen.dart';


class HistoricoButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return SizedBox(
        height: 100.0,
        child: Card(
           color: Colors.black12,
           child: FlatButton(
              onPressed: () {
                 print('historico button');
                 Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HistoricoScreen())
                 );
              },
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    Text('Histórico',
                       textAlign: TextAlign.right,
                       style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: 'Roboto Light'
                       )
                    ),
                    Icon(Icons.history, color: Colors.white, size: 40.0)
                 ],
              )
           ),
        ),
     );
  }
}
