import 'package:toty/models/App.dart';
import 'package:toty/redux/actions/actions.dart';
import 'package:toty/utils/preference_loading_service.dart';

List<App> appActionReducer(List<App> apps, dynamic action) {
  if (action is AddAppAction) {
    return addApp(apps,action);
  }

  return apps;
}

List<App> addApp(List<App> apps,AddAppAction action) {  
  List<App> updatedList = List.from(apps)..insert(action.app.index, action.app);
  PreferenceLoader().writeAllApps(List.from(apps));
  return updatedList;
}