enum EnquiryReason {
  security_enhancement(value: 'Security Enhancement'),
  compliance(value: 'Regulatory Compliance'),
  fraud(value: 'Fraud and Identity Theft Prevention'),
  spam_prevention(value: 'Spam and Fake Account Prevention'),
  user_safety(value: 'User Safety'),
  access_verification(value: 'Eligibility Verification for Access'),
  operational_risk(value: 'Operational Risk Management'),
  peer_to_peer_safety(value: 'Safety in Peer-to-Peer Platforms'),
  other(value: 'Other');

  const EnquiryReason({required this.value});

  final String value;

  static EnquiryReason fromString(String? reason) => switch (reason) {
        'Security Enhancement' => EnquiryReason.security_enhancement,
        'Regulatory Compliance' => EnquiryReason.compliance,
        'Fraud and Identity Theft Prevention' => EnquiryReason.fraud,
        'Spam and Fake Account Prevention' => EnquiryReason.spam_prevention,
        'User Safety' => EnquiryReason.user_safety,
        'Eligibility Verification for Access' => EnquiryReason.access_verification,
        'Operational Risk Management' => EnquiryReason.operational_risk,
        'Safety in Peer-to-Peer Platforms' => EnquiryReason.peer_to_peer_safety,
        _ => EnquiryReason.other,
      };
}