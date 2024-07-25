import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final Function()? onPressed;
  final IconData iconData;
  final double iconSize;
  final double paddingReduce;
  final Color iconColor;

  RoundedIconButton({
    required this.onPressed,
    required this.iconData,
    this.iconSize = 30,
    this.paddingReduce = 0,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: iconColor,
      padding: EdgeInsets.all((iconSize / 2) - paddingReduce),
      shape: CircleBorder(),
      child: Icon(
        iconData,
        size: iconSize,
        color: Colors.white,
      ),
    );
  }
}
