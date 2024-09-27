import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/globals.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/pages/capture_details_page.dart';
import 'package:verified/presentation/pages/input_form_page.dart';
import 'package:verified/presentation/pages/learn_more_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/test_user_utils.dart';
import 'package:verified/presentation/utils/trigger_auth_bottom_sheet.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class SearchOptionsPage extends StatelessWidget {
  const SearchOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _SearchOptionsPageContent(),
    );
  }
}

class _SearchOptionsPageContent extends StatelessWidget {
  const _SearchOptionsPageContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          const AppErrorWarningIndicator(),
          SliverAppBar(
            stretch: true,
            onStretchTrigger: () async {},
            surfaceTintColor: Colors.transparent,
            stretchTriggerOffset: 300.0,
            expandedHeight: 90.0,
            flexibleSpace: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Verify'),
            ),
            leadingWidth: 80.0,
            leading: VerifiedBackButton(
              key: const Key('search-page-back-btn'),
              onTap: Navigator.of(context).pop,
              isLight: true,
            ),
            actions: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  // if (state.isLoggedIn) {
                  //   Navigator.of(context).pop();
                  //   verifiedLogger('===========EXIT===============');
                  //   exit(0);
                  //   // navigate(context, page: const SearchResultsPage(type: f,));
                  // }
                },
                child: ActionButton(
                  key: const Key('go-to-tutorials-btn'),
                  tooltip: 'Information',
                  iconColor: darkerPrimaryColor.withOpacity(0.7),
                  bgColor: Colors.white,
                  onTap: () => navigate(context, page: LearnMorePage()),
                  icon: Icons.help_rounded,
                  borderColor: darkerPrimaryColor.withOpacity(0.3),
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    //image
                    RawGestureDetector(
                      gestures: <Type, GestureRecognizerFactory>{
                        // TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                        //     () => TapGestureRecognizer(), (instance) {
                        //   instance.onTap = () => debugPrint('ON TAP...');
                        // }),
                        LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                          () => LongPressGestureRecognizer(
                            debugOwner: this,
                            duration: const Duration(seconds: 5),
                          ),
                          (LongPressGestureRecognizer instance) {
                            instance.onLongPress = () => onLogInAsTestUser(context);
                          },
                        ),
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: const Image(
                          image: AssetImage('assets/images/12704419_4968099.jpg'),
                          height: 230.0,
                        ),
                      ),
                    ),

                    ///header for the explainer
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Verify with confidence',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    ///and description for the explainer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      constraints: appConstraints,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            color: neutralDarkGrey,
                            fontSize: 14.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Validate an individual\'s identity using only their ',
                            ),
                            TextSpan(
                              text: 'id number',
                              style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                color: darkerPrimaryColor,
                              ),
                            ),
                            const TextSpan(
                              text: ' or ',
                            ),
                            TextSpan(
                              text: 'phone number',
                              style: GoogleFonts.ibmPlexSans(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                color: darkerPrimaryColor,
                              ),
                            ),
                            const TextSpan(
                                text:
                                    ', to ensuring you have the correct information for transaction or background checks.')
                          ],
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    child: Column(
                      children: [
                        /// Quick Verification
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: BaseButton(
                            key: UniqueKey(),
                            onTap: () {
                              final user = context.read<StoreBloc>().state.userProfileData;
                              const selectedPage = InputFormPage();
                              if (user == null) {
                                VerifiedAppAnalytics.logActionTaken(
                                  VerifiedAppAnalytics.ACTION_LOGIN,
                                  {
                                    'page': '$selectedPage',
                                  },
                                );
                                triggerAuthBottomSheet(context: context, redirect: selectedPage);
                              } else {
                                navigate(context, page: selectedPage);
                              }
                            },
                            label: 'Quick Verification',
                            color: neutralGrey,
                            hasIcon: false,
                            bgColor: neutralYellow,
                            buttonIcon: Icon(
                              Icons.lock_outline,
                              color: neutralYellow,
                            ),
                            buttonSize: ButtonSize.large,
                            hasBorderLining: false,
                          ),
                        ),

                        ///Comprehensive Verification
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: BaseButton(
                            key: UniqueKey(),
                            onTap: () {
                              final user = context.read<StoreBloc>().state.userProfileData;
                              if (user == null) {
                                      VerifiedAppAnalytics.logActionTaken(
                                  VerifiedAppAnalytics.ACTION_LOGIN,
                                  {
                                    'page': 'CaptureDetailsPage',
                                  },
                                );
                                triggerAuthBottomSheet(context: context, redirect: CaptureDetailsPage());

                                return;
                              } else {
                                navigate(
                                  context,
                                  page: CaptureDetailsPage(),
                                );
                              }
                            },
                            label: 'Comprehensive Verification',
                            color: neutralGrey,
                            hasIcon: false,
                            buttonIcon: null,
                            bgColor: primaryColor,
                            buttonSize: ButtonSize.large,
                            hasBorderLining: false,
                          ),
                        ),

                        /// Disabled Button
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 12.0),
                        //   child: Tooltip(
                        //     message: 'Disabled',
                        //     onTriggered: () {},
                        //     triggerMode: TooltipTriggerMode.tap,
                        //     child: BaseButton(
                        //       key: UniqueKey(),
                        //       label: 'Quick Verification',
                        //       color: Colors.grey.shade400,
                        //       hasIcon: false,
                        //       bgColor: Colors.white,
                        //       buttonIcon: Icon(
                        //         Icons.lock_outline,
                        //         color: primaryColor,
                        //       ),
                        //       buttonSize: ButtonSize.large,
                        //       hasBorderLining: true,
                        //       borderColor: Colors.grey.shade400,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
