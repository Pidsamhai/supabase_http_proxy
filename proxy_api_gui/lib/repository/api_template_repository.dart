import 'dart:async';
import 'package:proxy_api_gui/model/template.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ApiTemplateRepository {
  final SupabaseClient _client;
  ApiTemplateRepository(this._client);

  Stream<List<Template>> templates() {
    // final _controller = StreamController<List<Template>>();
    // _client
    //     .from("template")
    //     .on(SupabaseEventTypes.all, (payload) {
    //       _client.from("template")
    //       .stream(uniqueColumns)
    //     })
    //     .subscribe();
    return _client
        .from("template")
        .stream(["uid"])
        .execute()
        .map((event) => event.map((e) => Template.fromJson(e)).toList());
    // return _database.ref(_templateRef).onValue.map((event) =>
    //     (event.snapshot.value as Map<String, dynamic>?)?.entries.map((e) {
    //       return Template.fromJson(e.key, e.value as Map<String, dynamic>);
    //     }).toList() ??
    //     []);
  }

  Future<List<Template>> getTemplates() async {
    try {
      final result = await _client.from(_templateRef).select("*").execute();
      return (result.data as List).map((e) => Template.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> createTemplate(Template template) async {
    try {
      await _client.from(_templateRef).insert(template.toJson()).execute();
    } catch (e) {
      rethrow;
    }
  }

  Future<Template> getTemplate({required String id}) async {
    try {
      final result = await _client
          .from(_templateRef)
          .select("*")
          .eq("uid", id)
          .single()
          .execute();
      return Template.fromJson(result.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTemplate({required String id}) async {
    try {
      await _client.from(_templateRef).delete().eq("uid", id).execute();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTemplate({required Template template}) async {
    try {
      await _client
          .from(_templateRef)
          .update(template.toJson())
          .eq("uid", template.uid)
          .execute();
    } catch (e) {
      rethrow;
    }
  }

  static const _templateRef = "template";
}
