extension EmailFunctions on String {
  String? getFullNameFromEmail() {
    String? username = _extractNamesFromEmail();
    List<String?> nameParts = (username ?? '').split('.');
    if (nameParts.length >= 2) {
      String? firstName = removeNumbersAndSpecialChars(nameParts[0] ?? '').capitalize();
      String? lastName = removeNumbersAndSpecialChars(nameParts.sublist(1).join(' ')).capitalize();
      return '$firstName $lastName'.capitalize();
    } else {
      return removeNumbersAndSpecialChars(username ?? '').capitalize();
    }
  }

  String? _extractNamesFromEmail() {
    List<String> parts = split('@');
    if (parts.length == 2) {
      return removeNumbersAndSpecialChars(parts[0].capitalize() ?? '').trim();
    }
    return null;
  }

  String removeNumbersAndSpecialChars(String text) {
    return text.replaceAll(RegExp(r'[0-9_]'), ' ').replaceAll('-', ' ').replaceAll('.', ' ').replaceAll('_', ' ').trim();
  }
  String? extractUsernameFromEmail() {
    List<String> parts = split('@');
    if (parts.length == 2) {
      return parts[0];
    }
    return null;
  }
}




extension StringExtension on String {
  String? capitalize() {
    if (isEmpty) {
      return null;
    }
    final asArr = split(' ');
    final isTwoOrMoreWords = asArr.length > 1;

    if (isTwoOrMoreWords) {
      return asArr.map((str) {
        try {
          return str[0].toUpperCase() + str.substring(1).toLowerCase();
        } catch (e) {
          print(str);
          return str;
        }
      }).join(' ').trim();
    }

    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}