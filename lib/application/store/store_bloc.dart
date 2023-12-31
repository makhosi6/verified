import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/generic_response.dart';
import 'package:verified/domain/models/help_request.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/promotion.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/wallet.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/store/repository.dart';

part 'store_state.dart';
part 'store_event.dart';
part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(this._storeRepository) : super(StoreState.initial()) {
    on<StoreEvent>((event, emit) async => event.map(
          apiHealthCheck: (e) async {
            emit(
              state.copyWith(
                resourceHealthStatus: await _storeRepository.getHealthStatus(),
              ),
            );

            return null;
          },

          ///
          requestHelp: (e) async {
            emit(
              state.copyWith(
                getHelpHasError: false,
                getHelpError: null,
                getHelpDataLoading: true,
              ),
            );

            final response = await _storeRepository.requestHelp(e.helpRequest);

            response.fold((error) {
              emit(
                state.copyWith(
                  getHelpHasError: true,
                  getHelpError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  getHelpDataLoading: false,
                ),
              );
            }, (data) {
              emit(state.copyWith(
                getHelpHasError: false,
                getHelpError: null,
                getHelpDataLoading: false,
                getHelpData: data,
              ));
            });
            return null;
          },

          ///
          getUserProfile: (e) async {
            if (e.userId.isEmpty) return;
            emit(state.copyWith(
              userProfileError: null,
              userProfileHasError: false,
              userProfileData: null,
              userProfileDataLoading: true,
            ));

            final response = await _storeRepository.getUserProfile(e.userId);
            response.fold((error) {
              emit(
                state.copyWith(
                  userProfileError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  userProfileHasError: false,
                  userProfileDataLoading: false,
                ),
              );
            }, (data) {
              ///
              emit(
                state.copyWith(
                  userProfileError: null,
                  userProfileHasError: false,
                  userProfileDataLoading: false,
                  userProfileData: data,
                ),
              );

              ///
              LocalUser.setUser(data);
            });
            return null;
          },
          createUserProfile: (e) async {
            emit(state.copyWith(
              userProfileError: null,
              userProfileHasError: false,
              userProfileDataLoading: true,
            ));

            final response = await _storeRepository.postUserProfile(e.user);
            response.fold((error) {
              emit(
                state.copyWith(
                  userProfileError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  userProfileHasError: true,
                  userProfileDataLoading: false,
                  userProfileData: null,
                ),
              );
            }, (data) {
              emit(
                state.copyWith(
                  userProfileError: null,
                  userProfileHasError: false,
                  userProfileDataLoading: false,
                  userProfileData: data,
                ),
              );

              // add(const StoreEvent.getAllHistory('logged-in-user'));
              // add(const StoreEvent.getWallet('logged-in-user-wallet'));
            });

            return null;
          },
          updateUserProfile: (e) async {
            emit(
              state.copyWith(
                userProfileError: null,
                userProfileHasError: false,
                userProfileDataLoading: true,
              ),
            );

            final response = await _storeRepository.putUserProfile(e.user);

            response.fold((error) {
              emit(
                state.copyWith(
                  userProfileError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  userProfileHasError: true,
                  userProfileDataLoading: false,
                ),
              );
            }, (data) {
              emit(
                state.copyWith(
                  userProfileError: null,
                  userProfileHasError: false,
                  userProfileDataLoading: false,
                  userProfileData: data,
                ),
              );
            });

            return null;
          },
          deleteUserProfile: (e) async {
            if (e.userId.isEmpty) return;
            emit(state.copyWith(
              userProfileError: null,
              userProfileHasError: false,
              userProfileDataLoading: true,
            ));

            final response = await _storeRepository.deleteUserProfile(e.userId);

            response.fold((error) {
              emit(
                state.copyWith(
                  userProfileError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  userProfileHasError: true,
                  userProfileDataLoading: false,
                  userProfileData: null,
                ),
              );
            }, (data) {
              emit(StoreState.initial());
            });

            return null;
          },

          ///
          getTicket: (e) {
            throw UnimplementedError();
          },
          getAllTickets: (e) async {
            if (e.userId.isEmpty) return;
            emit(state.copyWith(
              ticketsError: null,
              ticketsHasError: false,
              ticketsDataLoading: true,
            ));

            final response = await _storeRepository.getAllTickets(e.userId);

            response.fold((error) {
              emit(state.copyWith(
                ticketsError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                ticketsHasError: true,
                ticketsDataLoading: false,
              ));
            }, (data) {
              emit(state.copyWith(
                ticketsError: null,
                ticketsHasError: false,
                ticketsDataLoading: false,
                ticketsData: List<HelpTicket>.from(data),
              ));
            });

            return null;
          },
          createTicket: (e) async {
            emit(
              state.copyWith(
                ticketsError: null,
                ticketsHasError: false,
                ticketsDataLoading: true,
              ),
            );

            final response = await _storeRepository.postHelpTicket(e.helpTicket);

            response.fold((error) {
              emit(
                state.copyWith(
                  ticketsError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  ticketsHasError: true,
                  ticketsDataLoading: false,
                ),
              );
            }, (data) {
              emit(
                state.copyWith(
                    ticketsError: null,
                    ticketsHasError: false,
                    ticketsDataLoading: false,
                    ticketsData: state.ticketsData..add(data)),
              );
            });

            return null;
          },
          updateTicket: (e) {
            throw UnimplementedError();
          },
          deleteTicket: (e) async {
            if (e.resourceId.isEmpty) return;
            emit(state.copyWith(
              ticketsError: null,
              ticketsHasError: false,
              ticketsDataLoading: true,
            ));

            final response = await _storeRepository.deleteHelpTicket(e.resourceId);

            response.fold((error) {
              emit(
                state.copyWith(
                  ticketsError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  ticketsHasError: true,
                  ticketsDataLoading: false,
                ),
              );
            }, (data) {
              emit(
                state.copyWith(
                  ticketsError: null,
                  ticketsHasError: false,
                  ticketsDataLoading: false,
                  ticketsData: state.ticketsData
                    ..removeWhere(
                      (item) => e.resourceId == item.id.toString(),
                    ),
                ),
              );
            });
            return null;
          },

          ///
          getHistory: (e) {
            throw UnimplementedError();
          },
          getAllHistory: (e) async {
            if (e.userId.isEmpty) return;
            emit(state.copyWith(
              historyError: null,
              historyHasError: false,
              historyDataLoading: true,
            ));

            final response = await _storeRepository.getAllUserTransaction(e.userId);

            response.fold((error) {
              emit(state.copyWith(
                historyError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                historyHasError: true,
                historyDataLoading: false,
              ));
            }, (data) {
              emit(state.copyWith(
                historyError: null,
                historyHasError: false,
                historyDataLoading: false,
                historyData: data,
              ));
            });
            return null;
          },
          createHistory: (e) async {
            emit(state.copyWith(
              historyError: null,
              historyHasError: false,
              historyDataLoading: true,
            ));

            final response = await _storeRepository.postUserTransaction(e.transaction);

            response.fold((error) {
              emit(state.copyWith(
                historyError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                historyHasError: true,
                historyDataLoading: false,
              ));
            }, (data) {
              emit(state.copyWith(
                historyError: null,
                historyHasError: false,
                historyDataLoading: false,
                historyData: state.historyData..add(data),
              ));
            });
            return null;
          },
          updateHistory: (e) {
            throw UnimplementedError();
          },
          deleteHistory: (e) async {
            emit(state.copyWith(
              historyError: null,
              historyHasError: false,
              historyDataLoading: true,
            ));

            final response = await _storeRepository.deleteUserTransaction(e.id);

            response.fold((error) {
              emit(state.copyWith(
                historyError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                historyHasError: true,
                historyDataLoading: false,
              ));
            }, (data) {
              emit(
                state.copyWith(
                  historyError: null,
                  historyHasError: false,
                  historyDataLoading: false,
                  ticketsData: state.ticketsData
                    ..removeWhere(
                      (item) => e.id == item.id.toString(),
                    ),
                ),
              );
            });
            return null;
          },

          ////
          getPromotion: (e) async {
            emit(state.copyWith(
              promotionError: null,
              promotionHasError: false,
              promotionDataLoading: true,
            ));

            final response = await _storeRepository.getPromotion(e.resourceId);

            response.fold((error) {
              emit(state.copyWith(
                promotionError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                promotionHasError: true,
                promotionDataLoading: false,
              ));
            }, (data) {
              emit(state.copyWith(
                promotionError: null,
                promotionHasError: false,
                promotionDataLoading: false,
                promotionData: state.promotionData
                  ..retainWhere((item) => item.id == data.id)
                  ..add(data),
              ));
            });
            return null;
          },
          // getAllPromotions: (e) {
          //   return null;
          // },
          createPromotion: (e) {
            throw UnimplementedError();
          },
          updatePromotion: (e) {
            throw UnimplementedError();
          },
          deletePromotion: (e) {
            throw UnimplementedError();
          },

          ///
          getWallet: (e) async {
            if (e.resourceId.isEmpty) return;
            emit(
              state.copyWith(
                walletError: null,
                walletHasError: false,
                walletDataLoading: true,
              ),
            );

            final response = await _storeRepository.getUserWallet(e.resourceId);

            response.fold((error) {
              emit(state.copyWith(
                walletError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                walletHasError: true,
                walletDataLoading: false,
              ));
            }, (data) {
              emit(state.copyWith(
                walletError: null,
                walletHasError: false,
                walletDataLoading: false,
                walletData: data,
              ));
            });
            return null;
          },
          createWallet: (e) {
            throw UnimplementedError();
          },
          updateWallet: (e) async {
            emit(state.copyWith(
              walletError: null,
              walletHasError: false,
              walletDataLoading: true,
            ));

            final response = await _storeRepository.putUserWallet(e.wallet);

            response.fold((error) {
              emit(state.copyWith(
                walletError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                walletHasError: true,
                walletDataLoading: false,
              ));
            }, (data) {
              emit(state.copyWith(
                walletError: null,
                walletHasError: false,
                walletDataLoading: false,
                walletData: data,
              ));
            });
            return null;
          },
          deleteWallet: (e) async {
            if (e.resourceId.isEmpty) return;
            emit(state.copyWith(
              walletError: null,
              walletHasError: false,
              walletDataLoading: true,
            ));

            final response = await _storeRepository.deleteUserWallet(e.resourceId);

            response.fold((error) {
              emit(
                state.copyWith(
                  walletError: GenericApiError(
                    error: error.toString(),
                    status: 'error',
                  ),
                  walletHasError: true,
                  walletDataLoading: false,
                ),
              );
            }, (data) {
              emit(
                state.copyWith(
                  walletError: null,
                  walletHasError: false,
                  walletDataLoading: false,
                  walletData: null,
                ),
              );
            });
            return null;
          },
          clearUser: (e) {
            emit(StoreState.initial());

            return null;
          },
          addUser: (e) {
            if (e.user == null) return;
            emit(state.copyWith(
              userProfileData: e.user,
            ));
            return null;
          },
        ));
  }
  final StoreRepository _storeRepository;
}
