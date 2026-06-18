import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class AppConfig {
  static final Logger _logger = Logger();

  static late String _baseUrl;
  static late String _jwtSecret;
  static late String _logLevel;

  static String get baseUrl => _baseUrl;
  static String get jwtSecret => _jwtSecret;
  static String get logLevel => _logLevel;

  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env");

      _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080/api/v1';
      _jwtSecret = dotenv.env['JWT_SECRET'] ?? 'your_secret';
      _logLevel = dotenv.env['LOG_LEVEL'] ?? 'debug';

      _logger.i('AppConfig initialized successfully');
      _logger.i('Base URL: $_baseUrl');
    } catch (e) {
      _logger.e('Error initializing AppConfig: $e');
      rethrow;
    }
  }
}
