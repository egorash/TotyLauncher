package com.example.toty;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.adamf/apps";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
              if (call.method.equals("getApps")) {
                  List<Map<String, Object>> _output = new ArrayList<>();
                  List<ApplicationInfo> apps = getApps();

                for (ApplicationInfo app : apps) {
                    if( getPackageManager().getLaunchIntentForPackage(app.packageName) != null ){
                        Map<String, Object> current = new HashMap<>();
                        current.put("label", app.loadLabel(getPackageManager()).toString());
                        current.put("package", app.packageName);
                        _output.add(current);
                    }
                }

                if (_output != null) {
                    result.success(_output);
                } else {
                    result.error("UNAVAILABLE", "Apps not available.", null);
                }
              } else {
                  result.notImplemented();
              }
            }
        });
  }

  @Override
  public void onBackPressed() {
    return;
  }

  private List<ApplicationInfo> getApps() {
    final PackageManager pm = getPackageManager();
    List<ApplicationInfo> packages = pm.getInstalledApplications(PackageManager.GET_META_DATA);
    return packages;
  }
}
