import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/widget/dialog.dart';
import 'package:proxy_api_gui/widget/template_form.dart';
import 'package:qlevar_router/qlevar_router.dart';

class CreateTemplatePage extends StatelessWidget {
  const CreateTemplatePage({Key? key}) : super(key: key);

  Future _createTemplate(BuildContext context, Template template) async {
    final dialog = progressDialog("Create new template...");
    QR.show(dialog);

    await Future.delayed(const Duration(seconds: 2));

    try {
      await context.read<ApiTemplateRepository>().createTemplate(template);
      Navigator.of(context, rootNavigator: true).pop();
      await Future.delayed(const Duration(milliseconds: 100));
      QR.back();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplateEditForm(
        onSubmit: (template) => _createTemplate(context, template),
      ),
    );
  }
}
