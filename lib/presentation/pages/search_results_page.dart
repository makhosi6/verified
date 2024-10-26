import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/form_type.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/data_view_item.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/lottie_loader.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';

class SearchResultsPage extends StatelessWidget {
  final FormType type;
  const SearchResultsPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var user = context.read<StoreBloc>().state.userProfileData;
        context.read<StoreBloc>().add(StoreEvent.getAllHistory(user?.id ?? user?.profileId ?? ''));
        return true;
      },
      child: Scaffold(
          body: type == FormType.idForm
              ? const IdVerificationSearchResultsPageContent()
              : const ContactVerificationSearchResultsPageContent()),
    );
  }
}

class ContactVerificationSearchResultsPageContent extends StatelessWidget {
  const ContactVerificationSearchResultsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.read<StoreBloc>().state.userProfileData;
    var wallet = context.read<StoreBloc>().state.walletData;
    return BlocBuilder<VerifySaBloc, VerifySaState>(
      builder: (context, state) {
        if (state.contactTracingData == null || state.contactTracingDataLoading) {
          showAppLoader(context);
        } else {
          hideAppLoader();
        }
        final results = state.contactTracingData?.contactEnquiry?.results;

        if (results?.isNotEmpty == true) {
          if (wallet != null) {
            context.read<StoreBloc>()
              ..add(
                StoreEvent.updateLocalWallet(
                  wallet.copyWith(balance: (wallet.balance ?? 0) - POINTS_PER_TRANSACTION),
                ),
              )
              ..add(
                StoreEvent.getWallet(user?.walletId ?? ''),
              );
          }
        }

        if (kDebugMode) {
          verifiedLogger('STATE \n\n$results\n: $state');
        }
        return Center(
          child: SizedBox(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppErrorWarningIndicator(
                  key: UniqueKey(),
                ),
                SliverAppBar(
                  stretch: true,
                  onStretchTrigger: () async {},
                  surfaceTintColor: Colors.transparent,
                  stretchTriggerOffset: 250.0,
                  expandedHeight: 250.0,
                  title: const Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: darkerPrimaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        reverse: true,
                        clipBehavior: Clip.none,
                        padding: primaryPadding.copyWith(bottom: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: primaryPadding.copyWith(left: 0, right: 0),
                              child: const Text(
                                'Your quick verification is complete! Below are the results based on the phone number provided',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const ConfidenceBanner()
                          ],
                        ),
                      ),
                    ),
                  ),
                  leadingWidth: 80.0,
                  leading: VerifiedBackButton(
                    key: const Key('search-results-page-back-btn'),
                    onTap: () {
                      context.read<StoreBloc>().add(StoreEvent.getAllHistory(user?.id ?? user?.profileId ?? ''));
                      navigate(context, page: const SearchOptionsPage(), replaceCurrentPage: true);
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (_, int index) => UnconstrainedBox(
                      child: Container(
                        constraints: appConstraints,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: primaryPadding.top, bottom: primaryPadding.bottom),
                        child: (results == null || results.isEmpty)
                            ? const ResultsSkeleton(numberOfCards: 12, itemsPerCard: 5, cardsHasTitle: true)
                            : Column(
                                key: ValueKey(results.hashCode),
                                children: results.map((result) {
                                  var data = result.toJson();
                                  var keys = data.keys.toList();
                                  var values = data.values.toList();

                                  return Column(
                                    key: ValueKey(keys.hashCode),
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8),
                                        child: Center(
                                          child: Text(
                                            (results.indexWhere((element) => element.idnumber == result.idnumber) + 1)
                                                .toString(),
                                            style: GoogleFonts.dmSans(
                                              color: neutralDarkGrey,
                                              fontSize: 20.0,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Card(
                                          color: const Color.fromARGB(255, 227, 240, 231),
                                          elevation: 1.0,
                                          child: SizedBox(
                                            child: Column(
                                              key: ValueKey(data),
                                              children: List.generate(
                                                keys.length,
                                                (i) => _renderSliverListItems(
                                                    key: keys[i],
                                                    value: values[i] ?? 'Unknown',
                                                    isLast: i == (keys.length - 1)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IdVerificationSearchResultsPageContent extends StatelessWidget {
  const IdVerificationSearchResultsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.read<StoreBloc>().state.userProfileData;
    var wallet = context.read<StoreBloc>().state.walletData;
    return BlocBuilder<VerifySaBloc, VerifySaState>(
      builder: (context, state) {
        if (state.verifyIdDataLoading || state.verifyIdData == null) {
          showAppLoader(context);
        } else {
          hideAppLoader();
        }

        Map<String, dynamic>? results = state.verifyIdData?.verification?.toJson();

        if (results?.isNotEmpty == true) {
          if (wallet != null) {
            context.read<StoreBloc>()
              ..add(
                StoreEvent.updateLocalWallet(
                  wallet.copyWith(balance: (wallet.balance ?? 0) - POINTS_PER_TRANSACTION),
                ),
              )
              ..add(
                StoreEvent.getWallet(user?.walletId ?? ''),
              );
          }
        }

        if (kDebugMode) {
          verifiedLogger('STATE \n\n$results\n: $state');
        }

        return Center(
          child: SizedBox(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppErrorWarningIndicator(
                  key: UniqueKey(),
                ),
                SliverAppBar(
                  stretch: true,
                  onStretchTrigger: () async {},
                  surfaceTintColor: Colors.transparent,
                  stretchTriggerOffset: 250.0,
                  expandedHeight: 250.0,
                  title: const Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: darkerPrimaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        reverse: true,
                        clipBehavior: Clip.none,
                        padding: primaryPadding.copyWith(bottom: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: primaryPadding.copyWith(left: 0, right: 0),
                              child: const Text(
                                'Your quick verification is complete! Below are the results based on the ID number provided',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const ConfidenceBanner()
                          ],
                        ),
                      ),
                    ),
                  ),
                  leadingWidth: 80.0,
                  leading: VerifiedBackButton(
                    key: const Key('search-results-page-back-btn'),
                    onTap: () {
                      context.read<StoreBloc>().add(StoreEvent.getAllHistory(user?.id ?? user?.profileId ?? ''));
                      navigate(context, page: const SearchOptionsPage(), replaceCurrentPage: true);
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: (results?.length ?? 1),
                    (_, int index) => UnconstrainedBox(
                      child: Container(
                        padding: EdgeInsets.only(top: (index == 0 ? 12 : 0)),
                        constraints: appConstraints,
                        width: MediaQuery.of(context).size.width,
                        child: (results == null || results.isEmpty)
                            ? const ResultsSkeleton(cardsHasTitle: false, itemsPerCard: 6, numberOfCards: 3)
                            : _renderSliverListItems(
                                key: results.keys.toList()[index],
                                value: '${results.values.toList()[index] ?? 'Unknown'}',
                                isLast: index == (results.values.toList().length - 1),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _renderSliverListItems({required String key, required String value, required bool isLast}) => Container(
      alignment: Alignment.centerLeft,
      constraints: appConstraints,
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 12.0,
        top: 15.0,
      ),
      child: Column(
        children: [
          DataViewItem(keyName: key, value: value),
          if (!isLast)
            Divider(
              color: Colors.grey[400],
              indent: 0,
              endIndent: 0,
            ),
        ],
      ),
    );

class ResultsSkeleton extends StatelessWidget {
  final bool cardsHasTitle;
  final int numberOfCards;
  final int itemsPerCard;

  const ResultsSkeleton({
    super.key,
    required this.cardsHasTitle,
    required this.itemsPerCard,
    required this.numberOfCards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        numberOfCards,
        (index) => Skeletonizer.zone(
          containersColor: primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (cardsHasTitle)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Bone.text(
                    width: 30,
                  ),
                ),
              Card(
                elevation: cardsHasTitle ? null : 0,
                child: Container(
                  constraints: appConstraints.copyWith(minHeight: 300),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 12.0,
                    top: 12.0,
                  ),
                  child: Column(
                    mainAxisAlignment: cardsHasTitle ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      itemsPerCard,
                      (i) => const Row(
                        children: [
                          Expanded(child: Bone.text()),
                          SizedBox(width: 30, height: 20),
                          Expanded(child: Bone.text()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void hideAppLoader() {
  /// hide loader option 1
  Loader.hide();
}

void showAppLoader(BuildContext context) {
  /// show loader option 1
  Loader.show(
    context,
    overlayFromBottom: 80,
    overlayColor: darkBlurColor,
    progressIndicator: const LottieProgressLoader(
      key: Key('lottie_progress_loader-2'),
    ),
  );
}
