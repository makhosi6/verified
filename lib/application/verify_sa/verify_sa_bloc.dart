// ignore_for_file: unused_field

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verify_sa/domain/models/contact_tracing_response.dart';
import 'package:verify_sa/domain/models/resource_health_status.dart';
import 'package:verify_sa/domain/models/verify_Id_response.dart';

part 'verify_sa_state.dart';
part 'verify_sa_event.dart';
part 'verify_sa_bloc.freezed.dart';

class VerifySaBloc extends Bloc<VerifySaEvent, VerifySaState> {
  VerifySaBloc(this._verifySaRepository) : super(VerifySaState.initial()) {
    on<VerifySaEvent>((event, emit) async => event.map(apiHealthCheck: (e) {
          return null;
        }, getDhaIdPhoto: (e) {
          return null;
        }, verifyIdNumber: (e) {
          return null;
        }, contactTracing: (e) {
          return null;
        }));
  }

  final Object _verifySaRepository;
}
