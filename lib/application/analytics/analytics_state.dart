part of 'analytics_bloc.dart';

@freezed
class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState.initial() = _Initial;
  const factory AnalyticsState.loadInProgress() = _LoadInProgress;
}