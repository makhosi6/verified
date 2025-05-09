import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/presentation/pages/account_page.dart';
import 'package:verified/presentation/pages/id_document_scanner_page.dart';
import 'package:verified/presentation/pages/input_verification_url.dart';
import 'package:verified/presentation/pages/verification_page.dart';
import 'package:verified/presentation/utils/document_type.dart';
import 'package:verified/presentation/utils/verification_done_bottom_sheet.dart';
import 'package:verified/presentation/widgets/history/combined_history_list.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/trigger_auth_bottom_sheet.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/buttons/trio_cta_buttons.dart';
import 'package:verified/presentation/widgets/profile/balance.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePageContents();
  }
}

class HomePageContents extends StatelessWidget {
  const HomePageContents({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      GestureDetector(
        // onTap: () {
        //   navigate(context, page: const VerificationPage());
        // },
        //
        // onTap: () {
        //   navigate(context,
        //       page: IDDocumentScanner(
        //         onStateChanged: (state) {},
        //         onNext: (BuildContext ctx, CameraEventsState? state) {},
        //         onCapture: (File file, DetectSide side) {},
        //         documentType: DocumentType.id_card,
        //         onMessage: (List<String> msgs) {},
        //       ));
        // },
        //
        onTap: () {
          const placeholderUuid = '0000000-0000-0000-0000-00000000000';
          context.read<StoreBloc>().add(const StoreEvent.validateVerificationLink(placeholderUuid));
          navigateToNamedRoute(
            context,
            arguments: VerificationPageArgs(placeholderUuid),
          );
        },
        child: const Balance(
          key: Key('homepage-balance-section'),
        ),
      ),
      const TrioHomeButtons(
        key: Key('homepage-trio-home-search-btns'),
      ),
      const CombinedHistoryList(
        key: Key('homepage-combined-history-list'),
      )
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 150.0,
          height: 74.0,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            boxShadow: [
              const BoxShadow(color: Colors.transparent),
              BoxShadow(
                offset: const Offset(1, 30),
                blurRadius: 30,
                color: darkerPrimaryColor.withOpacity(0.2),
              ),
            ],
          ),
          child: BaseButton(
            key: const Key('main-search-fab'),
            onTap: () {
              VerifiedAppAnalytics.logFeatureUsed(VerifiedAppAnalytics.FEATURE_VERIFY_FROM_HOME);
              navigate(context, page: const SearchOptionsPage());
            },
            label: 'Verify',
            color: Colors.white,
            iconBgColor: neutralYellow,
            bgColor: neutralYellow,
            buttonIcon: const Image(
              image: AssetImage('assets/icons/find-icon.png'),
            ),
            buttonSize: ButtonSize.large,
            hasBorderLining: false,
          ),
        ),
        body: Center(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              const AppErrorWarningIndicator(
                key: Key('homepage_app_error_warning_indicator'),
              ),
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                centerTitle: false,
                flexibleSpace: AppBar(
                  automaticallyImplyLeading: true,
                  centerTitle: false,
                  // title: Image.asset('assets/icons/logo.png', width: 40, height: 40, fit: BoxFit.fitHeight,),
                  title: const Text('Verified'),
                ),
                leading: const SizedBox.shrink(),
                actions: [
                  Padding(
                    padding: primaryPadding,
                    child: InkWell(
                      onTap: () => verificationDoneBottomSheet(
                        context,
                        title: 'Are You Sure You Want to Cancel?',
                        msg:
                            "It looks like you're about to leave the account creation process. If you wish to cancel, press yes",
                        lottieBuilder: Lottie.asset(
                          'assets/lottie/confetti.json',
                          fit: BoxFit.contain,
                        ),
                        actions: [
                          Padding(
                            padding: EdgeInsets.only(top: primaryPadding.top),
                            child: BaseButton(
                              buttonIcon: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                              ),
                              iconBgColor: primaryColor.withOpacity(0.5),
                              borderColor: litePrimaryColor,
                              bgColor: primaryColor,
                              hasIcon: true,
                              buttonSize: ButtonSize.large,
                              color: Colors.white,
                              label: 'Okay',
                              hasBorderLining: false,
                              onTap: () => {},
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: primaryPadding.top),
                            child: BaseButton(
                              buttonIcon: const Icon(
                                Icons.close_rounded,
                              ),
                              hasIcon: true,
                              buttonSize: ButtonSize.large,
                              label: 'No, Thanks',
                              hasBorderLining: true,
                              onTap: () => {},
                            ),
                          ),
                        ],
                      ),
                      // onTap: () => navigate(context, page: PermitFormPage(), arguments: {
                      //   'docType': DocumentType.passport,
                      //   'jobUuid': '0000000-0000-0000-0000-00000000000',
                      // }),
                      child: Row(
                        children: [
                          Text(
                            'Test',
                            style: GoogleFonts.dmSans(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: primaryPadding,
                    child: InkWell(
                      onTap: () => navigate(context, page: const InputVerificationURL()),
                      child: Row(
                        children: [
                          Text(
                            'Start Verification',
                            style: GoogleFonts.dmSans(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ActionButton(
                    key: const Key('go-to-user-account-btn'),
                    tooltip: 'User Account',
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () async {
                      try {
                        final user = context.read<StoreBloc>().state.userProfileData ?? (await LocalUser.getUser());
                        const page = AccountPage();
                        if (user == null) {
                          VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_LOGIN, {'page': '$page'});
                          // ignore: use_build_context_synchronously
                          await triggerAuthBottomSheet(context: context, redirect: page);
                        } else {
                          // ignore: use_build_context_synchronously
                          navigate(context, page: page);
                        }
                      } catch (error, stackTrace) {
                        verifiedErrorLogger(error, stackTrace);
                      }
                    },
                    icon: Icons.person_2_outlined,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => UnconstrainedBox(key: ValueKey(index), child: widgets[index]),
                  childCount: widgets.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
