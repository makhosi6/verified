import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:verify_sa/services/dio.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  ///
  serviceLocator.registerSingleton<Dio>(
    VerifySaDioClientService.instance,
    instanceName: 'verifySaDio',
  );
}
