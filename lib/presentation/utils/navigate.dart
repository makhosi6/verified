import 'package:flutter/material.dart';

void navigate(BuildContext context, {required Widget page, bool replaceCurrentPage = false}) {
  final navigator = replaceCurrentPage ? Navigator.of(context).pushReplacement : Navigator.of(context).push;
  navigator(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => page,
    ),
  );
}
