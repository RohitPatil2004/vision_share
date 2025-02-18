import 'package:flutter/material.dart';

class PopAnimation extends StatefulWidget {
  final Widget child;

  const PopAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _PopAnimationState createState() => _PopAnimationState();
}

class _PopAnimationState extends State<PopAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}