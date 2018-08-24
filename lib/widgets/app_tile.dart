import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:toty/models/App.dart';
import 'package:toty/widgets/tile.dart';

class AppTile extends StatelessWidget{
  final App app;

  AppTile(this.app);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<App>, onStateChanged> (
      converter: (store) {
        
      },
      builder: (context, callback) {
        return Tile(
          title: app.title,
          scale: 2.0,
          function: () {
            launchApp(app.launcherString); 
          }
        );
      }
    );
  }
}

typedef onStateChanged = Function(App app);
void launchApp(String packageName) {
    LauncherAssist.launchApp(packageName);
}