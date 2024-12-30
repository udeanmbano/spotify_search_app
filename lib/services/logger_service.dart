import 'package:logger/logger.dart';

class LoggerService {
  final Logger _logger = Logger(
    filter: null,
    printer: PrettyPrinter(methodCount: 2, errorMethodCount: 8), // Customize your logger
    output: null,
  );

  // Log a message with different log levels
  void d(String message) {
    _logger.d(message);
  }

  void i(String message) {
    _logger.i(message);
  }

  void w(String message) {
    _logger.w(message);
  }

  void e(String message) {
    _logger.e(message);
  }

  void v(String message) {
    _logger.v(message);
  }

  void wtf(String message) {
    _logger.wtf(message);
  }
}
