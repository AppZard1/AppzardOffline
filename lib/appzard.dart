import 'package:appzard/util.dart';
import 'package:args/args.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  final argParser = ArgParser()
    ..addFlag('help', abbr: 'h', callback: (start) {
      if (start) {
        print('Hello there,\n'
            'Welcome to Appzard command line interface! You '
            'can use this interface to run appzard workspace locally.\n'
            'Available Flags:\n --version (abbr: -v): displays appzard version\n '
            '--help (abbr: -h) Displays the help message\n'
            'Available Commands:\n - start starts a new appzard instance');
      }
    })
    ..addFlag('version', abbr: 'v', callback: (start) {
      if (start) {
        print('1');
      }
    });
  argParser.addCommand('start');

  final result = argParser.parse(arguments);
  if (Util.getCommand(result) == 'start') {
      print('Starting Appzard..');
      var val = await Util.isAppzardRunning();
      if (val) {
        printError('An appzard instance is already running!');
        io.exit(0);
      } else {
        Util.checkIfAppzardIsRunning().then((value) =>
            printGreen("Appzard is running!"));
            Util.openUrl("http://localhost:8888");
            printWarning("You are being redirected to appzard's local instance url, in case it doesn't start, please navigate manually to http://localhost:8888");
        io.Process.run(path.join(
            Util.getAppDataDir()!, 'deps', 'appengine', 'bin',
            'dev_appserver.cmd'), [
          '--port=8888',
          '--address=0.0.0.0',
          path.join(Util.getAppDataDir()!, "deps", "build", "war")
        ]);
      }
  }
}

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

void printGreen(String text) {
  print('\x1B[32m$text\x1B[0m');
}

