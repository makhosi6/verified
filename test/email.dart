extension EmailFunctions on String {
  String? getFullNameFromEmail() {
    String? username = extractNamesFromEmail();
    List<String?> nameParts = (username ?? '').split('.');
    if (nameParts.length >= 2) {
      String? firstName = removeNumbersAndSpecialChars(nameParts[0] ?? '').capitalize();
      String? lastName = removeNumbersAndSpecialChars(nameParts.sublist(1).join(' ')).capitalize();
      return '$firstName $lastName'.capitalize();
    } else {
      return removeNumbersAndSpecialChars(username ?? '').capitalize();
    }
  }

  String? extractNamesFromEmail() {
    List<String> parts = this.split('@');
    if (parts.length == 2) {
      return removeNumbersAndSpecialChars(parts[0].capitalize() ?? '').trim();
    }
    return null;
  }

  String removeNumbersAndSpecialChars(String text) {
    return text.replaceAll(RegExp(r'[0-9_]'), ' ').replaceAll('-', ' ').replaceAll('.', ' ').replaceAll('_', ' ').trim();
  }
  String extractUsernameFromEmail() {
    List<String> parts = this.split("@");
    if (parts.length == 2) {
      return parts[0];
    }
    return "";
  }
}




extension StringExtension on String {
  String? capitalize() {
    if (this.isEmpty) {
      return null;
    }
    final asArr = this.split(' ');
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

    return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
}

void main() {
  var emails = [
    'john.doe@example.com',
    'jane_smith123@gmail.com',
    'mohammed.ali@hotmail.com',
    'emily-jones@yahoo.com',
    'david1234@outlook.com',
    'sarah.miller@example.org',
    'alexander.wang@gmail.com',
    'anna_kowalski@live.com',
    'robert.johnson@example.net',
    'maria.garcia@yahoo.co.uk',
    'samantha_clark@aol.com',
    'william_green@hotmail.co.uk',
    'lisa123@yahoo.ca',
    'joseph_nguyen@example.com.au',
    'amanda.brown@gmail.co.jp',
    'michael-smith@outlook.co.in',
    'sophia_wilson@example.org.uk',
    'jackson_taylor@hotmail.fr',
    'olivia_martin@yahoo.de',
    'daniel.murphy@example.it',
    'emma_white@gmail.com.br',
    'ethan_hall@yahoo.es',
    'mia_rivera@outlook.mx',
    'jacob_morris@example.nl',
    'ava.wang@hotmail.be',
    'noah_sanchez@yahoo.se',
    'mia.robinson@example.ch',
    'lucas.gomez@gmail.dk',
    'isabella_miller@outlook.no',
    'liam_brown@yahoo.fi',
    'makhosindondo@gmail.com',
    'ndondo330@gmail.com',
    'makhosi@work.io'
  ];

  for (var email in emails) {
    print('$email  => |${email.extractUsernameFromEmail()}|  ==> |${email.getFullNameFromEmail()}|');
  }
}
