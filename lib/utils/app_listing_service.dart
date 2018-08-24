import 'dart:collection';

import 'package:flutter/services.dart';

class AppListingService {
  static const _channel = const MethodChannel('com.adamf/apps');

  static getApps() async {
    var apps;
      try {
        final data = await _channel.invokeMethod("getApps"); 
        print('Apps $data % .');
        apps = data;
        return apps;
    } on PlatformException catch (e) {
      print("Failed to get apps: '${e.message}'.");
      return null;
    }
  }
}