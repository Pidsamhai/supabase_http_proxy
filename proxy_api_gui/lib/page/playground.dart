import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/repository/playground_repository.dart';
import 'package:proxy_api_gui/utils/const.dart';
import 'package:proxy_api_gui/widget/custom_higlight_widget.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({Key? key}) : super(key: key);

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage>
    with TickerProviderStateMixin {
  final _urlScrollController = ScrollController();
  bool _isLoading = false;
  final _pathController = TextEditingController();
  late TabController _tabController;
  List<Template> _templates = [];
  Template? _selected;
  final List<String> _method = [
    "GET",
    "HEAD",
    "POST",
    "PUT",
    "PATCH",
    "CONNECT",
    "DELETE",
    "OPTIONS",
    "TRACE"
  ];
  String? _selectedMethod;
  Response<String>? _responseLog;
  final List<String> _tabBarItems = ["Body", "Header"];

  _rebuild() => setState(() => {});

  Future _iniData() async {
    try {
      _templates = await context.read<ApiTemplateRepository>().getTemplates();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      _rebuild();
    }
  }

  Future _senRequest() async {
    _isLoading = true;
    _rebuild();
    await Future.delayed(const Duration(seconds: 2));
    try {
      final template = PlayGroundTemplate(
        method: _selectedMethod!,
        template: _selected!,
        path: "/" + _pathController.text,
      );
      _responseLog = await context.read<PlayGroundRepository>().call(template);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      _isLoading = false;
      _rebuild();
    }
  }

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: _tabBarItems.length, vsync: this);
    _iniData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<Template>(
                    itemHeight: 60,
                    menuMaxHeight: 60,
                    hint: const Text("Select template"),
                    value: _selected,
                    onChanged: (value) => setState(() => _selected = value),
                    items: _templates
                        .map((e) => DropdownMenuItem(
                              child: Text(e.name),
                              value: e,
                            ))
                        .toList(),
                  ),
                  const SizedBox.square(dimension: 16),
                  DropdownButton<String>(
                    itemHeight: 60,
                    menuMaxHeight: 60,
                    hint: const Text("METHOD"),
                    value: _selectedMethod,
                    onChanged: (value) =>
                        setState(() => _selectedMethod = value),
                    items: _method
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                  ),
                  const SizedBox.square(dimension: 16),
                  Flexible(
                    child: TextField(
                      controller: _pathController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Path",
                        prefixText: "/",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox.square(dimension: 16),
            Scrollbar(
              controller: _urlScrollController,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: _urlScrollController,
                scrollDirection: Axis.horizontal,
                child: _selected != null
                    ? Text("URL : $baseApiUrl${_selected!.uid}")
                    : null,
              ),
            ),
            const SizedBox.square(dimension: 16),
            SizedBox(
              width: double.maxFinite,
              height: 48,
              child: ElevatedButton(
                onPressed: (_selected != null && _selectedMethod != null)
                    ? _senRequest
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading) ...[
                      const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ],
                    const SizedBox.square(dimension: 16),
                    const Text("SEND"),
                  ],
                ),
              ),
            ),
            const SizedBox.square(dimension: 16),
            if (_responseLog != null) ...[
              Text(
                "Status ${_responseLog?.statusCode} ${_responseLog?.statusMessage}",
              ),
            ],
            const SizedBox.square(dimension: 16),
            TabBar(
              controller: _tabController,
              tabs: _tabBarItems
                  .map((e) => Tab(
                        child: Text(e,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ))
                  .toList(),
            ),
            const SizedBox.square(dimension: 16),
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 500),
                      width: double.maxFinite,
                      child: _buildContentView(),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: ListView(
                      children: _responseLog?.headers.map.entries
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: SelectableText(
                                      "${e.key} : ${e.value is List ? (e.value).reduce((value, element) => value + element) : e.value}",
                                    ),
                                  ))
                              .toList() ??
                          [],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox.square(dimension: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView() {
    String? _prettyText;
    try {
      _prettyText = const JsonEncoder.withIndent("   ")
          .convert(jsonDecode(_responseLog?.data ?? ""));
    } catch (e) {
      _prettyText = null;
    }
    return CustomHighlightView(
      _prettyText ?? _responseLog?.data ?? "",
      language: _prettyText != null ? 'json' : 'text',
      theme: githubTheme,
      padding: const EdgeInsets.all(12),
    );
  }
}
