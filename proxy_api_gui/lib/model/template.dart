class HeaderParams {
  late String key;
  late String value;
  HeaderParams(this.key, this.value);
  HeaderParams.fromJson(Map<String, dynamic> json) {
    key = json["key"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["key"] = key;
    data["value"] = value;
    return data;
  }
}

class Template {
  late String uid;
  late String name;
  late String baseUrl;
  String? descriptions;
  Map<String, dynamic>? headers;
  Map<String, dynamic>? params;

  List<HeaderParams> get readableHeaders =>
      headers?.entries.map((e) => HeaderParams(e.key, e.value)).toList() ?? [];

  List<HeaderParams> get readableParams =>
      params?.entries.map((e) => HeaderParams(e.key, e.value)).toList() ?? [];

  Template({
    required this.name,
    this.descriptions,
    required this.baseUrl,
    required this.headers,
    required this.params,
  });

  Template.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    name = json['name'];
    descriptions = json['descriptions'];
    baseUrl = json['baseUrl'];
    headers = json["headers"];
    params = json["params"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['descriptions'] = descriptions;
    data['baseUrl'] = baseUrl;
    data['headers'] = headers;
    data['params'] = params;
    return data;
  }
}
