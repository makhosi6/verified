import 'package:dartz/dartz.dart';
import 'package:verify_sa/domain/models/generic_api_error.dart';
import 'package:verify_sa/domain/models/generic_response.dart';
import 'package:verify_sa/domain/models/help_request.dart';
import 'package:verify_sa/domain/models/help_ticket.dart';
import 'package:verify_sa/domain/models/promotion.dart';
import 'package:verify_sa/domain/models/resource_health_status_enum.dart';
import 'package:verify_sa/domain/models/transaction_history.dart';
import 'package:verify_sa/domain/models/user_profile.dart';
import 'package:verify_sa/domain/models/wallet.dart';

abstract class IStoreRepository {
  /// Get HEaLTH StaTUS
  Future<ResourceHealthStatus> getHealthStatus();

  /// GET
  Future<Either<Exception, GenericResponse>> requestHelp(HelpRequest help);
  Future<Either<Exception, UserProfile>> getUserProfile(
    String id,
  );
  Future<Either<Exception, TransactionHistory>> getUserTransaction(
    String id,
  );
  Future<Either<Exception, Promotion>> getUserPromotion(
    String id,
  );
  Future<Either<Exception, Wallet>> getUserWallet(
    String id,
  );
  Future<Either<Exception, HelpTicket>> getTicket(
    String id,
  );

  /// GET ALL
  Future<Either<Exception, dynamic>> getAllUserTransaction(
    String userId,
  );
  Future<Either<Exception, dynamic>> getAllUserPromotions(
    String userId,
  );

  Future<Either<Exception, dynamic>> getAllTickets(
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