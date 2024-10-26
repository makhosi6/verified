import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/models/captured_candidate_details.dart';
import 'package:verified/domain/models/device.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/generic_response.dart';
import 'package:verified/domain/models/generic_status_enum.dart';
import 'package:verified/domain/models/passport_response_data.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/permit_upload_data.dart';
import 'package:verified/domain/models/promotion.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/domain/models/upload_response.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/candidate_request.dart';
import 'package:verified/domain/models/verification_request.dart';
import 'package:verified/domain/models/wallet.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/store/repository.dart';
import 'package:verified/presentation/utils/device_info.dart';
import 'package:verified/domain/models/communication_channels.dart';

part 'store_state.dart';
part 'store_event.dart';
part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc(this._storeRepository) : super(StoreState.initial()) {
    /// add stored user on boot
    Future.microtask(() async {
      var device = await getCurrentDevice();
      var user = await LocalUser.getUser();

      ///
      _storeRepository.setUserAndVariables(
        phone: device?.uuid ?? '',
        user: user?.id ?? '',
        env: user?.env ?? '',
      );

      ///
      // add(StoreEvent.addUser(await LocalUser.getUser()));
    });

    on<StoreEvent>(
      (event, emit) async => event.map(
        apiHealthCheck: (e) async {
          final response = await _storeRepository.getHealthStatus();

          response.fold((error) {
            emit(
              state.copyWith(
                resourceHealthStatus: ResourceHealthStatus.bad,
              ),
            );
          }, (data) {
            emit(state.copyWith(
              resourceHealthStatus: ResourceHealthStatus.good,
            ));
          });
          return null;
        },

        ///
        uploadSelfieImage: (e) async {
          emit(
            state.copyWith(
              isUploadingDocs: true,
            ),
          );
          final data = await _storeRepository.uploadFiles([e.file]);

          emit(
            state.copyWith(
              isUploadingDocs: false,
              selfieUploadError: null,
              selfieUploadResponse: data,
            ),
          );
          return null;
        },

        ///
        uploadIdImages: (e) async {
          emit(
            state.copyWith(
              isUploadingDocs: true,
            ),
          );
          final data = await _storeRepository.uploadFiles(e.files);

          emit(
            state.copyWith(
              isUploadingDocs: false,
              idBackImageUploadError: null,
              idBackImageUploadResponse: data,
              idFrontImageUploadError: null,
              idFrontImageUploadResponse: data,
            ),
          );
          return null;
        },
        validateVerificationLink: (e) async {
          emit(state.copyWith(invalidateVerificationLink: false));

          final data = await _storeRepository.getVerificationJob(jobUuid: e.jobUuid);

          data.fold((error) {
            emit(state.copyWith(invalidateVerificationLink: true));
          }, (data) {
            emit(state.copyWith(invalidateVerificationLink: data.id != e.jobUuid));
          });

          return null;
        },
        permitUploadDataEvnt: (e) async {
          verifiedLogger('${e.data.toJson()}');
          emit(state.copyWith(permitsVisaData: e.data));
          return null;
        },

        ///
        permitDocsUpload: (e) async {
          emit(
            state.copyWith(
              isUploadingDocs: true,
            ),
          );
          final data = await _storeRepository.uploadFiles(e.files);

          emit(
            state.copyWith(
              isUploadingDocs: false,
              permitsUploadsError: null,
              permitsUploadsData: [data],
            ),
          );
          return null;
        },

        ///
        uploadPassportImage: (e) async {
          emit(
            state.copyWith(
              isUploadingDocs: true,
            ),
          );
          var data = await _storeRepository.uploadFiles([e.file]);

          if (data.message == 'No file uploaded') await _uploadRetry(data, [e.file], (update) => data = update);

          emit(
            state.copyWith(
              isUploadingDocs: false,
              passportImageUploadError: null,
              passportImageUploadResponse: data,
            ),
          );
          return null;
        },

        ///
        addCandidate: (e) async {
          emit(
            state.copyWith(
              capturedCandidateDetails: e.data,
            ),
          );
          return null;
        },

        ///
        makeIdVerificationRequest: (e) async {
          final response = await _storeRepository.makeIdVerificationRequest(
            VerificationRequest(
              candidateRequest: state.candidate,
              capturedCandidateDetails: state.capturedCandidateDetails,
              backUploadedDocFiles: state.idBackImageUploadResponse,
              frontUploadedDocFiles: state.idFrontImageUploadResponse,
              uploadedSelfieImg: state.selfieUploadResponse,
            ),
          );
          //clear data
          return null;
        },
        makePassportVerificationRequest: (e) async {
          final response = await _storeRepository.makePassportVerificationRequest(
            VerificationRequest(
              candidateRequest: state.candidate,
              capturedCandidateDetails: state.capturedCandidateDetails,
              frontUploadedDocFiles: state.passportImageUploadResponse,
              permitUploadData: state.permitsVisaData,
              uploadedSelfieImg: state.selfieUploadResponse,
            ),
          );
//clear data
          return null;
        },

        ///
        decodePassportData: (e) async {
          emit(
            state.copyWith(
              decodePassportData: null,
              decodePassportDataLoading: true,
              decodePassportHasError: false,
              decodePassportDataError: null,
            ),
          );

          final response = await _storeRepository.decodePassportData(e.data);

          response.fold((error) {
            emit(
              state.copyWith(
                decodePassportHasError: true,
                decodePassportDataError: error,
                decodePassportData: null,
                decodePassportDataLoading: false,
              ),
            );
          }, (res) {
            emit(
              state.copyWith(
                decodePassportHasError: false,
                decodePassportDataError: null,
                decodePassportData: res,
                decodePassportDataLoading: false,
                capturedCandidateDetails: CapturedCandidateDetails.fromPassportString(
                  res.data ?? [],
                ),
              ),
            );
          });
          return null;
        },

        ///
        createCandidateDetails: (e) {
          verifiedLogger(e.candidate.toString());

          emit(state.copyWith(candidate: e.candidate));
          return;
        },

        ///
        requestHelp: (e) async {
          emit(
            state.copyWith(
              getHelpHasError: false,
              getHelpError: null,
              getHelpDataLoading: true,
            ),
          );

          final response = await _storeRepository.requestHelp(e.helpRequest);

          response.fold((error) {
            emit(
              state.copyWith(
                getHelpHasError: true,
                getHelpError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                getHelpDataLoading: false,
              ),
            );
          }, (data) {
            emit(state.copyWith(
              getHelpHasError: false,
              getHelpError: null,
              getHelpDataLoading: false,
              getHelpData: data,
            ));
          });
          return null;
        },

        ///
        getUserProfile: (e) async {
          if (e.userId.isEmpty) return;

          /// it okay to get user profile multiple times
          // if (state.userProfileData != null) return;

          emit(state.copyWith(
            userProfileError: null,
            userProfileHasError: false,
            // userProfileData: null,
            userProfileDataLoading: true,
          ));

          final response = await _storeRepository.getUserProfile(e.userId);
          response.fold((error) {
            emit(
              state.copyWith(
                userProfileError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                userProfileHasError: false,
                userProfileDataLoading: false,
              ),
            );
          }, (data) {
            ///
            emit(
              state.copyWith(
                userProfileError: null,
                userProfileHasError: false,
                userProfileDataLoading: false,
                userProfileData: data,
              ),
            );

            /// get history if is empty
            if (state.historyData.isEmpty && state.historyDataLoading == false) {
              add(StoreEvent.getAllHistory(data.profileId ?? ''));
            }

            /// get wallet if is empty
            if (state.walletData == null && state.walletDataLoading == false) {
              add(StoreEvent.getWallet(data.walletId ?? ''));
            }

            /// update local storage
            LocalUser.setUser(data);
          });
          return null;
        },
        createUserProfile: (e) async {
          emit(
            state.copyWith(
              userProfileError: null,
              userProfileHasError: false,
              userProfileDataLoading: true,
            ),
          );

          final response = await _storeRepository.postUserProfile(e.user);
          response.fold((error) {
            emit(
              state.copyWith(
                userProfileError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                userProfileHasError: true,
                userProfileDataLoading: false,
                // userProfileData: null,
              ),
            );
          }, (data) {
            emit(
              state.copyWith(
                userProfileError: null,
                userProfileHasError: false,
                userProfileDataLoading: false,
                userProfileData: data,
              ),
            );

            add(StoreEvent.getAllHistory(data.profileId ?? data.id ?? ''));
            if (data.walletId == null) add(StoreEvent.getWallet(data.walletId ?? ''));
            add(const StoreEvent.addDeviceData());
            LocalUser.setUser(data);

            ///
            _storeRepository.setUserAndVariables(
              phone: state.device?.name ?? '',
              user: data.id ?? '',
              env: data.env ?? '',
            );

            ///
            verifiedLogger("DO WE HAVE A WALLET ID:  ${data.walletId ?? 'NO_NO'}, USER_ID: ${data.profileId}");
          });

          return null;
        },
        updateUserProfile: (e) async {
          if (state.resourceHealthStatus == ResourceHealthStatus.bad) add(const StoreEvent.apiHealthCheck());
          if (state.resourceHealthStatus == ResourceHealthStatus.bad) return;
          if (state.userProfileData == e.user) return;

          emit(
            state.copyWith(
              userProfileError: null,
              userProfileHasError: false,
              userProfileDataLoading: true,
              userProfileData: e.user,
            ),
          );

          final response = await _storeRepository.putUserProfile(e.user);

          response.fold((error) {
            emit(
              state.copyWith(
                userProfileError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                userProfileHasError: true,
                userProfileDataLoading: false,
              ),
            );
          }, (data) async {
            emit(
              state.copyWith(
                userProfileError: null,
                userProfileHasError: false,
                userProfileDataLoading: false,
                userProfileData: data,
              ),
            );
            getCurrentDevice().then((device) {
              ///
              _storeRepository.setUserAndVariables(
                phone: device?.name ?? '',
                user: data.id ?? '',
                env: data.env ?? '',
              );
            });
            LocalUser.setUser(data);
          });

          return null;
        },
        deleteUserProfile: (e) async {
          if (e.userId.isEmpty) return;
          emit(state.copyWith(
            userProfileError: null,
            userProfileHasError: false,
            userProfileDataLoading: true,
          ));

          final response = await _storeRepository.deleteUserProfile(e.userId);

          response.fold((error) {
            emit(
              state.copyWith(
                userProfileError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                userProfileHasError: true,
                userProfileDataLoading: false,
                // userProfileData: null,
              ),
            );
          }, (data) {
            emit(StoreState.initial());
          });

          return null;
        },

        ///
        getTicket: (e) {
          throw UnimplementedError();
        },
        getAllTickets: (e) async {
          if (e.userId.isEmpty) return;
          // get only is local state is empty
          if (state.ticketsData.isNotEmpty || state.ticketsDataLoading == true) return;

          emit(state.copyWith(
            ticketsError: null,
            ticketsHasError: false,
            ticketsDataLoading: true,
          ));

          final response = await _storeRepository.getAllTickets(e.userId);

          response.fold((error) {
            emit(state.copyWith(
              ticketsError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              ticketsHasError: true,
              ticketsDataLoading: false,
            ));
          }, (data) {
            emit(state.copyWith(
              ticketsError: null,
              ticketsHasError: false,
              ticketsDataLoading: false,
              ticketsData: List<HelpTicket>.from(data),
            ));
          });

          return null;
        },
        createTicket: (e) async {
          emit(
            state.copyWith(
              ticketsError: null,
              ticketsHasError: false,
              ticketsDataLoading: true,
            ),
          );

          final response = await _storeRepository.postHelpTicket(e.helpTicket);

          response.fold((error) {
            emit(
              state.copyWith(
                ticketsError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                ticketsHasError: true,
                ticketsDataLoading: false,
              ),
            );
          }, (data) {
            emit(
              state.copyWith(
                  ticketsError: null,
                  ticketsHasError: false,
                  ticketsDataLoading: false,
                  ticketsData: [...state.ticketsData, data]),
            );
          });

          return null;
        },
        updateTicket: (e) {
          throw UnimplementedError();
        },
        deleteTicket: (e) async {
          if (e.resourceId.isEmpty) return;
          emit(state.copyWith(
            ticketsError: null,
            ticketsHasError: false,
            ticketsDataLoading: true,
          ));

          final response = await _storeRepository.deleteHelpTicket(e.resourceId);

          response.fold((error) {
            emit(
              state.copyWith(
                ticketsError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                ticketsHasError: true,
                ticketsDataLoading: false,
              ),
            );
          }, (data) {
            emit(
              state.copyWith(
                ticketsError: null,
                ticketsHasError: false,
                ticketsDataLoading: false,
                ticketsData: state.ticketsData
                  ..removeWhere(
                    (item) => e.resourceId == item.id.toString(),
                  ),
              ),
            );
          });
          return null;
        },

        ///
        getHistory: (e) {
          throw UnimplementedError();
        },
        getAllHistory: (e) async {
          if (e.userId.isEmpty) return;
          // get only is local state is empty
          if (state.historyData.isNotEmpty || state.historyDataLoading == true) return;

          emit(state.copyWith(
            historyError: null,
            historyHasError: false,
            historyDataLoading: true,
          ));

          final response = await _storeRepository.getAllUserTransaction(e.userId);

          response.fold((error) {
            emit(state.copyWith(
              historyError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              historyHasError: true,
              historyDataLoading: false,
            ));
          }, (data) {
            emit(state.copyWith(
              historyError: null,
              historyHasError: false,
              historyDataLoading: false,
              historyData: data,
            ));
          });
          return null;
        },
        createHistory: (e) async {
          emit(state.copyWith(
            historyError: null,
            historyHasError: false,
            // historyDataLoading: true,
          ));

          final response = await _storeRepository.postUserTransaction(e.transaction);

          response.fold((error) {
            emit(state.copyWith(
              historyError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              historyHasError: true,
              // historyDataLoading: false,
            ));
          }, (data) {
            emit(
              state.copyWith(
                historyError: null,
                historyHasError: false,
                // historyDataLoading: false,
                historyData: [...state.historyData, data],
              ),
            );
          });
          return null;
        },
        updateHistory: (e) {
          throw UnimplementedError();
        },
        deleteHistory: (e) async {
          emit(state.copyWith(
            historyError: null,
            historyHasError: false,
            historyDataLoading: true,
          ));

          final response = await _storeRepository.deleteUserTransaction(e.id);

          response.fold((error) {
            emit(state.copyWith(
              historyError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              historyHasError: true,
              historyDataLoading: false,
            ));
          }, (data) {
            emit(
              state.copyWith(
                historyError: null,
                historyHasError: false,
                historyDataLoading: false,
                ticketsData: state.ticketsData
                  ..removeWhere(
                    (item) => e.id == item.id.toString(),
                  ),
              ),
            );
          });
          return null;
        },

        ////
        getPromotion: (e) async {
          emit(state.copyWith(
            promotionError: null,
            promotionHasError: false,
            promotionDataLoading: true,
          ));

          final response = await _storeRepository.getPromotion(e.resourceId);

          response.fold((error) {
            emit(state.copyWith(
              promotionError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              promotionHasError: true,
              promotionDataLoading: false,
            ));
          }, (data) {
            emit(state.copyWith(
              promotionError: null,
              promotionHasError: false,
              promotionDataLoading: false,
              promotionData: state.promotionData
                ..retainWhere((item) => item.id == data.id)
                ..add(data),
            ));
          });
          return null;
        },
        // getAllPromotions: (e) {
        //   return null;
        // },
        createPromotion: (e) {
          throw UnimplementedError();
        },
        updatePromotion: (e) {
          throw UnimplementedError();
        },
        deletePromotion: (e) {
          throw UnimplementedError();
        },

        ///
        getWallet: (e) async {
          if (e.resourceId.isEmpty) return;
          // get only is local state is empty
          if (state.walletData != null || state.walletDataLoading == true) return;

          emit(
            state.copyWith(
              walletError: null,
              walletHasError: false,
              walletDataLoading: true,
            ),
          );

          final response = await _storeRepository.getUserWallet(e.resourceId);

          response.fold((error) {
            emit(state.copyWith(
              walletError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              walletHasError: true,
              walletDataLoading: false,
            ));
          }, (data) {
            emit(state.copyWith(
              walletError: null,
              walletHasError: false,
              walletDataLoading: false,
              walletData: data,
            ));
          });
          return null;
        },
        createWallet: (e) async {
          emit(state.copyWith(
            walletError: null,
            walletHasError: false,
            walletDataLoading: true,
          ));

          final response = await _storeRepository.postUserWallet(e.wallet);

          response.fold((error) {
            emit(state.copyWith(
              walletError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              walletHasError: true,
              walletDataLoading: false,
            ));
          }, (data) {
            emit(state.copyWith(
              walletError: null,
              walletHasError: false,
              walletDataLoading: false,
              walletData: data,
            ));
          });
          return null;
        },
        updateLocalWallet: (e) {
          var prevWallet = state.walletData;
          emit(
            state.copyWith(
              walletData: prevWallet?.copyWith(
                balance: (e.wallet.balance ?? 0),
              ),
            ),
          );
          return null;
        },
        updateWallet: (e) async {
          emit(state.copyWith(
            walletError: null,
            walletHasError: false,
            walletDataLoading: true,
          ));

          final response = await _storeRepository.putUserWallet(e.wallet);

          response.fold((error) {
            emit(state.copyWith(
              walletError: GenericApiError(
                error: error.toString(),
                status: 'error',
              ),
              walletHasError: true,
              walletDataLoading: false,
            ));
          }, (data) {
            emit(state.copyWith(
              walletError: null,
              walletHasError: false,
              walletDataLoading: false,
              walletData: data,
            ));
          });
          return null;
        },
        deleteWallet: (e) async {
          if (e.resourceId.isEmpty) return;
          emit(state.copyWith(
            walletError: null,
            walletHasError: false,
            walletDataLoading: true,
          ));

          final response = await _storeRepository.deleteUserWallet(e.resourceId);

          response.fold((error) {
            emit(
              state.copyWith(
                walletError: GenericApiError(
                  error: error.toString(),
                  status: 'error',
                ),
                walletHasError: true,
                walletDataLoading: false,
              ),
            );
          }, (data) {
            emit(
              state.copyWith(
                walletError: null,
                walletHasError: false,
                walletDataLoading: false,
                // walletData: null,
              ),
            );
          });
          return null;
        },
        clearUser: (e) {
          emit(StoreState.initial());

          return null;
        },
        addUser: (e) {
          if (e.user == null || state.userProfileData != null) return;
          emit(state.copyWith(
            userProfileData: e.user,
          ));
          return null;
        },
        uploadFiles: (e) async {
          if (e.uploads.isEmpty) null;

          emit(state.copyWith(
            uploadsTooBig: false,
            uploadsError: null,
            uploadsHasError: false,
            uploadsData: null,
            uploadsDataLoading: true,
          ));

          final data = await _storeRepository.uploadFiles(e.uploads);

          emit(
            state.copyWith(
              uploadsTooBig: data.message == 'Entity Too Large',
              uploadsError: null,
              uploadsHasError: false,
              uploadsDataLoading: false,
              uploadsData: data,
            ),
          );

          return null;
        },

        createPersonalDetails: (e) {
          emit(
            state.copyWith(
              searchPerson: e.searchPerson,
              searchPersonData: null,
              searchPersonHasError: false,
              searchPersonError: null,
            ),
          );
          return;
        },
        selectJobsOrService: (e) {
          emit(
            state.copyWith(
              searchPersonData: null,
              searchPersonHasError: false,
              searchPersonError: null,
              searchPerson: (state.searchPerson ?? SearchPerson()).copyWith(
                selectedServices: e.serviceOrJob,
              ),
            ),
          );
          return;
        },
        validateAndSubmit: (e) async {
          ///
          emit(state.copyWith(searchPersonIsLoading: true));

          if (state.searchPersonHasError == true || state.searchPersonError != null) {
            emit(
              state.copyWith(
                searchPersonError: null,
                searchPersonHasError: false,
              ),
            );
          }

          if ((state.searchPerson?.idNumber == null) && (state.searchPerson?.phoneNumber == null)) {
            ///
            emit(
              state.copyWith(
                searchPersonError: GenericApiError(error: 'No Phone number or Id Number', status: 'unknown'),
                searchPersonHasError: true,
                searchPersonData: null,
                searchPersonIsLoading: false,
              ),
            );
          }

          final response = await _storeRepository.comprehensiveVerification(
            person: state.searchPerson,
            clientId: state.userProfileData?.id ?? 'unknown',
          );
          var status = Status.unknown;
          response.fold((error) {
            verifiedErrorLogger(error, StackTrace.current);
            status = Status.failed;
            emit(
              state.copyWith(
                searchPersonError: GenericApiError(error: error.toString(), status: 'unknown'),
                searchPersonHasError: true,
                searchPersonData: null,
                searchPersonIsLoading: false,
              ),
            );
          }, (data) {
            verifiedLogger('RESPONSE:  ${data.toJson()}');
            status = Status.success_pending;

            emit(
              state.copyWith(
                searchPersonHasError: false,
                searchPersonError: null,
                searchPersonData: data,
                searchPersonIsLoading: false,
                walletData: state.walletData?.copyWith(
                  balance: (state.walletData?.balance ?? 0) - POINTS_PER_TRANSACTION,
                ),
              ),
            );
          });

          add(
            StoreEvent.createHistory(
              TransactionHistory(
                id: const Uuid().v4(),
                profileId: state.userProfileData?.id,
                amount: 0,
                isoCurrencyCode: 'ZAR',
                categoryId: status.value,
                timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                details: Details(
                    id: state.searchPerson?.instanceId,
                    query:
                        '${state.searchPerson?.idNumber ?? state.searchPerson?.phoneNumber ?? state.searchPerson?.name ?? state.searchPerson?.email}'
                            .replaceAll('  ', ' ')),
                description:
                    'Verification process pending (${state.searchPerson?.idNumber ?? state.searchPerson?.phoneNumber ?? state.searchPerson?.name ?? state.searchPerson?.email})'
                        .replaceAll('  ', ' '),
                subtype: 'spend',
                type: 'debit',
                transactionReferenceNumber: state.searchPerson?.name ?? state.searchPerson?.instanceId,
                transactionId: state.searchPerson?.instanceId,
              ),
            ),
          );

          return;
        },
        willSendNotificationAfterVerification: (e) async {
          var data = await _storeRepository.willSendNotificationAfterVerification(e.data);
          verifiedLogger('willSendNotificationAfterVerification  => $data');
          return null;
        },
        addDeviceData: (_) async {
          var device = await getCurrentDevice();

          _storeRepository.postDeviceData(await getCurrentDeviceInfo());

          emit(state.copyWith(device: device));
          return null;
        },
      ),
    );
  }
  final StoreRepository _storeRepository;

  Future _uploadRetry(
      UploadResponse data, List<MultipartFile> uploads, void Function(UploadResponse newData) update) async {
    var latest = data;
    if (data.message == 'No file uploaded') {
      final data2 = await _storeRepository.uploadFiles(uploads);
      update(data2);
      latest = data2;
      if (data2.message == 'No file uploaded') {
        final data3 = await _storeRepository.uploadFiles(uploads);
        update(data3);
        latest = data3;
      }
    }

    if (latest.message == 'No file uploaded' && uploads.length > 1) {
      var out = UploadResponse();
      for (var index = 0; index < uploads.length; index++) {
        var d2 = await _storeRepository.uploadFiles([uploads[index]]);

        out.message = d2.message;
        out.files?.addAll(d2.files ?? []);
        if (index == uploads.length - 1) {
          update(out);
          latest = out;
        }
      }
    }
  }
}
