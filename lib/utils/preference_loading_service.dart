
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:toty/models/App.dart';

class PreferenceLoader {
  Future<String> get _localPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/apps.txt');
  }

  Future<bool> writeAllApps(List<App> apps) async { 
    var file = await _localFile;
    var sink = file.openWrite();

    apps.forEach((entry) {
      var key = entry.title;
      var value = entry.launcherString;
      sink.writeln("$key:$value");
    });

    sink.close();
  }

  Future<String> readApps() async {
    try {
      final file = await _localFile;
      String contents = file.readAsStringSync();
      return contents;
    } catch (e) {
      return null;
    }
  }
}