import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseApiUrl = dotenv.get("BASE_API_URL");
final baseTemplateUrl = baseApiUrl + "template/";
