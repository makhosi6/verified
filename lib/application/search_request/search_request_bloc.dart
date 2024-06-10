import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/domain/models/verifee_request.dart';
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
                hasError: false,
                error: null,
              ),
            );
            return;
          },
          selectJobsOrService: (e) {
            emit(
              state.copyWith(
                data: null,
                hasError: false,
                error: null,
                person: (state.person ?? SearchPerson()).copyWith(
                  selectedServices: e.serviceOrJob,
                ),
              ),
            );
            return;
          },
          validateAndSubmit: (e) async {
            ///
            emit(state.copyWith(isLoading: true));

            if (state.hasError == true || state.error != null) {
              emit(
                state.copyWith(
                  error: null,
                  hasError: false,
                ),
              );
            }

            if ((state.person?.idNumber == null) && (state.person?.phoneNumber == null)) {
              ///
              emit(
                state.copyWith(
                  error: AssertionError('No Phone number or Id Number'),
                  hasError: true,
                  data: null,
                  isLoading: false,
                ),
              );
            }

            final response = await _verifySaRepository.comprehensiveVerification(
              person: state.person,
              clientId: 'clientId',
            );

            response.fold((error) {
              print('ERROR:  ${error.toString()}');
              emit(
                state.copyWith(
                  error: AssertionError(error.toString()),
                  hasError: true,
                  data: null,
                  isLoading: false,
                ),
              );
            }, (data) {
              print('RESPONSE:  ${data.toJson()}');
              emit(
                state.copyWith(
                  hasError: false,
                  error: null,
                  data: data,
                  isLoading: false,
                ),
              );
            });

            return;
          }, createVerifieeDetails: (e) { 
            print(e.verifiee.toString());

            emit(state.copyWith(
              verifiee: e.verifiee
            ));
            return;
           },
        ));
  }

  final VerifySaRepository _verifySaRepository;
}
