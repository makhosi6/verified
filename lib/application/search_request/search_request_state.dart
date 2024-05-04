part of 'search_request_bloc.dart';

@freezed
class SearchRequestState with _$SearchRequestState {
  const factory SearchRequestState({
    SearchPerson? person,
    Error? error,
    bool? hasError,
    Object? data
  }) = _SearchRequestState;

 factory SearchRequestState.initial() => const SearchRequestState();
}
