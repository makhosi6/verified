import 'package:flutter/material.dart';

void navigate(BuildContext context, {required Widget page}) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
