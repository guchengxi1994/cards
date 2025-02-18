import 'package:flutter/material.dart';

class ChildWrapper extends StatelessWidget {
  const ChildWrapper(
      {super.key,
      this.child,
      required this.width,
      required this.height,
      required this.isOnTop,
      required this.onBorderPressed,
      required this.onContentPressed});
  final Widget? child;
  final double width;
  final double height;
  final bool isOnTop;
  final VoidCallback onBorderPressed;
  final VoidCallback onContentPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(20),
      elevation: isOnTop ? 10 : 4,
      child: GestureDetector(
        onTap: onBorderPressed,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border:
                Border.all(width: isOnTop ? 2 : .5, color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(50),
          child: GestureDetector(
            onTap: onContentPressed,
            child: child,
          ),
        ),
      ),
    );
  }
}
