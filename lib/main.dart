import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:toty/Widgets/app_picker.dart';
import 'package:toty/Widgets/tile.dart';
import 'package:toty/utils/app_listing_service.dart';
import 'package:toty/utils/preference_loading_service.dart';

void main() => runApp(new TotyLauncher());

class TotyLauncher extends StatefulWidget {
    @override
    State createState() => new TotyLauncherState();
}

class TotyLauncherState extends State<TotyLauncher> {
    var fallbackAppList = {
      "Web Browser":"com.android.chrome"
    };

    var show_launcher_settings = false;
    var allApps;
    Map<String, String> userApps = Map<String, String>();
    var userWallpaper;

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
            userApps[key] = value;
          }
          setState(() {
            if (userApps == null || userApps.length == 0) {
              userApps = fallbackAppList;
            }
          });
        });

        loadNativeStuff();        
    }

    void loadNativeStuff() {
      AppListingService.getApps().then((_appDetails) {
        print("================================================");
        print("NATIVE CALLED: $_appDetails");
        print("================================================");
          setState(() {
              allApps = _appDetails;
          });
        });
        LauncherAssist.getWallpaper().then((_imageData) {
          setState(() {
              userWallpaper = _imageData;
          });
        });
    }

  Widget appRows() {
    var tiles = <Widget>[];
    if (userApps != null) {  
      userApps.forEach((key, value) {
        tiles.add(
          Tile(
          title: key, 
          scale: 2.0,
          function: () {
            setState(() {
              launchApp(value);    
            });
        }));           
      tiles.add(SizedBox(
        height: 20.0,    
      ));      
    });

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
      title: show_launcher_settings ? "Back" : "App Settings", 
      function: () {
        setState(() {
          if (show_launcher_settings) {
            PreferenceLoader().writeAllApps(userApps);
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
        show_launcher_settings ? AppPicker(currentApps: userApps, userApps: allApps) : appRows(),
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
