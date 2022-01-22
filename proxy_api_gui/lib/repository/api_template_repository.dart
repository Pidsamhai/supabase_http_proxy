import 'dart:async';
import 'package:proxy_api_gui/model/template.dart';
import 'package:supabase/supabase.dart';
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
    // final event = await _database.ref(_templateRef).get();
    // return (event.value as Map<String, dynamic>?)?.entries.map((e) {
    //       return Template.fromJson(e.key, e.value as Map<String, dynamic>);
    //     }).toList() ??
    //     [];
    throw Exception("Not implement Yet");
  }

  Future<void> createTemplate(Template template) async {
    try {
      await _client.from(_templateRef).insert(template.toJson()).execute();
    } catch (e) {
      rethrow;
    }
  }

  Future<Template> getTemplate({required String id}) async {
    // try {
    //   final child = await _database.ref(_templateRef).child(id).get();
    //   return Template.fromJson(child.key!, child.value as Map<String, dynamic>);
    // } catch (e) {
    //   rethrow;
    // }
    throw Exception("Not implement Yet");
  }

  Future<void> deleteTemplate({required String id}) async {
    try {
      await _client.from(_templateRef).delete().eq("uid", id).execute();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTemplate({required Template template}) async {
    // try {
    //   await _database
    //       .ref(_templateRef)
    //       .child(template.uid)
    //       .update(template.toJson());
    // } catch (e) {
    //   rethrow;
    // }
    throw Exception("Not implement Yet");
  }

  static const _templateRef = "template";
}
