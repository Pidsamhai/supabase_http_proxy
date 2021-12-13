import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:uuid/uuid.dart';

class ApiTemplateRepository {
  final FirebaseDatabase _database;
  ApiTemplateRepository(this._database);

  Future<List<Template>> getTemplates() async {
    try {
      final child = await _database.ref(_templateRef).once();
      final list = (child.snapshot.value as Map<String, dynamic>).entries.map(
          (e) => Template.fromJson(e.key, e.value as Map<String, dynamic>));
      print(child.snapshot.value as Map<String, dynamic>);
      print(list);
      return list.toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<List<Template>> templates() {
    return _database.ref(_templateRef).onValue.map((event) =>
        (event.snapshot.value as Map<String, dynamic>?)?.entries.map((e) {
          return Template.fromJson(e.key, e.value as Map<String, dynamic>);
        }).toList() ??
        []);
  }

  Future<void> createTemplate(Template template) async {
    try {
      const uuid = Uuid();
      _database.ref(_templateRef).child(uuid.v4()).set(template.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<Template> getTemplate({required String id}) async {
    try {
      final child = await _database.ref(_templateRef).child(id).get();
      return Template.fromJson(child.key!, child.value as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTemplate({required String id}) async {
    try {
      await _database.ref(_templateRef).child(id).remove();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTemplate({required Template template}) async {
    try {
      await _database
          .ref(_templateRef)
          .child(template.uid)
          .update(template.toJson());
    } catch (e) {
      rethrow;
    }
  }

  static const _templateRef = "template";
}
