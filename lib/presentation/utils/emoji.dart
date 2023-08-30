class Emoji {
  ///
  final String code;

  Emoji({required this.code});

  String get encoding {
    return code.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  }

  @override
  String toString() {
    return '"code": $code';
  }
}
