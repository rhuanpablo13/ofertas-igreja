import 'package:flutter/material.dart';

class ButtonDrawer extends StatelessWidget {

   final IconData icon;
   final String title;
   final PageController controller;
   final int page;
   final Color color;
   final BuildContext context;

   ButtonDrawer({this.icon, this.title, this.controller, this.page, this.color, this.context});

  @override
  Widget build(BuildContext context) {
     return SizedBox(
        height: 100.0,
        child: Card(
           color: color,
           child: FlatButton(
              onPressed: () {
                 Navigator.of(context).pop();
                 controller.jumpToPage(page);
              },
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                    Text(title,
                       textAlign: TextAlign.right,
                       style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontFamily: 'Roboto Light'
                       )
                    ),
                    Icon(icon, color: Colors.white, size: 40.0)
                 ],
              )
           ),
        ),
     );
  }
}
