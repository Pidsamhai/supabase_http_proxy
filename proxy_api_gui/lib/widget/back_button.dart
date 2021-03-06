import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.pop(),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}
