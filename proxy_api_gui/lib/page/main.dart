import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proxy_api_gui/cubit/api_template_cubit.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:proxy_api_gui/widget/custom_dialog.dart';
import 'package:proxy_api_gui/widget/dialog.dart';
import 'package:proxy_api_gui/widget/template_card.dart';
import 'package:qlevar_router/qlevar_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    context.read<ApiTemplateCubit>().init();
  }

  Future _deleteTemplate(String id) async {
    QR.show(progressDialog("Delete..."));

    await Future.delayed(const Duration(seconds: 2));

    try {
      await context.read<ApiTemplateRepository>().deleteTemplate(id: id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete $id success")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  _confirmDelete(Template template) {
    QR.show(
      CustomDialog(
        barrierDismissible: false,
        widget: (pop) => AlertDialog(
          title: const Text('Confirm delete'),
          content: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'You want to delete ',
                ),
                TextSpan(
                  text: template.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const TextSpan(text: ' template'),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  pop.call();
                  _deleteTemplate(template.uid);
                },
                child: const Text("OK")),
            TextButton(
              onPressed: () => pop.call(),
              child: const Text("CANCEL"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text("Api Template",
                    style: Theme.of(context).textTheme.headline1),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder(
                  stream: context.read<ApiTemplateRepository>().templates(),
                  builder: (context, AsyncSnapshot<List<Template>> state) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: state.data?.length ?? 0,
                      itemBuilder: (context, index) => TemplateCard(
                        state.data![index],
                        onEdit: () => QR.to("/edit/${state.data![index].uid}"),
                        onDelete: () => _confirmDelete(state.data![index]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => QR.toName(AppRouter.createTemplate),
          label: const Text("Add Template"),
          icon: const Icon(Icons.add),
        ));
  }
}
// FloatingActionButton.extended(
//               onPressed: () => QR.toName(AppRouter.createTemplate),
//               label: const Text("Signout"),
//               icon: const Icon(Icons.power_settings_new),
//               backgroundColor: Colors.red,
//             ),