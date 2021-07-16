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
        print('Appzard version: 1.0.1');
      }
    });
  argParser.addCommand('start');

  final result = argParser.parse(arguments);
  if (Util.getCommand(result) == 'start') {
      print('Starting Appzard..');
      var val = await Util.isAppzardRunning();
      if (val) {
        printError("An appzard instance is already running! Please run appzard stop to stop this instance, or use (-f, --force) flag!");
      } else {
        Util.checkIfAppzardIsRunning().then((value) =>
            print("Appzard is running!"));
        io.Process.run(path.join(
            Util.dataDir()!, 'deps', 'appengine', 'bin',
            'dev_appserver.cmd'), [
          '--port=8888',
          '--address=0.0.0.0',
          path.join(Util.dataDir()!, "deps", "build", "war")
        ]).then((io.ProcessResult pr) {
          print(pr.exitCode);
          print(pr.stdout);
          print(pr.stderr);
        });
      }
  }
}

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

