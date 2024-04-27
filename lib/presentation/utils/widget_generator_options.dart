import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CaptureUserDetailsInputOption {
  final String hintText;

  final String? initialValue;

  final String label;

  final String? inputMask;

  final List<TextInputFormatter>? inputFormatters;

  final bool autofocus;
  
  final int? maxLength;

  final TextInputType? keyboardType;

  final String? Function(String?)? validator;

  final Function(String) onChangeHandler;

  CaptureUserDetailsInputOption({
    required this.hintText,
    this.initialValue,
    required this.label,
    this.maxLength,
    this.inputMask,
    required this.autofocus,
    required this.inputFormatters,
    required this.keyboardType,
    required this.validator,
    required this.onChangeHandler,
  });
}


class AuthButtonsOption {
  final VoidCallback onTapHandler;
  final String label;
  final Widget icon;

  const AuthButtonsOption({
    required this.onTapHandler,
    required this.label,
    required this.icon,
  });
}