import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/form_type.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/account_page.dart';
import 'package:verified/presentation/pages/input_form_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
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
      child: Container(
        // constraints: appConstraints,
        // padding: primaryPadding,
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
                title: const Text('Verification'),
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
                    //   print('===========EXIT===============');
                    //   exit(0);
                    //   // navigate(context, page: const SearchResultsPage(type: f,));
                    // }
                  },
                  child: ActionButton(
                    key: const Key('go-to-account-btn'),
                    tooltip: 'Account',
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () async {
                      final user = context.read<StoreBloc>().state.userProfileData;
                      final page = AccountPage();
                      if (user == null) {
                        await triggerAuthBottomSheet(context: context, redirect: page);
                      } else {
                        navigate(context, page: page);
                      }
                    },
                    icon: Icons.person_2_outlined,
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
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: const Image(
                          image: AssetImage('assets/images/12704419_4968099.jpg'),
                          height: 230.0,
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
                            style: TextStyle(
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
                                      ', to ensuring you have the correct information for transactions or background checks.')
                            ],
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: BaseButton(
                              key: UniqueKey(),
                              onTap: () => navigate(
                                context,
                                page: InputFormPage(
                                  formType: FormType.phoneNumberForm,
                                ),
                              ),
                              label: 'Verify Phone Number',
                              color: neutralGrey,
                              hasIcon: false,
                              bgColor: neutralYellow,
                              buttonIcon: Icon(
                                Icons.transcribe,
                                color: neutralYellow,
                              ),
                              buttonSize: ButtonSize.large,
                              hasBorderLining: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: BaseButton(
                              key: UniqueKey(),
                              onTap: () => navigate(
                                context,
                                page: InputFormPage(
                                  formType: FormType.idForm,
                                ),
                              ),
                              label: 'Verify ID Number',
                              color: neutralGrey,
                              hasIcon: false,
                              bgColor: primaryColor,
                              buttonIcon: Icon(
                                Icons.lock_outline,
                                color: primaryColor,
                              ),
                              buttonSize: ButtonSize.large,
                              hasBorderLining: false,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
