import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Tile extends StatelessWidget {
  final Function function;
  final String title;
  final double scale;
  final MainAxisAlignment axis;
  const Tile({ Key key, this.title, this.function, this.scale = 1.0, this.axis = MainAxisAlignment.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: axis,
        children: <Widget>[
        FlatButton(
          padding: const EdgeInsets.all(8.0),
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