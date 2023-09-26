part of 'verify_sa_bloc.dart';

@freezed
class VerifySaState with _$VerifySaState {
  const factory VerifySaState({
    required ResourceHealthStatus resourceHealthStatus,

    ///
    required GenericApiError? dhaImageError,
    required bool dhaImageHasError,
    required bool dhaImageDataLoading,
    required DhaImageResponse? dhaImageData,

    ///
    required GenericApiError? verifyIdError,
    required bool verifyIdHasError,
    required bool verifyIdDataLoading,
    required VerifyIdResponse? verifyIdData,

    ///
    required GenericApiError? contactTracingError,
    required bool contactTracingHasError,
    required bool contactTracingDataLoading,
    required ContactTracingResponse? contactTracingData,

    ///
  }) = _VerifySaState;

  factory VerifySaState.initial() => const VerifySaState(
        resourceHealthStatus: ResourceHealthStatus.unknown,
        contactTracingError: null,
        contactTracingHasError: false,
        verifyIdDataLoading: false,
        verifyIdData: null,
        contactTracingDataLoading: false,
        contactTracingData: null,
        verifyIdError: null,
        verifyIdHasError: false,
        dhaImageError: null,
        dhaImageHasError: false,
        dhaImageDataLoading: false,
        dhaImageData: null,
      );
}
