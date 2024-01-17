import 'package:flutter/services.dart';

class VerifiedTextInputFormatter extends TextInputFormatter {
  String? mask;
  String? separator;

  VerifiedTextInputFormatter({
    this.mask = '000000 0000 000',
    this.separator = ' ',
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';
    int maskCharIndex = 0;
    int inputCharIndex = 0;

    while (inputCharIndex < newValue.text.length && maskCharIndex < mask!.length) {
      if (mask![maskCharIndex] == '0') {
        newText += newValue.text[inputCharIndex];
        inputCharIndex++;
      } else {
        newText += mask![maskCharIndex];
        if (newValue.text[inputCharIndex] == mask![maskCharIndex]) {
          inputCharIndex++;
        }
      }
      maskCharIndex++;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
