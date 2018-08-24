import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:toty/redux/store/store_connector.dart';
import 'package:toty/widgets/app_picker.dart';
import 'package:toty/widgets/tile.dart';
import 'package:toty/utils/app_listing_service.dart';

class TotyLauncher extends StatefulWidget {
    @override
    State createState() => new TotyLauncherState();
}

class TotyLauncherState extends State<TotyLauncher> {
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

        loadNativeStuff();        
    }

    void loadNativeStuff() {
      AppListingService.getApps().then((_appDetails) {
          setState(() {
              allApps = _appDetails;
          });
        });
    }

  Widget settingsTiles() {
    var tiles = <Widget>[];

    tiles.add(Tile(
      title: show_launcher_settings ? "Save and Exit" : "App Settings", 
      function: () {
        setState(() {
          show_launcher_settings = !show_launcher_settings;    
        });
    }));
    
    tiles.add(Tile(
      title: "Settings", function: () {
      LauncherAssist.launchApp("com.android.settings");
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
        show_launcher_settings ? AppPicker(allUserApps:allApps, currentSelectedApps: null) : TotyAppsList(),
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
}
