import 'package:flutter/material.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/history/combined_history_list.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

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
          onTap: () {},
          label: "Search & Trace",
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
      body: const TransactionPageContent(),
    );
  }
}

class TransactionPageContent extends StatelessWidget {
  const TransactionPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              onStretchTrigger: () async {},
              surfaceTintColor: Colors.transparent,
              stretchTriggerOffset: 150.0,
              expandedHeight: 150.0,
              title: const Text(
                'Transactions History',
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
                            "A chronological record of all account transactions, including credits, debits, and rewards.",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              leadingWidth: 80.0,
              leading: VerifiedBackButton(
                key: const Key("transactions-page-back-btn"),
                onTap: () => Navigator.pop(context),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (_, int index) => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CombinedHistoryList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
