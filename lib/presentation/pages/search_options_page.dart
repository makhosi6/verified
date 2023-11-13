import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/presentation/pages/input_form_page.dart';
import 'package:verified/presentation/pages/search_results_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/no_internet_indicator.dart';
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
        // constraints: const BoxConstraints(maxWidth:600.0),
        // padding: primaryPadding,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            const NoInternetIndicator(),
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
                    if (state.isLoggedIn) {
                      Navigator.of(context).pop();
                      navigate(context, page: const SearchResultsPage());
                    }
                  },
                  child: ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () async {
                      print('WISH  ${context.read<StoreBloc>().state}');
                      if (context.read<StoreBloc>().state.userProfileData != null) {
                        triggerAuthBottomSheet(context: context, redirect: const SearchResultsPage());
                        return;
                      }
                      Navigator.of(context).pop();
                      navigate(context, page: const SearchResultsPage());
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
                          'Payment with QR Code',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      ///and description for the explainer
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          'Please put your phone in front of your face Please put your phone in front put your\n phone in front of your face',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: neutralDarkGrey,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
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
                              onTap: () {
                                navigate(context, page: const SearchResultsPage());
                              },
                              label: 'Seek & Guide',
                              color: neutralGrey,
                              hasIcon: false,
                              bgColor: neutralYellow,
                              buttonIcon: Icon(
                                Icons.grain_outlined,
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
                              onTap: () {
                                navigate(
                                  context,
                                  page: InputFormPage(
                                    formType: FormType.phoneNumberForm,
                                  ),
                                );
                              },
                              label: 'Learn Quick',
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
