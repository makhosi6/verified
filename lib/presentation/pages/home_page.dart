import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
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
          key: const Key('main-search-fab'),
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
                leading: const SizedBox.shrink(),
                actions: [
                  ActionButton(
                    key: const Key('go-to-user-account-btn'),
                    tooltip: 'User Account',
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () async {
                      try {
                        final user = context.read<StoreBloc>().state.userProfileData ?? (await LocalUser.getUser());
                        final page = AccountPage();
                        if (user == null) {
                          // ignore: use_build_context_synchronously
                          await triggerAuthBottomSheet(context: context, redirect: page);
                        } else {
                          // ignore: use_build_context_synchronously
                          navigate(context, page: page);
                        }
                      } catch (e) {
                        if (kDebugMode) print('\n\n=============================\n $e');
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
