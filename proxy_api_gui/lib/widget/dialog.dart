import 'package:flutter/material.dart';
import 'custom_dialog.dart';

typedef PopDilog = void Function<T>([T]);

CustomDialog progressDialog(String message,
        {Function(PopDilog popDialog)? callback}) =>
    CustomDialog(
      barrierDismissible: false,
      widget: (pop) {
        callback?.call(pop);
        return AlertDialog(
          title: const Text("Loading"),
          content: SizedBox(
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox.square(dimension: 16),
                Text(message)
              ],
            ),
          ),
        );
      },
    );
