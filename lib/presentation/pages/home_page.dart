import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/presentation/pages/account_page.dart';
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
      const Balance(
        key: Key('homepage-balance-section'),
      ),
      const TrioHomeButtons(
        key: Key('homepage-trio-home-search-btns'),
      ),
      const CombinedHistoryList(
        key: Key('homepage-combined-history-list'),
      )
    ];
    return Scaffold(
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
          key: UniqueKey(),
          onTap: () => navigate(context, page: const SearchOptionsPage()),
          label: 'Search',
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
        child: Container(
          // constraints: appConstraints,
          // padding: primaryPadding.copyWith(bottom: 0, top: 0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              const AppErrorWarningIndicator(
                key: Key('homepage_app_error_warning_indicator'),
                type: IndicatorType.warning,
                message: 'Your phone date/time is inaccurate!',
              ),
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  automaticallyImplyLeading: true,
                  title: const Text('Verified'),
                ),
                actions: [
                  // ActionButton(
                  //   iconColor: Colors.black,
                  //   bgColor: Colors.white,
                  //   onTap: () async {
                  //     try {
                  // print("object@@");
                  // final userCredential =
                  //     await FirebaseAuth.instance.signInWithProvider(VerifiedAuthProvider.google);
                  // final user = userCredential.user;
                  // print(user?.uid);
                  // context.read<AuthBloc>().add(event)
                  // showDefaultPopUp(
                  //   context,
                  //   title: "Close the App?",
                  //   subtitle: "Are you sure you want to close the App.",
                  //   confirmBtnText: 'Okay',
                  //   declineBtnText: 'Nope',
                  //   onConfirm: () {},
                  //   onDecline: () {},
                  // );
                  //     } catch (e) {
                  //       print(e);
                  //     }
                  //   },
                  //   icon: Icons.info_outline_rounded,
                  // ),
                  ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () async {
                      final user = context.read<StoreBloc>().state.userProfileData;
                      const page = AccountPage();
                      if (user == null) {
                        await triggerAuthBottomSheet(context: context, redirect: page);
                      } else {
                        navigate(context, page: page);
                      }
                    },
                    icon: Icons.person_2_outlined,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => UnconstrainedBox(child: widgets[index]),
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
