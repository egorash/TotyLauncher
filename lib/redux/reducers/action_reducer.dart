import 'package:toty/models/App.dart';
import 'package:toty/redux/actions/actions.dart';

List<App> appActionReducer(List<App> apps, dynamic action) {
  if (action is AddAppAction) {
    return addApp(apps,action);
  }

  return apps;
}

List<App> addApp(List<App> apps,AddAppAction action) {
  return new List.from(apps)[apps.length + 1]..add(action.app);
}