part of 'appbase_bloc.dart';

@freezed
class AppbaseState with _$AppbaseState {
  const factory AppbaseState({
    Map<String, dynamic>? appInfo,
      Map<String, dynamic>? deviceInfo,
      Device? device,
  }) = _AppbaseState;

  factory AppbaseState.initial() => const AppbaseState();
}
