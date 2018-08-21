import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';

void main() => runApp(new TotyLauncher());

class TotyLauncher extends StatefulWidget {
    @override
    State createState() => new TotyLauncherState();
}

class TotyLauncherState extends State<TotyLauncher> {

    var exampleApps = {
      "Trello" : "com.trello",
      "WhatsApp": "com.whatsapp",
      "GCal": "com.google.android.calendar", 
      "Gmail": "com.google.android.gm"
    };

    var apps;
    var widgets;
    var userWallpaper;

    @override
    Widget build(BuildContext context) {
        if(apps != null) {
            return new MaterialApp(
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

  Widget populateAppWidgets() {
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
    });

    tiles.add(SizedBox(
      height: 20.0,    
    ));

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

  }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children:tiles      
    );
  }

  Widget home() {
    return Center(            
      child: Container(        
        alignment: AlignmentDirectional.bottomEnd,
        child: Card(
          child: populateAppWidgets(),
          color: Colors.black
        ),        
      )
    );
  }

  void launchApp(String packageName) {
      LauncherAssist.launchApp(packageName);
  }
}
