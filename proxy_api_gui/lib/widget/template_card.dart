import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/utils/const.dart';

class TemplateCard extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Template _template;
  const TemplateCard(
    this._template, {
    Key? key,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  _copyUrl(BuildContext context) {
    Clipboard.setData(ClipboardData(text: "$baseApiUrl${_template.uid}"));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copy url to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: InkWell(
        onTap: () => {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _template.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox.square(dimension: 8),
                    Opacity(
                      opacity: 0.4,
                      child: Text(
                        _template.descriptions ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox.square(dimension: 8),
                    Text("URL : $baseApiUrl${_template.uid}")
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copyUrl(context),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
