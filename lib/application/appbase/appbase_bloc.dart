import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'appbase_state.dart';
part 'appbase_event.dart';
part 'appbase_bloc.freezed.dart';

class AppbaseBloc extends Bloc<AppbaseEvent, AppbaseState> {
  AppbaseBloc(this._appbaseRepository) : super(AppbaseState.initial()) {
    on<AppbaseEvent>((event, emit) => event.map(
          healthCheck: (_) {
            return null;
          },
          getAppInfo: (_) async {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();

            emit(state.copyWith(
              appName: packageInfo.appName,
              packageName: packageInfo.packageName,
              version: packageInfo.version,
              buildNumber: packageInfo.buildNumber,
            ));

            return null;
          },
        ));
  }

  final Object _appbaseRepository;
}
