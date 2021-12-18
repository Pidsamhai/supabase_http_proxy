import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:proxy_api_gui/widget/dialog.dart';
import 'package:proxy_api_gui/widget/template_form.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class EditTemplatePage extends StatefulWidget {
  final String _id;
  const EditTemplatePage(this._id, {Key? key}) : super(key: key);

  @override
  State<EditTemplatePage> createState() => _EditTemplatePageState();
}

class _EditTemplatePageState extends State<EditTemplatePage> {
  Future _saveChange(Template template) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => progressDialog("Save change..."),
    );

    await Future.delayed(const Duration(seconds: 2));

    try {
      await context
          .read<ApiTemplateRepository>()
          .updateTemplate(template: template);
      context.pop();
      await Future.delayed(const Duration(milliseconds: 100));
      context.goNamed(AppRouter.main);
    } catch (e) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Edit template",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: TemplateEditForm(
              id: widget._id,
              isEditForm: true,
              onSubmit: (template) => _saveChange(template),
            ),
          ),
        ],
      ),
    );
  }
}
