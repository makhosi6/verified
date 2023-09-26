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
    on((event, emit) => {});
  }
  final StoreRepository _storeRepository;
}
