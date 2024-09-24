import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:verified/domain/models/communication_channels.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/generic_response.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/passport_response_data.dart';
import 'package:verified/domain/models/promotion.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/domain/models/upload_response.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/verification_request.dart';
import 'package:verified/domain/models/wallet.dart';

abstract class IStoreRepository {
  /// Get HEaLTH StaTUS
  Future<Either<GenericApiError, GenericResponse>> getHealthStatus();

  ///
  void setUserAndVariables({required String phone, required String user, required String env});

  ///
  Future<Either<Exception, VerifyComprehensiveResponse>> comprehensiveVerification(
      {required SearchPerson? person, required String clientId});

  ///
  Future<UploadResponse> uploadFiles(List<MultipartFile> uploads);

  ///
  Future<GenericResponse?> willSendNotificationAfterVerification(CommsChannels data);

  ///
  Future<Either<GenericApiError, GenericResponse>> makeIdVerificationRequest(VerificationRequest data);

  ///
  Future<Either<GenericApiError, GenericResponse>> makePassportVerificationRequest(VerificationRequest data);

  ///
  Future<Either<GenericApiError, PassportResponseData>> decodePassportData(FormData data);

  /// GET
  Future<Either<GenericApiError, GenericResponse>> requestHelp(HelpTicket help);
  Future<Either<GenericApiError, UserProfile>> getUserProfile(
    String userId,
  );
  Future<Either<GenericApiError, TransactionHistory>> getUserTransaction(
    String resourceId,
  );
  Future<Either<GenericApiError, Promotion>> getPromotion(
    String resourceId,
  );
  Future<Either<GenericApiError, Wallet>> getUserWallet(
    String resourceId,
  );
  Future<Either<GenericApiError, HelpTicket>> getTicket(
    String resourceId,
  );

  /// GET ALL
  Future<Either<GenericApiError, dynamic>> getAllUserTransaction(
    String userId,
  );
  // Future<Either<GenericApiError, dynamic>> getAllUserPromotions(
  //   String userId,
  // );

  Future<Either<GenericApiError, dynamic>> getAllTickets(
    String userId,
  );

  /// PUT
  Future<Either<GenericApiError, UserProfile>> putUserProfile(
    UserProfile user,
  );
  Future<Either<GenericApiError, TransactionHistory>> putUserTransaction(TransactionHistory transaction);
  Future<Either<GenericApiError, Promotion>> putUserPromotions(
    Promotion promotion,
  );
  Future<Either<GenericApiError, Wallet>> putUserWallet(
    Wallet wallet,
  );
  Future<Either<GenericApiError, HelpTicket>> putHelpTicket(
    HelpTicket helpTicket,
  );

  /// POST
  Future<Either<GenericApiError, UserProfile>> postUserProfile(
    UserProfile user,
  );
  Future<Either<GenericApiError, GenericResponse>> postDeviceData(
    Map<String, dynamic> device,
  );
  Future<Either<GenericApiError, TransactionHistory>> postUserTransaction(TransactionHistory transaction);
  Future<Either<GenericApiError, Promotion>> postUserPromotions(
    Promotion promotion,
  );
  Future<Either<GenericApiError, Wallet>> postUserWallet(
    Wallet wallet,
  );
  Future<Either<GenericApiError, HelpTicket>> postHelpTicket(
    HelpTicket helpTicket,
  );

  /// DELETE
  Future<Either<GenericApiError, GenericResponse>> deleteUserProfile(
    String id,
  );
  Future<Either<GenericApiError, GenericResponse>> deleteUserTransaction(String id);
  Future<Either<GenericApiError, GenericResponse>> deleteUserPromotions(
    String id,
  );
  Future<Either<GenericApiError, GenericResponse>> deleteUserWallet(
    String id,
  );
  Future<Either<GenericApiError, GenericResponse>> deleteHelpTicket(
    String id,
  );
}
