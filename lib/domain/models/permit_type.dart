enum PermitType {
  work_visa('Work Visa'),
  business_visa('Business Visa'),
  study_visa('Study Visa'),
  relative_visa('Relative Visa'),
  special_visa('Special Visa'),
  retirement_visa('Retirement Visa'),
  visitor_visa('Visitor Visa'),
  asylum_seeker_visa('Asylum Seeker Visa'),
  other('Other');

  const PermitType(this.value);
  final String value;

  @override
  String toString() => value;

  PermitType _toPermitType(String type) => switch (type.replaceAll(' ', '_').toLowerCase()) {
        'work_visa' => PermitType.work_visa,
        'business_visa' => PermitType.business_visa,
        'study_visa' => PermitType.study_visa,
        'relative_visa' => PermitType.relative_visa,
        'special_visa' => PermitType.special_visa,
        'retirement_visa' => PermitType.retirement_visa,
        'visitor_visa' => PermitType.visitor_visa,
        'asylum_seeker_visa' => PermitType.asylum_seeker_visa,
        _ => PermitType.other
      };

  PermitType fromJson(String type) => _toPermitType(type);

  PermitType fromString(String type) => _toPermitType(type);
}