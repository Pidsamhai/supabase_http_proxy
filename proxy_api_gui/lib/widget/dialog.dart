import 'package:flutter/material.dart';

typedef PopDilog = void Function<T>([T]);

AlertDialog progressDialog(String message) => AlertDialog(
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
