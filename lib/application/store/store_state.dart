part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required ResourceHealthStatus resourceHealthStatus,

    ///
    required Device? device,

    ///
    required GenericApiError? getHelpError,
    required bool getHelpHasError,
    required bool getHelpDataLoading,
    required GenericResponse? getHelpData,

    ///
    required CapturedCandidateDetails? capturedCandidateDetails,
    required bool isUploadingDocs,

    ///
    required CandidateRequest? candidate,
    required bool? invalidateVerificationLink,
    required SearchPerson? searchPerson,
    required GenericApiError? searchPersonError,
    required bool searchPersonHasError,
    required Object? searchPersonData,
    required bool searchPersonIsLoading,

    ///
    required UploadResponse? idBackImageUploadResponse,
    required GenericApiError? idBackImageUploadError,

    ///
    required UploadResponse? selfieUploadResponse,
    required GenericApiError? selfieUploadError,

    ///
    required UploadResponse? passportImageUploadResponse,
    required GenericApiError? passportImageUploadError,

    ///
    required GenericApiError? idFrontImageUploadError,
    required UploadResponse? idFrontImageUploadResponse,

    ///
    required GenericApiError? decodePassportDataError,
    required bool decodePassportHasError,
    required bool decodePassportDataLoading,
    required PassportResponseData? decodePassportData,

    ///
    required GenericApiError? ticketsError,
    required bool ticketsHasError,
    required bool ticketsDataLoading,
    required List<HelpTicket> ticketsData,

    ///
    required GenericApiError? userProfileError,
    required bool userProfileHasError,
    required bool userProfileDataLoading,
    required UserProfile? userProfileData,

    ///
    required GenericApiError? historyError,
    required bool historyHasError,
    required bool historyDataLoading,
    required List<TransactionHistory> historyData,

    ///
    required GenericApiError? promotionError,
    required bool promotionHasError,
    required bool promotionDataLoading,
    required List<Promotion> promotionData,

    ///
    required GenericApiError? walletError,
    required bool walletHasError,
    required bool walletDataLoading,
    required Wallet? walletData,

    ///
    required bool uploadsTooBig,
    required GenericApiError? uploadsError,
    required bool uploadsHasError,
    required bool uploadsDataLoading,
    required UploadResponse? uploadsData,

    required GenericApiError? permitsUploadsError,
    required bool permitsUploadsHasError,
    required bool permitsUploadsDataLoading,
    required List<UploadResponse>? permitsUploadsData,
    required PermitVisaUploadBean? permitsVisaData,

  }) = _StoreState;

  factory StoreState.initial() => const StoreState(
        resourceHealthStatus: ResourceHealthStatus.unknown,

        ///
        device: null,

        ///
        searchPerson: null,
        searchPersonError: null,
        searchPersonHasError: false,
        searchPersonData: null,
        searchPersonIsLoading: false,
        candidate: null,

        ///
        passportImageUploadError: null,
        passportImageUploadResponse: null,
        idBackImageUploadError: null,
        idBackImageUploadResponse: null,
        idFrontImageUploadError: null,
        idFrontImageUploadResponse: null,

        /// on screen using
        getHelpError: null,
        getHelpHasError: false,
        getHelpDataLoading: false,
        getHelpData: null,

        ///
        selfieUploadError: null,
        selfieUploadResponse: null,

        ///
        capturedCandidateDetails: null,
        invalidateVerificationLink: null,
        isUploadingDocs: false,

        ///
        decodePassportDataError: null,
        decodePassportHasError: false,
        decodePassportDataLoading: false,
        decodePassportData: null,

        ///
        ticketsError: null,
        ticketsHasError: false,
        ticketsDataLoading: false,
        ticketsData: [],

        /// on app start
        userProfileError: null,
        userProfileHasError: false,
        userProfileDataLoading: false,
        userProfileData: null,

        /// every screen using
        historyError: null,
        historyHasError: false,
        historyDataLoading: false,
        historyData: [],

        ///
        promotionError: null,
        promotionHasError: false,
        promotionDataLoading: false,
        promotionData: [],

        ///
        walletError: null,
        walletHasError: false,
        walletDataLoading: false,
        walletData: null,

        ///
        uploadsTooBig: false,
        uploadsError: null,
        uploadsHasError: false,
        uploadsDataLoading: false,
        uploadsData: null,
        
        permitsUploadsError: null,
        permitsUploadsHasError: false,
        permitsUploadsDataLoading: false,
        permitsUploadsData: null,
        permitsVisaData: null
      );
}
