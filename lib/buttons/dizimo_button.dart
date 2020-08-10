import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/screens/dizimo_screen.dart';


class DizimoButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return SizedBox(
        height: 100.0,
        child: Card(
           color: Colors.lightGreen,
           child: FlatButton(
              onPressed: () {
                 print('dizimar button');
                 Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DizimoScreen())
                 );
              },
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    Text('Dizimar',
                       textAlign: TextAlign.right,
                       style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: 'Roboto Light'
                       )
                    ),
                    Icon(Icons.favorite, color: Colors.white, size: 40.0)
                 ],
              )
           ),
        ),
     );
  }
}
