enum ServiceOptionsEnum {
  identity_verification('Identity Verification (Default'),
  qualifications_verification('Qualifications Verification'),
  criminal_verification('Criminal Record Checks'),
  credit_check_verification('Credit History Check'),
  all('All');

  const ServiceOptionsEnum(this.value);
  final String value;

  @override
  String toString() => value;

  /// a special method that returns a lowercase/space-less string representation of a ServiceOptionsEnum item
  String toJson() => name.toString();
}
