part of 'appbase_bloc.dart';

@freezed
class AppbaseState with _$AppbaseState {
  const factory AppbaseState({
    String? appName,
    String? packageName,
    String? version,
    String? buildNumber,
    String? buildSignature,
  }) = _AppbaseState;

  factory AppbaseState.initial() => const AppbaseState(
        appName: 'Unknown',
        packageName: 'co.za.byteestudio.Verified',
        version: '0.0.0',
        buildNumber: '0',
        buildSignature: '#',
      );
}
