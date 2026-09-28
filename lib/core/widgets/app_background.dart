import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.usePattern = true,
  });

  final Widget child;
  final bool usePattern;

  @override
  Widget build(BuildContext context) {
    if (!usePattern) {
      return child;
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_pattern.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
