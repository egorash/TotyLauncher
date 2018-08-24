import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:toty/Widgets/app_picker.dart';
import 'package:toty/Widgets/tile.dart';
import 'package:toty/models/App.dart';
import 'package:toty/utils/app_listing_service.dart';
import 'package:toty/utils/preference_loading_service.dart';

void main() => runApp(new TotyLauncher());

class TotyLauncher extends StatefulWidget {
    @override
    State createState() => new TotyLauncherState();
}

class TotyLauncherState extends State<TotyLauncher> {
    var fallbackAppList = [
      new App(
        title:"Web Browser",
        launcherString:"com.android.chrome"
      )
    ];

    var show_launcher_settings = false;
    var allApps;    

    @override
    Widget build(BuildContext context) {
          return new MaterialApp(
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.black,
              accentColor: Colors.white,
            ),
            debugShowCheckedModeBanner: false,              
            home: home(),
          );
    }

    @override
    void initState() {
        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp
        ]);

        PreferenceLoader().readApps().then((apps) {
          Map<String, String> loadedApps;
          for (var entry in apps.split("\\n")) {
            var mapEntry = entry.split(":");
            var key = mapEntry[0];
            var value = mapEntry[1];            
          }
        });

        loadNativeStuff();        
    }

    void loadNativeStuff() {
      AppListingService.getApps().then((_appDetails) {
          setState(() {
              allApps = _appDetails;
          });
        });
    }

  Widget appRows() {
    var tiles = <Widget>[];
    if (fallbackAppList != null) {
      for (var app in fallbackAppList) {
        tiles.add(
          Tile(
          title: app.title, 
          scale: 2.0,
          function: () {
            setState(() {
              launchApp(app.launcherString);    
            });
        }));           
      tiles.add(SizedBox(
        height: 20.0,    
      ));    
      }  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children:tiles      
    );
  } else {
    return Container();
  } 
}

  Widget settingsTiles() {
    var tiles = <Widget>[];

    tiles.add(Tile(
      title: show_launcher_settings ? "Save and Exit" : "App Settings", 
      function: () {
        setState(() {
          if (show_launcher_settings) {
            // TODO: Write
          }
          show_launcher_settings = !show_launcher_settings;    
        });
    }));
    
    tiles.add(Tile(
      title: "Settings", function: () {
      launchApp("com.android.settings");
    }));  

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children:tiles      
    );
  }

  Widget mainContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        show_launcher_settings ? AppPicker(allUserApps:allApps, currentSelectedApps: fallbackAppList) : appRows(),
        settingsTiles()
      ]      
    );
  }

  Widget home() {
    return Center(            
      child: Container(        
        alignment: AlignmentDirectional.bottomEnd,
        child: Card(
          child: mainContainer(),
          color: Colors.black
        ),        
      )
    );
  }

  void launchApp(String packageName) {
      LauncherAssist.launchApp(packageName);
  }
}
