import 'package:flutter/material.dart';

class LinkButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  const LinkButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  _LinkButtonState createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  TextDecoration decoration = TextDecoration.none;

  _showUnderLine() {
    setState(() {
      decoration = TextDecoration.underline;
    });
  }

  _hideUnderLine() {
    setState(() {
      decoration = TextDecoration.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => _showUnderLine(),
      onExit: (event) => _hideUnderLine(),
      child: GestureDetector(
        child: Text(
          widget.text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            decoration: decoration,
          ),
        ),
        onTap: widget.onPressed,
      ),
    );
  }
}
