enum EnquiryReason {
  p2p_safety(value: 'Safety in Peer-to-Peer Platforms'),
  security_enhancement(value: 'Security Enhancement'),
  compliance(value: 'Regulatory Compliance'),
  fraud(value: 'Fraud and Identity Theft Prevention'),
  spam_prevention(value: 'Spam and Fake Account Prevention'),
  shared_services(value: 'User Safety in Shared Services'),
  restricted_access(value: 'Eligibility Verification for Restricted Access'),
  operational_risk_management(value: 'Operational Risk Management'),
  other(value: 'Other');

  const EnquiryReason({required this.value});

  final String value;

  static EnquiryReason fromString(String? reason) => switch (reason) {
        'myPI' => EnquiryReason.compliance,
        _ => EnquiryReason.other,
      };
}
