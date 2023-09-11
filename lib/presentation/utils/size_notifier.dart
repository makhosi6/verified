import 'package:flutter/material.dart';

class BottomSheetSizeWrapper extends StatefulWidget {
  const BottomSheetSizeWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<BottomSheetSizeWrapper> createState() => _BottomSheetSizeWrapperState();
}

class _BottomSheetSizeWrapperState extends State<BottomSheetSizeWrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
