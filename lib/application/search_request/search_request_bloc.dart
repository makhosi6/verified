import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/models/enquiry_reason.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/infrastructure/verifysa/repository.dart';

part 'search_request_bloc.freezed.dart';
part 'search_request_event.dart';
part 'search_request_state.dart';

class SearchRequestBloc extends Bloc<SearchRequestEvent, SearchRequestState> {
  SearchRequestBloc(this._verifySaRepository) : super(SearchRequestState.initial()) {
    on<SearchRequestEvent>((event, emit) => event.map(
          createPersonalDetails: (e) {
            emit(
              state.copyWith(
                person: e.person,
                data: null,
              ),
            );
            return;
          },
          selectJobsOrService: (e) {
            emit(
              state.copyWith(
                data: null,
                person: (state.person ?? SearchPerson()).copyWith(
                  selectedServices: e.serviceOrJob,
                ),
              ),
            );
            return;
          },
          validateAndSubmit: (_) async {
            if ((state.person?.idNumber == null) && (state.person?.phoneNumber == null)) {
              ///
              emit(
                state.copyWith(
                  error: AssertionError('No Phone number or Id Number'),
                  hasError: true,
                  data: null,
                ),
              );
            }

            ///
       
              print('||==> ${state.person?.toJson()}');

              ///

              final response = await _verifySaRepository.getDhaIdPhoto(
                idNumber: 'idNumber',
                reason: EnquiryReason.compliance,
                clientId: 'clientId',
              );

              response.fold((error) {
                emit(
                  state.copyWith(
                    error: AssertionError(error.toString()),
                    hasError: true,
                    data: null,
                  ),
                );
              }, (data) {
                emit(
                  state.copyWith(
                    hasError: false,
                    error: null,
                    data: data,
                  ),
                );
              });
            
            return;
          },
        ));
  }

  final VerifySaRepository _verifySaRepository;
}
