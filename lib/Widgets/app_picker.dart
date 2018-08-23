import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPicker extends StatefulWidget {
    final userApps; 
    final Map<String, String> currentApps;   
    AppPicker({Key key, @required this.userApps, this.currentApps}) : super(key: key);
    @override
    State createState() => new AppPickerState();
}

class AppPickerState extends State<AppPicker> {
    int current_step = 0;
    List<DropdownMenuItem<String>> allUserApps = [];
    Map<String, String> selectedApps = Map<String, String>();

    String getAppName(int index) {
      return widget.userApps[index].toString();
    }

  void loadData() {
    allUserApps = [];
    for (var entry in widget.userApps) {      
      allUserApps.add(new DropdownMenuItem(child: new Text(entry["label"]), value: entry["package"]));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    loadData();
    List<Step> my_steps = [];
    selectedApps = widget.currentApps;
    
    for (var idx = 0; idx < 5; idx++) {
      my_steps.add(
        new Step(                  
          title: new Text("App ${idx+1}"),                    
          content: new DropdownButton(
            value: selectedApps[idx],
            items:allUserApps,
            hint: new Text(selectedApps[idx] ?? "Select an App"), 
            onChanged: (value) {
              print(value);
              print(value.runtimeType);              
              setState(() {
                selectedApps[value] = value;
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