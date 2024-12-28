import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static late final String serverURL;

  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env.development");
    } catch (e) {
      await dotenv.load(fileName: ".env");
    }

    serverURL = dotenv.env['SERVER'] ?? 'Không tìm thấy server!';
  }
}
