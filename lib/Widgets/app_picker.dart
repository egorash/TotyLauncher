import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPicker extends StatefulWidget {
    final Map currentApps;
    AppPicker({Key key, @required this.currentApps}) : super(key: key);
    @override
    State createState() => new AppPickerState();
}

class AppPickerState extends State<AppPicker> {
    int current_step = 0;

    String getAppName(int index) {
      return widget.currentApps[index].toString();
    }

  @override
  Widget build(BuildContext context) {
    List<Step> my_steps = [
      new Step(                  
          title: new Text("App 1"),                    
          content: new Text("Hello"),
          isActive: true),          
      new Step(          
          title: new Text("App 2"),          
          content: new Text("Hello!"),
          isActive: true),
      new Step(          
          title: new Text("App 3"),          
          content: new Text("Hello!"),
          isActive: true),
      new Step(          
          title: new Text("App 4"),          
          content: new Text("Hello!"),
          isActive: true),
      new Step(          
          title: new Text("App 5"),          
          content: new Text("Hello!"),
          isActive: true),          
    ];

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