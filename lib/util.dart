import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:args/args.dart';

class Util {

  static String? dataDir() {
    var os = Platform.operatingSystem;
    late String appDataDir;

    switch (os) {
      case 'windows':
        appDataDir = path.join(
            Platform.environment['UserProfile']!, 'AppData', 'Roaming');
        break;

      case 'macos':
        appDataDir = path.join(
            Platform.environment['HOME']!, 'Library', 'Application Support');
        break;

      case 'linux':
        appDataDir = path.join('home', Platform.environment['HOME']);
        break;

      default:
        break;
    }

    if (Directory(appDataDir).existsSync()) {
      final rushStorage = path.join(appDataDir, 'appzard');
      try {
        Directory(rushStorage).createSync(recursive: true);
      } catch (e) {
        return null;
      }
      return rushStorage;
    } else {
      return null;
    }
  }

  static String? getCommand(ArgResults result) {
    if (result.command != null) {
      return result.command!.name;
    }
    return null;
  }
  
  static Future<bool> isAppzardRunning()  async {
    return Socket.connect('localhost', 8888).then((value) => true).catchError((error, stackTrace) {
      if (((error as SocketException).osError!.errorCode) == 1225) {
        return Future.value(false);
      }
    });
  }

  static Future<bool> checkIfAppzardIsRunning() async {
    while (true) {
      var value = await isAppzardRunning();
      if (value) {
        break;
      }
    }
    return Future.value(true);
  }
}
