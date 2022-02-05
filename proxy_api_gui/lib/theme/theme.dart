import 'package:flutter/material.dart';

const TextStyle labelLage = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: Colors.white,
);

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  elevation: 0,
  padding: const EdgeInsets.only(left: 24, right: 24),
  minimumSize: const Size(64, 40),
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

AppBarTheme appBarTheme(BuildContext context) => AppBarTheme(
      color: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: Theme.of(context)
          .textTheme
          .headline5
          ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
    );

final ButtonStyle textButtonStyle = TextButton.styleFrom(
  padding: const EdgeInsets.only(left: 12, right: 12),
  minimumSize: const Size(64, 40),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
  ),
);

ThemeData appThemeData(BuildContext context) {
  return ThemeData.from(colorScheme: const ColorScheme.light()).copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
    textButtonTheme: TextButtonThemeData(style: textButtonStyle),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      highlightElevation: 4,
      hoverElevation: 2,
      extendedTextStyle: TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    dialogTheme: dialogTheme,
    appBarTheme: appBarTheme(context),
  );
}
