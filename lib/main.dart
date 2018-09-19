
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:toty/models/App.dart';
import 'package:toty/utils/preference_loading_service.dart';
import 'package:toty/widgets/launcher.dart';
import 'package:toty/redux/reducers/action_reducer.dart';

void main() {
    final store = new Store<List<App>>(appActionReducer, initialState: initState());
    runApp(new Toty(store));
}

List<App> initState() {
    List<App> loadedApps = new List();
    PreferenceLoader().readApps().then((apps) {          
        int idx = 0;
        for (var entry in apps.split("\\n")) {
            var mapEntry = entry.split(":");
            var key = mapEntry[0];
            var value = mapEntry[1];
            var launcherAndIndex = value.split("->"); 
            App app = new App(title: key, launcherString: launcherAndIndex[0], index: int.parse(launcherAndIndex[1]));
            loadedApps.add(app);                     
            idx++;
        }
    });

    return loadedApps;
}

class Toty extends StatelessWidget {
    final Store<List<App>> store;

    Toty(this.store);

    @override
    Widget build(BuildContext context) {
        return new StoreProvider<List<App>>(
                store: store,
                child: new TotyLauncher(),
                );
    }
}
