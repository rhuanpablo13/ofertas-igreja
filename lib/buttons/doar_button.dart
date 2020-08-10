import 'package:flutter/material.dart';
import 'package:ofertasigrejaflutter/screens/doar_screen.dart';


class DoarButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return SizedBox(
        height: 100.0,
        child: Card(
           color: Colors.blue,
           child: FlatButton(
              onPressed: () {
                 print('doar button');
                 Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DoarScreen())
                 );

              },
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    Text('Doar',
                       textAlign: TextAlign.right,
                       style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontFamily: 'Roboto Light'
                       )
                    ),
                    Icon(Icons.people, color: Colors.white, size: 40.0)
                 ],
              )
           ),
        ),
     );
  }
}
