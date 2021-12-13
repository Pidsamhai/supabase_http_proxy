import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/widget/dialog.dart';
import 'package:proxy_api_gui/widget/template_form.dart';
import 'package:provider/provider.dart';
import 'package:qlevar_router/qlevar_router.dart';

class EditTemplatePage extends StatefulWidget {
  final String _id;
  const EditTemplatePage(this._id, {Key? key}) : super(key: key);

  @override
  State<EditTemplatePage> createState() => _EditTemplatePageState();
}

class _EditTemplatePageState extends State<EditTemplatePage> {
  Future _saveChange(Template template) async {

    QR.show(progressDialog("Save change..."));

    await Future.delayed(const Duration(seconds: 2));

    try {
      await context.read<ApiTemplateRepository>().updateTemplate(template: template);
      Navigator.of(context, rootNavigator: true).pop();
      await Future.delayed(const Duration(milliseconds: 100));
      QR.back();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplateEditForm(
        id: widget._id,
        isEditForm: true,
        onSubmit: (template) => _saveChange(template),
      ),
    );
  }
}
