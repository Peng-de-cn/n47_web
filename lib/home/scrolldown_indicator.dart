import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScrollDownIndicator extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollDownIndicator({super.key, required this.scrollController});

  @override
  State<ScrollDownIndicator> createState() => _ScrollDownIndicatorState();
}

class _ScrollDownIndicatorState extends State<ScrollDownIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Auto-scroll after 3 seconds if user hasn't scrolled
    _timer = Timer(const Duration(seconds: 3), () {
      if (widget.scrollController.hasClients &&
          widget.scrollController.offset == 0) {
        widget.scrollController.animateTo(
          200, // Scroll down a bit to reveal content
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: GestureDetector(
        onTap: () {
          widget.scrollController.animateTo(
            200, // Scroll down a bit to reveal content
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
          );
        },
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 95,
          color: Colors.white,
        ),
      ),
    );
  }
}