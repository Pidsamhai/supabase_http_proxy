import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/widget/header_params_widget.dart';
import 'package:go_router/go_router.dart';

class TemplateEditForm extends StatefulWidget {
  final String? id;
  final ValueChanged<Template>? onSubmit;
  final bool isEditForm;
  const TemplateEditForm({
    Key? key,
    this.id,
    this.onSubmit,
    this.isEditForm = false,
  }) : super(key: key);

  @override
  State<TemplateEditForm> createState() => _TemplateEditFormState();
}

class _TemplateEditFormState extends State<TemplateEditForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final List<HeaderParamsWidget> _headerWidgets = [];
  final List<HeaderParamsWidget> _paramWidgets = [];

  _rebuild() => setState(() => {});

  _removeHeadersWidget(HeaderParamsWidget widget) {
    _headerWidgets.remove(widget);
    _rebuild();
  }

  _removeParamsWidget(HeaderParamsWidget widget) {
    _paramWidgets.remove(widget);
    _rebuild();
  }

  Future<void> _loadTemplate() async {
    try {
      final value = await context
          .read<ApiTemplateRepository>()
          .getTemplate(id: widget.id!);
      _nameController.text = value.name;
      _descriptionController.text = value.descriptions ?? "";
      _baseUrlController.text = value.baseUrl;
      _headerWidgets.addAll(value.readableHeaders.map((e) => HeaderParamsWidget(
            headerParams: e,
            onRemove: _removeHeadersWidget,
          )));
      _paramWidgets.addAll(value.readableParams.map((e) => HeaderParamsWidget(
            headerParams: e,
            onRemove: _removeParamsWidget,
          )));
      _rebuild();
    } catch (e) {
      context.pop();
    }
  }

  @override
  initState() {
    super.initState();
    if (widget.isEditForm) {
      _loadTemplate();
    }
  }

  _save() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    Map<String, String> headers = {};
    Map<String, String> params = {};

    for (var element in _headerWidgets) {
      headers.addAll(element.mapData);
    }
    for (var element in _paramWidgets) {
      params.addAll(element.mapData);
    }

    final template = Template(
      name: _nameController.text,
      descriptions: _descriptionController.text,
      baseUrl: _baseUrlController.text,
      headers: headers,
      params: params,
    );
    if (widget.isEditForm) {
      template.uid = widget.id!;
    }
    widget.onSubmit?.call(template);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    validator: (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'Name is required *'
                          : null;
                    },
                  ),
                  const SizedBox.square(dimension: 16),
                  TextFormField(
                    controller: _baseUrlController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'BaseUrl',
                    ),
                    validator: (String? value) {
                      return (value != null && value.isEmpty)
                          ? 'BaseUrl is required *'
                          : null;
                    },
                  ),
                  const SizedBox.square(dimension: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Descriptions",
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox.square(dimension: 16),
                  _sectionHeader(
                      title: "Headers",
                      onAdd: () {
                        setState(() {
                          _headerWidgets.add(HeaderParamsWidget(
                            onRemove: _removeHeadersWidget,
                          ));
                        });
                      }),
                  const SizedBox.square(dimension: 16),
                  _headerParamsListWidget(list: _headerWidgets),
                  const SizedBox.square(dimension: 16),
                  _sectionHeader(
                      title: "Params",
                      onAdd: () {
                        setState(() {
                          _paramWidgets.add(HeaderParamsWidget(
                            onRemove: _removeParamsWidget,
                          ));
                        });
                      }),
                  const SizedBox.square(dimension: 16),
                  _headerParamsListWidget(list: _paramWidgets),
                  const SizedBox.square(dimension: 16),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text("SAVE"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader({required String title, required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headline6),
        FloatingActionButton.small(
          heroTag: UniqueKey(),
          onPressed: onAdd,
          child: Icon(Icons.add, color: Colors.purple.shade900),
          backgroundColor: Colors.purple.shade50,
        )
      ],
    );
  }

  Widget _headerParamsListWidget({required List<HeaderParamsWidget> list}) {
    return Container(
      width: 500,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade300,
      ),
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        controller: ScrollController(),
        itemCount: list.length,
        itemBuilder: (context, index) => list[index],
      ),
    );
  }
}
