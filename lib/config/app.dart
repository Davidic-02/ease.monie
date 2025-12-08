// final Map<String, dynamic> baseHeaders = {'Accept': 'application/json'};

import 'package:esae_monie/config/env_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final Map<String, dynamic> baseHeaders = {
  'Accept': 'application/json',
  'Authorization': 'Bearer ${dotenv.env[EnvKeys.flutterWaveSecretKey]}',
};
