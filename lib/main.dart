
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:toty/models/App.dart';
import 'package:toty/widgets/launcher.dart';
import 'package:toty/redux/reducers/action_reducer.dart';

void main() {
  final store = new Store<List<App>>(appActionReducer, initialState: new List());
  runApp(new Toty(store));
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