part of 'store_bloc.dart';

@freezed
class StoreEvent with _$StoreEvent {
  const factory StoreEvent.apiHealthCheck() = StoreApiHealthCheck;

  ///
  const factory StoreEvent.requestHelp(HelpRequest helpRequest) = RequestHelp;

  ///
  const factory StoreEvent.getUserProfile(
    String id,
  ) = GetUserProfile;
  const factory StoreEvent.createUserProfile(
    UserProfile user,
  ) = CreateUserProfile;
  const factory StoreEvent.updateUserProfile(
    UserProfile user,
  ) = UpdateUserProfile;
  const factory StoreEvent.deleteUserProfile(
    String id,
  ) = DeleteUserProfile;

  ///
  const factory StoreEvent.getTicket(String id) = GetTicket;
  const factory StoreEvent.getAllTickets(String userId) = GetAllTickets;
  const factory StoreEvent.createTicket(HelpTicket helpTicket) = CreateTicket;
  const factory StoreEvent.updateTicket(HelpTicket helpTicket) = UpdateTicket;
  const factory StoreEvent.deleteTicket(String id) = DeleteTicket;

  ///
  const factory StoreEvent.getHistory(String id) = GetHistory;
  const factory StoreEvent.getAllHistory(String userId) = GetAllHistory;
  const factory StoreEvent.createHistory(TransactionHistory ttransaction) = CreateHistory;
  const factory StoreEvent.updateHistory(TransactionHistory ttransaction) = UpdateHistory;
  const factory StoreEvent.deleteHistory(String id) = DeleteHistory;

  ///
  const factory StoreEvent.getPromotion(String id) = GetPromotion;
  const factory StoreEvent.getAllPromotions(String userId) = GetAllPromotions;
  const factory StoreEvent.createPromotion(Promotion promotion) = CreatePromotion;
  const factory StoreEvent.updatePromotion(Promotion promotion) = UpdatePromotion;
  const factory StoreEvent.deletePromotion(String id) = DeletePromotion;

  ///
  const factory StoreEvent.getWallet(String id) = GetWallet;
  const factory StoreEvent.createWallet(Wallet wallet) = CreateWallet;
  const factory StoreEvent.updateWallet(Wallet wallet) = UpdateWallet;
  const factory StoreEvent.deleteWallet(String id) = DeleteWallet;
}
