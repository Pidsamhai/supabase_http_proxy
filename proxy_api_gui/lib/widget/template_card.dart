import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proxy_api_gui/model/template.dart';
import 'package:proxy_api_gui/utils/const.dart';

class TemplateCard extends StatefulWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Template _template;
  const TemplateCard(
    this._template, {
    Key? key,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard> {
  double elevation = 0;

  _onEnter() => setState(() => elevation = 8);
  _onExit() => setState(() => elevation = 0);

  _copyUrl(BuildContext context) {
    Clipboard.setData(
        ClipboardData(text: "$baseApiUrl${widget._template.uid}"));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copy url to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _onEnter(),
      onExit: (event) => _onExit(),
      child: Card(
        color: Colors.purple.shade50,
        elevation: elevation,
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
                      widget._template.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox.square(dimension: 8),
                    if (widget._template.descriptions?.isNotEmpty == true) ...[
                      Opacity(
                        opacity: 0.4,
                        child: Text(
                          widget._template.descriptions ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: widget.onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
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
