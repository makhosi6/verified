enum HelpType {
  billing('Billing/Refund'),
  service('Feedback/Service Complaint'),
  deleteInfo('Permanently delete your account'),
  other('Other');

  const HelpType(this.value);
  final String value;

  @override
  String toString() => value;

  HelpType _toHelpType(String type) => switch (type) {
        'Billing/Refund' => HelpType.billing,
        'Feedback/Service Complaint' => HelpType.service,
        'Permanently delete your account' => HelpType.deleteInfo,
        _ => HelpType.other
      };

  HelpType fromJson(String type) => _toHelpType(type);

  HelpType fromString(String type) => _toHelpType(type);
}
