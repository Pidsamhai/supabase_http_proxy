import 'package:flutter/material.dart';
import 'package:proxy_api_gui/theme/theme.dart';

class ConfirmDialog extends StatelessWidget {
  final Widget? content;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? title;
  const ConfirmDialog({
    Key? key,
    required this.content,
    this.onCancel,
    this.onConfirm,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      contentPadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                top: 32,
                right: 24,
              ),
              child: DefaultTextStyle(
                child: title!,
                style: Theme.of(context).dialogTheme.titleTextStyle!,
              ),
            )
          ],
          if (content != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 24,
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).dialogTheme.contentTextStyle!,
                child: content!,
              ),
            )
          ]
        ],
      ),
      actions: [
        TextButton(
          style: actionButtonStyle,
          onPressed: onConfirm,
          child: const Text("OK"),
        ),
        TextButton(
          style: actionButtonStyle,
          onPressed: onCancel,
          child: const Text("CANCEL"),
        ),
      ],
    );
  }
}
