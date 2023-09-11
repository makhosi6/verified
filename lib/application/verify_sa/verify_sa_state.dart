part of 'verify_sa_bloc.dart';

@freezed
class VerifySaState with _$VerifySaState {
  const factory VerifySaState({
    required ResourceHealthStatus resourceHealthStatus,

    ///
    required bool verifyIdDataLoading,
    required Either<Error, VerifyIdResponse>? verifyIdData,

    ///
    required bool contactTracingDataLoading,
    required Either<Error, ContactTracingResponse>? contactTracingData,

    ///
  }) = _VerifySaState;

  factory VerifySaState.initial() => const VerifySaState(
        resourceHealthStatus: ResourceHealthStatus.unknown,
        verifyIdDataLoading: false,
        verifyIdData: null,
        contactTracingDataLoading: false,
        contactTracingData: null,
      );
}
