import 'package:dio/dio.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/utils/const.dart';

class PlayGroundTemplate {
  String method;
  Template template;
  String path;

  PlayGroundTemplate({
    required this.method,
    required this.template,
    required this.path,
  });
}

class PlayGroundRepository {
  final dio = Dio();
  Future<Response<dynamic>?> call(PlayGroundTemplate playGroundTemplate) async {
    try {
      final options = RequestOptions(
        method: playGroundTemplate.method,
        path: playGroundTemplate.path,
        baseUrl: "$baseApiUrl${playGroundTemplate.template.uid}/template/",
        // headers: playGroundTemplate.template.headers,
        // queryParameters: playGroundTemplate.template.params,
      );
      final res = await dio.fetch<String>(options);
      return res;
    } on DioError catch (e) {
      return e.response;
    }
  }
}
