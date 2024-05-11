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


/// Separates PascalCase and snake_case strings and capitalizes the first letter of each word,
/// while ignoring words or phrases in parentheses () and all-caps words.
///
/// Given a string [input], this function separates it into words, considering both snake_case
/// and PascalCase conventions. It then capitalizes the first letter of each word and returns
/// the resulting string. Words or phrases in parentheses () and all-caps words are ignored.
///
/// For example:
/// capitalizeWords('snake_case_string') returns 'Snake Case String'
/// capitalizeWords('PascalCaseString') returns 'Pascal Case String'
///
/// If the input string is empty or consists only of underscores ('_'), the function returns
/// an empty string.
///
/// Note: This function assumes that the input string follows either the snake_case or
/// PascalCase conventions. It does not handle other casing styles.
String capitalizeWords(String input) {
  List<String> words = input.split('_'); // Split snake_case string into words
  words = words.expand((word) => word.split(RegExp(r'(?=[A-Z])'))).toList(); // Split PascalCase words
  String result = '';
  for (String word in words) {
    if (word.isNotEmpty && !word.contains('(') && !word.contains(')') && !word.toUpperCase().contains(word)) {
      result += '${word[0].toUpperCase()}${word.substring(1)} '; // Capitalize first letter and add to result
    } else {
      result += '$word '; // Add the word as it is
    }
  }
  return result.trim().replaceAll('  ', ' ').replaceAll('( ', '(').replaceAll(' )', ')'); // Remove trailing space
}

