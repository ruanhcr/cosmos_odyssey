import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  Env._();

  static String get nasaApiKey {
    final key = dotenv.env['NASA_API_KEY'];
    
    if (key == null || key.isEmpty) {
      throw Exception('NASA_API_KEY não encontrada no arquivo .env');
    }

    return key;
  }

  static String get baseUrl {
    final url = dotenv.env['BASE_URL'];

    if (url == null || url.isEmpty) {
      return 'https://api.nasa.gov';
    }
    
    return url;
  }
}