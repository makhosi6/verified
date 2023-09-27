import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verify_sa/domain/models/generic_api_error.dart';
import 'package:verify_sa/domain/models/generic_response.dart';
import 'package:verify_sa/domain/models/help_request.dart';
import 'package:verify_sa/domain/models/help_ticket.dart';
import 'package:verify_sa/domain/models/promotion.dart';
import 'package:verify_sa/domain/models/resource_health_status_enum.dart';
import 'package:verify_sa/domain/models/transaction_history.dart';
import 'package:verify_sa/domain/models/user_profile.dart';
import 'package:verify_sa/domain/models/wallet.dart';
import 'package:verify_sa/infrastructure/store/repository.dart';

part 'store_state.dart';
part 'store_event.dart';
part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(this._storeRepository) : super(StoreState.initial()) {
    on<StoreEvent>((event, emit) async => event.map(
          apiHealthCheck: (e) {
            return null;
          },

          ///
          requestHelp: (e) {
            return null;
          },

          ///
          getUserProfile: (e) async {
            emit(state.copyWith(
              userProfileError: null,
              userProfileHasError: false,
              userProfileDataLoading: true,
            ));

            final response = await _storeRepository.getUserProfile(e.id);

            response.fold((e) {
              emit(state.copyWith(
                  userProfileError: null,
                  userProfileHasError: false,
                  userProfileDataLoading: true,
                  userProfileData: null));
            }, (data) {
              emit(state.copyWith(
                  userProfileError: null,
                  userProfileHasError: false,
                  userProfileDataLoading: true,
                  userProfileData: [data]));
            });
            return null;
          },
          createUserProfile: (e) async {
            return null;
          },
          updateUserProfile: (e) {
            return null;
          },
          deleteUserProfile: (e) {
            return null;
          },

          ///
          getTicket: (e) {
            return null;
          },
          getAllTickets: (e) {
            return null;
          },
          createTicket: (e) {
            return null;
          },
          updateTicket: (e) {
            return null;
          },
          deleteTicket: (e) {
            return null;
          },

          ///
          getHistory: (e) {
            return null;
          },
          getAllHistory: (e) {
            return null;
          },
          createHistory: (e) {
            return null;
          },
          updateHistory: (e) {
            return null;
          },
          deleteHistory: (e) {
            return null;
          },

          ////
          getPromotion: (e) {
            return null;
          },
          // getAllPromotions: (e) {
          //   return null;
          // },
          createPromotion: (e) {
            return null;
          },
          updatePromotion: (e) {
            return null;
          },
          deletePromotion: (e) {
            return null;
          },

          ///
          getWallet: (e) {
            return null;
          },
          createWallet: (e) {
            return null;
          },
          updateWallet: (e) {
            return null;
          },
          deleteWallet: (e) {
            return null;
          },
        ));
  }
  final StoreRepository _storeRepository;
}


/**
 * 
           emit(state.copyWith());

            final response = await _storeRepository.getUserProfile(e.id);

            response.fold((e) {
                  emit(state.copyWith());
            }, (data) {
                  emit(state.copyWith());
            });
 * 
 */