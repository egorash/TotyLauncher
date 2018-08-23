import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:toty/Widgets/app_picker.dart';
import 'package:toty/Widgets/tile.dart';
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

    var exampleApps = {
      "Evernote": "com.evernote",
      "Trello" : "com.trello",
      "WhatsApp": "com.whatsapp",
      "GCal": "com.google.android.calendar", 
      "Gmail": "com.google.android.gm"
    };

    var show_launcher_settings = false;
    var apps;
    var widgets;
    var userApps;
    var userWallpaper;

    @override
    Widget build(BuildContext context) {
        if(apps != null) {
            return new MaterialApp(
              theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.black,
                accentColor: Colors.white,
              ),
              debugShowCheckedModeBanner: false,              
              home: home(),
            );
        } else {       
            return new Center();
        }
    }

    @override
    void initState() {
        SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp
        ]);

        PreferenceLoader().readApps().then((apps) {
          LinkedHashMap<String, String> loadedApps;
          apps.split("\\n").forEach( (splitLine) {
            var mapEntry = splitLine.split(":");
            var key = mapEntry[0];
            var value = mapEntry[1];
            loadedApps[key] = value;          
          });

            setState(() {
                userApps = loadedApps;
            });
        });

        loadNativeStuff();        
    }

    void loadNativeStuff() {
        LauncherAssist.getAllApps().then((_appDetails) {
          setState(() {
              apps = _appDetails;
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
    if (apps != null) {  
      exampleApps.forEach((key, value) {
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
        show_launcher_settings ? AppPicker() : appRows(),
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
