part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    required ResourceHealthStatus resourceHealthStatus,

    ///
    required GenericApiError? getHelpError,
    required bool getHelpHasError,
    required bool getHelpDataLoading,
    required GenericResponse? getHelpData,

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
    required GenericApiError? uploadsError,
    required bool uploadsHasError,
    required bool uploadsDataLoading,
    required UploadResponse? uploadsData,
  }) = _StoreState;

  factory StoreState.initial() => const StoreState(
        resourceHealthStatus: ResourceHealthStatus.unknown,

        /// on screen using
        getHelpError: null,
        getHelpHasError: false,
        getHelpDataLoading: false,
        getHelpData: null,

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
        uploadsError: null,
        uploadsHasError: false,
        uploadsDataLoading: false,
        uploadsData: null,
      );
}
