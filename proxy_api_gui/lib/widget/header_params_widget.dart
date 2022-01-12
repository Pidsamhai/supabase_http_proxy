import 'package:flutter/material.dart';
import 'package:proxy_api_gui/model/template.dart';

class HeaderParamsWidget extends StatelessWidget {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();

  final ValueChanged<HeaderParamsWidget>? onRemove;

  HeaderParamsWidget({Key? key, HeaderParams? headerParams, this.onRemove})
      : super(key: key) {
    _keyController.text = headerParams?.key ?? "";
    _valueController.text = headerParams?.value ?? "";
  }

  HeaderParams get headerparams =>
      HeaderParams(_keyController.text, _valueController.text);
  Map<String, String> get mapData =>
      {_keyController.text: _valueController.text};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: _keyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Key',
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Key is required *'
                    : null;
              },
            ),
          ),
          const SizedBox.square(dimension: 16),
          Flexible(
            child: TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Value',
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Value is required *'
                    : null;
              },
            ),
          ),
          const SizedBox.square(dimension: 16),
          FloatingActionButton.small(
            heroTag: UniqueKey(),
            onPressed: () => onRemove?.call(this),
            child: Icon(
              Icons.remove,
              color: Colors.grey.shade900,
            ),
            backgroundColor: Colors.grey.shade400,
          )
        ],
      ),
    );
  }
}
