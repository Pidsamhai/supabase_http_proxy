import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proxy_api_gui/dialog/confirm_dialog.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:proxy_api_gui/widget/dialog.dart';
import 'package:proxy_api_gui/widget/profile.dart';
import 'package:proxy_api_gui/widget/template_card.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future _signOut() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => progressDialog("Signout..."),
    );
    await context.read<AuthRepository>().signOut();
    context.pop();
    context.goNamed(AppRouter.login);
  }

  _signOutDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: const Text("Confirmation"),
        content: const Text("You want to signout"),
        onConfirm: () {
          context.pop();
          _signOut();
        },
        onCancel: () => context.pop(),
      ),
    );
  }

  Future _deleteTemplate(String id) async {
    showDialog(context: context, builder: (_) => progressDialog("Delete..."));

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
      context.pop();
    }
  }

  _confirmDelete(Template template) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' template'),
            ],
          ),
        ),
        onCancel: () => context.pop(),
        onConfirm: () {
          context.pop();
          _deleteTemplate(template.uid);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Text(
          //       "Api Template",
          //       style: Theme.of(context)
          //           .textTheme
          //           .headline5
          //           ?.copyWith(fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),
          AppBar(
            title: Text("Api Template"),
            actions: [ProfilePic()],
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder(
                stream: context.read<ApiTemplateRepository>().templates(),
                builder: (context, AsyncSnapshot<List<Template>> state) {
                  return !state.hasData || state.data?.isEmpty == true
                      ? const Center(
                          child: Text("No template"),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.data?.length ?? 0,
                          itemBuilder: (context, index) => TemplateCard(
                            state.data![index],
                            onEdit: () => context.go(
                                AppRouter.editTemplate(state.data![index].uid)),
                            onDelete: () => _confirmDelete(state.data![index]),
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 8,
        children: [
          FloatingActionButton.extended(
            heroTag: UniqueKey(),
            onPressed: _signOutDialog,
            label: Text(
              "Signout",
              style:
                  Theme.of(context).floatingActionButtonTheme.extendedTextStyle,
            ),
            icon: Icon(
              Icons.power_settings_new,
              color: Theme.of(context)
                  .floatingActionButtonTheme
                  .extendedTextStyle
                  ?.color,
            ),
            backgroundColor: Colors.red,
          ),
          FloatingActionButton.extended(
            heroTag: UniqueKey(),
            onPressed: () => context.goNamed(AppRouter.playground),
            label: Text(
              "Playground",
              style:
                  Theme.of(context).floatingActionButtonTheme.extendedTextStyle,
            ),
            icon: Icon(
              Icons.play_arrow_rounded,
              color: Theme.of(context)
                  .floatingActionButtonTheme
                  .extendedTextStyle
                  ?.color,
            ),
            backgroundColor: Colors.green.shade600,
          ),
          FloatingActionButton.extended(
            heroTag: UniqueKey(),
            onPressed: () => context.goNamed(AppRouter.createTemplate),
            label: Text(
              "Add Template",
              style:
                  Theme.of(context).floatingActionButtonTheme.extendedTextStyle,
            ),
            icon: Icon(
              Icons.add,
              color: Theme.of(context)
                  .floatingActionButtonTheme
                  .extendedTextStyle
                  ?.color,
            ),
            backgroundColor: Colors.blue.shade500,
          ),
        ],
      ),
    );
  }
}
