import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileLogOutput extends LogOutput {
  File? _file;

  Future<File> _getLogFile() async {
    if (_file != null) return _file!;
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/app_logs.txt');
    if (!(await _file!.exists())) {
      await _file!.create(recursive: true);
    }
    return _file!;
  }

  @override
  void output(OutputEvent event) async {
    final file = await _getLogFile();
    for (var line in event.lines) {
      await file.writeAsString(line + '\n', mode: FileMode.append);
    }
  }
}

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  late Logger logger;

  factory AppLogger() {
    return _instance;
  }

  AppLogger._internal() {
    logger = Logger(
      printer: PrettyPrinter(),
      output: MultiOutput([
        ConsoleOutput(), // konsolda görmək üçün
        FileLogOutput(), // fayla yazmaq üçün
      ]),
    );
  }
}
