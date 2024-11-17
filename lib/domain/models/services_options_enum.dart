enum ServiceOptionsEnum {
  
  identity_verification('Identity Verification (Default)'),
  facial_verification('Biometrics/Facial Verification'),
  document_verification('Document Integrity Verification'),
  all('All');

  const ServiceOptionsEnum(this.value);
  final String value;

  @override
  String toString() => value;

  /// a special method that returns a lowercase/space-less string representation of a ServiceOptionsEnum item
  String toJson() => name.toString();
}
