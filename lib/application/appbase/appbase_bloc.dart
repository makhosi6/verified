import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/models/device.dart';
import 'package:verified/presentation/utils/app_info.dart';
import 'package:verified/presentation/utils/device_info.dart';

part 'appbase_state.dart';
part 'appbase_event.dart';
part 'appbase_bloc.freezed.dart';

class AppbaseBloc extends Bloc<AppbaseEvent, AppbaseState> {
  AppbaseBloc(this._appBaseRepository) : super(AppbaseState.initial()) {
    on<AppbaseEvent>(
      (event, emit) => event.map(
        healthCheck: (_) {
          return null;
        },
        getAppInfo: (_) async {
          final app = await getVerifiedPackageInfo();
          emit(
            state.copyWith(

              appInfo: app,
            ),
          );

          return null;
        },
        getDevice: (_) async {
          final device = await getCurrentDevice();
          emit(
            state.copyWith(
              device: device,
            ),
          );

          return null;
        },
        getDeviceInfo: (_) async {
          final device = await getCurrentDeviceInfo();
          emit(
            state.copyWith(
              deviceInfo: device,
            ),
          );

          return null;
        },
      ),
    );
  }

  final Object _appBaseRepository;
}
