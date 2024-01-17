import 'package:flutter/material.dart';

class IndexedStackSlider extends StatefulWidget {
  const IndexedStackSlider({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  /// The current index
  final int currentIndex;

  /// The list of children
  final List<Widget> children;

  @override
  State<IndexedStackSlider> createState() => _IndexedStackSliderState();
}

class _IndexedStackSliderState extends State<IndexedStackSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IndexedStackSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _pageController.animateToPage(
        widget.currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swipe between pages
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            return Align(
              alignment: Alignment.topCenter,
              child: child,
            );
          },
          child: widget.children[index],
        );
      },
    );
  }
}
