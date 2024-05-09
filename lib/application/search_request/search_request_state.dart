part of 'search_request_bloc.dart';

@freezed
class SearchRequestState with _$SearchRequestState {
  const factory SearchRequestState({
    SearchPerson? person,
    Error? error,
   required bool hasError,
    Object? data,
   required bool isLoading
  }) = _SearchRequestState;

 factory SearchRequestState.initial() => const SearchRequestState(isLoading: false, hasError: false);
}
