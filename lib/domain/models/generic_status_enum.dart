enum Status {
  success(value: 'done'),
  success_done(value: 'done'),
  success_pending(value: 'pending'),
  failed(value: 'failed'),
  pending(value: 'pending'),
  unknown(value: 'unknown');

  const Status({required this.value});

  final String value;
}
