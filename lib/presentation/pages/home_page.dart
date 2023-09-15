import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/pages/account_page.dart';
import 'package:verify_sa/presentation/pages/search_options_page.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/utils/pop_up.dart';
import 'package:verify_sa/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/presentation/widgets/buttons/trio_cta_buttons.dart';
import 'package:verify_sa/presentation/widgets/history/history_list.dart';
import 'package:verify_sa/presentation/widgets/profile/balance.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePageContents();
  }
}

class HomePageContents extends StatelessWidget {
  HomePageContents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 150.0,
        height: 74.0,
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
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const SearchOptionsPage(),
            ),
          ),
          label: "Search",
          color: Colors.white,
          iconBgColor: neutralYellow,
          bgColor: neutralYellow,
          buttonIcon: const Image(
            image: AssetImage("assets/icons/find-icon.png"),
          ),
          buttonSize: ButtonSize.large,
          hasBorderLining: false,
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500.0),
          padding: primaryPadding.copyWith(bottom: 0, top: 0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
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
                  ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () => showDefaultPopUp(context,
                        title: "Close the App?",
                        subtitle: "Are you sure you want to close the App.",
                        confirmBtnText: 'Okay',
                        declineBtnText: 'Nope',
                        onConfirm: () {},
                        onDecline: () {}),
                    icon: Icons.add_chart,
                  ),
                  ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const AccountPage(),
                      ),
                    ),
                    icon: Icons.person_2_outlined,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => _widgets[index],
                  childCount: _widgets.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<Widget> _widgets = [
    const Balance(
      key: Key('balance-section'),
    ),
    const TrioHomeButtons(
      key: Key('trio-home-search-btn'),
    ),
    const HistoryList(
        key: Key('history-list-0'), historyList: [1, 2, 3], title: "today"),
    const HistoryList(
        key: Key('history-list-1'), historyList: [1, 2, 3], title: "Yesterday"),
    const HistoryList(
        key: Key('history-list-2'),
        historyList: [1, 2, 3, 4, 5],
        title: "Last month")
  ];
}
