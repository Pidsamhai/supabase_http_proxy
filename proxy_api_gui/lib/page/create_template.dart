import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:proxy_api_gui/widget/dialog.dart';
import 'package:proxy_api_gui/widget/template_form.dart';
import 'package:go_router/go_router.dart';

class CreateTemplatePage extends StatelessWidget {
  const CreateTemplatePage({Key? key}) : super(key: key);

  Future _createTemplate(BuildContext context, Template template) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => progressDialog("Create new template..."),
    );

    await Future.delayed(const Duration(seconds: 2));

    try {
      await context.read<ApiTemplateRepository>().createTemplate(template);
      context.pop();
      await Future.delayed(const Duration(milliseconds: 100));
      context.goNamed(AppRouter.main);
    } catch (e) {
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
            child: Row(
              children: [
                BackButton(
                  onPressed: () => context.goNamed(AppRouter.main),
                ),
                Text(
                  "Create new template",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: TemplateEditForm(
              onSubmit: (template) => _createTemplate(context, template),
            ),
          ),
        ],
      ),
    );
  }
}
