// ignore_for_file: unused_field

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/models/contact_tracing_response.dart';
import 'package:verified/domain/models/dha_image_response.dart';
import 'package:verified/domain/models/enquiry_reason.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/verify_id_response.dart';
import 'package:verified/infrastructure/verifysa/repository.dart';

part 'verify_sa_state.dart';
part 'verify_sa_event.dart';
part 'verify_sa_bloc.freezed.dart';

class VerifySaBloc extends Bloc<VerifySaEvent, VerifySaState> {
  VerifySaBloc(this._verifySaRepository) : super(VerifySaState.initial()) {
    on<VerifySaEvent>((event, emit) async => event.map(apiHealthCheck: (e) {
          return null;
        }, getDhaIdPhoto: (e) async {
          ///
          emit(state.copyWith(
            dhaImageError: null,
            dhaImageHasError: false,
            dhaImageDataLoading: true,
            dhaImageData: null,
          ));

          ///
          final response = await _verifySaRepository.getDhaIdPhoto(e.idNumber, e.reason);

          ///
          response.fold((e) {
            emit(state.copyWith(
              dhaImageError: GenericApiError(error: e.toString(), status: 'error'),
              dhaImageHasError: true,
              dhaImageDataLoading: false,
            ));
          }, (data) {
            ///
            emit(state.copyWith(
              dhaImageError: null,
              dhaImageHasError: false,
              dhaImageDataLoading: false,
              dhaImageData: data,
            ));
          });

          return null;
        }, verifyIdNumber: (e) async {
          ///
          emit(state.copyWith(
            verifyIdError: null,
            verifyIdHasError: false,
            verifyIdDataLoading: true,
            verifyIdData: null,
          ));

          ///
          final response = await _verifySaRepository.verifyIdNumber(e.idNumber, e.reason);

          ///
          response.fold((e) {
            emit(state.copyWith(
              verifyIdError: GenericApiError(error: e.toString(), status: 'error'),
              verifyIdHasError: true,
              verifyIdDataLoading: false,
            ));
          }, (data) {
            ///
            emit(state.copyWith(
              verifyIdError: null,
              verifyIdHasError: false,
              verifyIdDataLoading: false,
              verifyIdData: data,
            ));
          });
          return null;
        }, contactTracing: (e) async {
          emit(state.copyWith(
            contactTracingError: null,
            contactTracingHasError: false,
            contactTracingDataLoading: true,
            contactTracingData: null,
          ));

          final response = await _verifySaRepository.contactTracing(e.phoneNumber, e.reason);

          response.fold((e) {
            emit(state.copyWith(
              contactTracingError: GenericApiError(error: e.toString(), status: 'error'),
              contactTracingHasError: true,
              contactTracingDataLoading: false,
            ));
          }, (data) {
            emit(state.copyWith(
              contactTracingError: null,
              contactTracingHasError: false,
              contactTracingDataLoading: false,
              contactTracingData: data,
            ));
          });
          return null;
        }));
  }

  final VerifySaRepository _verifySaRepository;
}
