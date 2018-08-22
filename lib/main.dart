import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:toty/Widgets/app_picker.dart';

void main() => runApp(new TotyLauncher());

class TotyLauncher extends StatefulWidget {
    @override
    State createState() => new TotyLauncherState();
}

class TotyLauncherState extends State<TotyLauncher> {

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
    var userWallpaper;

    @override
    Widget build(BuildContext context) {
        if(apps != null) {
            return new MaterialApp(
              theme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.lightBlue[800],
                accentColor: Colors.cyan[600],
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
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            FlatButton(
              onPressed: () {
                launchApp(value);
              },              
              child: Text(
                key,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                textScaleFactor: 2.0,
              ),
              textColor: Colors.white,
            )]
          )
        );   
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
  } 
}

  Widget settingsTiles() {
    var tiles = <Widget>[];

    tiles.add(          
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            FlatButton(
              onPressed: () {
                launchApp("com.android.settings");
              },              
              child: Text(
                "Settings",
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                textScaleFactor: 1.0,
              ),
              textColor: Colors.white,
            )]
          )
        );

    tiles.add(          
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            FlatButton(
              onPressed: () {
                setState(() {
                  show_launcher_settings = !show_launcher_settings;    
                });
              },              
              child: Text(
                show_launcher_settings ? "Apps": "Select Apps", 
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                textScaleFactor: 1.0,
              ),
              textColor: Colors.white,
            )]
          )
        );  

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
