class CommsChannels {
  final bool sms;
  final bool email;
  final String instanceId;

  CommsChannels({required this.sms, required this.email, required this.instanceId,});

 Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sms'] = sms;
    map['email'] = email;
    map['instanceId'] = instanceId;
    return map;
  }
}
