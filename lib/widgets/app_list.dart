import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toty/models/App.dart';
import 'package:toty/widgets/app_tile.dart';

class TotyAppsList extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new StoreConnector<List<App>, List<App>> (
      converter: (store) => store.state,
      builder: (context, list) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: new List<Widget>.generate(list.length, (int i) {
            return new AppTile(list[i]);    
          })
        );
      }
    );
  }
}