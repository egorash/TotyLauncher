import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tile extends StatelessWidget {
  final Function function;
  final String title;
  final double scale;
  const Tile({ Key key, this.title, this.function, this.scale = 1.0 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        FlatButton(
          onPressed: function,              
          child: Text(
            title, 
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            textScaleFactor: scale,
          ),
          textColor: Colors.white,
        )]
      );
  }
}