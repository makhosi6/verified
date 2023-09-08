part of 'appbase_bloc.dart';

@freezed
class AppbaseState with _$AppbaseState {
  const factory AppbaseState.initial() = _Initial;
  const factory AppbaseState.loadInProgress() = _LoadInProgress;
}