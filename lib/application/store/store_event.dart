part of 'store_bloc.dart';

@freezed
class StoreEvent with _$StoreEvent {
  const factory StoreEvent.apiHealthCheck() = StoreApiHealthCheck;

  ///
  const factory StoreEvent.requestHelp(HelpRequest helpRequest) = RequestHelp;

  ///
  const factory StoreEvent.getUserProfile(String userId) = GetUserProfile;
  const factory StoreEvent.createUserProfile(UserProfile user) = CreateUserProfile;
  const factory StoreEvent.updateUserProfile(UserProfile user) = UpdateUserProfile;
  const factory StoreEvent.deleteUserProfile(String userId) = DeleteUserProfile;

  ///
  const factory StoreEvent.getTicket(String resourceId) = GetTicket;
  const factory StoreEvent.getAllTickets(String userId) = GetAllTickets;
  const factory StoreEvent.createTicket(HelpTicket helpTicket) = CreateTicket;
  const factory StoreEvent.updateTicket(HelpTicket helpTicket) = UpdateTicket;
  const factory StoreEvent.deleteTicket(String resourceId) = DeleteTicket;

  ///
  const factory StoreEvent.getHistory(String id) = GetHistory;
  const factory StoreEvent.getAllHistory(String userId) = GetAllHistory;
  const factory StoreEvent.createHistory(TransactionHistory transaction) = CreateHistory;
  const factory StoreEvent.updateHistory(TransactionHistory transaction) = UpdateHistory;
  const factory StoreEvent.deleteHistory(String id) = DeleteHistory;

  ///
  const factory StoreEvent.getPromotion(String resourceId) = GetPromotion;
  // const factory StoreEvent.getAllPromotions(String userId) = GetAllPromotions;
  const factory StoreEvent.createPromotion(Promotion promotion) = CreatePromotion;
  const factory StoreEvent.updatePromotion(Promotion promotion) = UpdatePromotion;
  const factory StoreEvent.deletePromotion(String resourceId) = DeletePromotion;

  ///
  const factory StoreEvent.getWallet(String resourceId) = GetWallet;
  const factory StoreEvent.createWallet(Wallet wallet) = CreateWallet;
  const factory StoreEvent.updateWallet(Wallet wallet) = UpdateWallet;
  const factory StoreEvent.deleteWallet(String resourceId) = DeleteWallet;
  //
  const factory StoreEvent.clearUser() = ClearUser;
  const factory StoreEvent.addUser(UserProfile? user) = AddUser;
}
