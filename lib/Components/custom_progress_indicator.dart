import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  final String imagePath; // your PNG image path
  final double size;

  const CustomProgressIndicator({
    super.key,
    required this.imagePath,
    this.size = 80,
  });

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // full rotation duration
    )..repeat(); // keep rotating
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.1416, // rotate full circle
              child: child,
            );
          },
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
