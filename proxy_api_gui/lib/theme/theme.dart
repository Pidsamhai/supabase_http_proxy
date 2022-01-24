import 'package:flutter/material.dart';

const TextStyle labelLage = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Colors.white,
);

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
  ),
);

ButtonStyle socialLoginButtonStyle(Color color) => ElevatedButton.styleFrom(
      primary: color,
      padding: const EdgeInsets.all(16),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );

final DialogTheme dialogTheme = DialogTheme(
  backgroundColor: Colors.purple[45],
  titleTextStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  contentTextStyle: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(28)),
  ),
);

final ButtonStyle actionButtonStyle = TextButton.styleFrom(
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  minimumSize: const Size(0, 40),
  primary: Colors.black,
);
