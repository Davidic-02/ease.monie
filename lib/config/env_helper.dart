import 'package:esae_monie/config/env_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get googleKey => dotenv.env[EnvKeys.googleKey] ?? '';

  static String get googleBaseUrl => dotenv.env[EnvKeys.googleBaseUrl] ?? '';
}
