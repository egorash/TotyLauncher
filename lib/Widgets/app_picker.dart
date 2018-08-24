import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toty/models/App.dart';

class AppPicker extends StatefulWidget {
    final allUserApps; 
    final List<App> currentSelectedApps;   
    AppPicker({Key key, @required this.allUserApps, this.currentSelectedApps}) : super(key: key);
    @override
    State createState() => new AppPickerState();
}

class AppPickerState extends State<AppPicker> {
    int current_step = 0;
    List<DropdownMenuItem<App>> allUserAppsMenuItems = [];

  void loadData() {
    allUserAppsMenuItems = [];
    for (var entry in widget.allUserApps) {      
      App currentApp = App(title:entry["label"], launcherString: entry["package"]);
      allUserAppsMenuItems.add(new DropdownMenuItem<App>(child: new Text(entry["label"]), value: currentApp));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    loadData();
    List<Step> my_steps = [];
    List<App> SELECTED = [];
    
    bool hasSelectedApps = SELECTED.length > 0 ? true : false;

    for (var idx = 0; idx < 5; idx++) {
      my_steps.add(
        new Step(                  
          title: new Text("App ${idx+1}"),                    
          content: new DropdownButton(
            value: hasSelectedApps ? SELECTED[idx].title : null,
            items:allUserAppsMenuItems.toList(),
            hint: new Text(hasSelectedApps ? SELECTED[idx].title : "Select an App"), 
            onChanged: (app) {                                             
              setState(() {
                SELECTED.add(App(title: app.title, launcherString: app.launcherString));
                widget.currentSelectedApps.add(SELECTED[idx]);               
              });
            }
          ),
          isActive: true)
      );
    }

    return Column(
      children: <Widget>[new Container(        
        child: new Stepper(                    
        currentStep: this.current_step,
        steps: my_steps,
        type: StepperType.vertical,
        onStepTapped: (step) {
          setState(() {
            current_step = step;
          });
          // Log function call
          print("onStepTapped : " + step.toString());
        },
        onStepCancel: () {
          setState(() {
            if (current_step > 0) {
              current_step = current_step - 1;
            } else {
              current_step = 0;
            }
          });
          print("onStepCancel : " + current_step.toString());
        },
        onStepContinue: () {
          setState(() {
            if (current_step < my_steps.length - 1) {
              current_step = current_step + 1;
            } else {
              current_step = 0;
            }
          });
          print("onStepContinue : " + current_step.toString());
        },
      ))]
    );
  }
}