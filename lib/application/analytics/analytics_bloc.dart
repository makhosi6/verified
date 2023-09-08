import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_state.dart';
part 'analytics_event.dart';
part 'analytics_bloc.freezed.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc(this._analyticsProviderRepository)
      : super(const AnalyticsState.initial()) {
    on((event, emit) => {});
  }

  final Object _analyticsProviderRepository;
}
