import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';
}