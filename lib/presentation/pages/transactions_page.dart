import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/presentation/widgets/history/history_list_item.dart';
import 'package:verify_sa/presentation/widgets/text/list_title.dart';

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
                centerTitle: true,
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
                            "Enter your email and we will send you a link to reset your password.",
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
              leading: Container(
                margin: const EdgeInsets.only(left: 12.0),
                child: ActionButton(
                  iconColor: Colors.white,
                  bgColor: darkerPrimaryColor,
                  onTap: () => Navigator.pop(context),
                  icon: Icons.arrow_back_ios_new_rounded,
                  padding: const EdgeInsets.all(0.0),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 18,
                (_, int index) =>
                    _renderSliverListItems(_, index, (index == 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _renderSliverListItems(_, int index, isTitle) => Container(
      alignment: Alignment.centerLeft,
      padding: isTitle || index == 5 || index == 12
          ? const EdgeInsets.only(
              left: 16.0, right: 16.0, bottom: 12.0, top: 30.0)
          : const EdgeInsets.symmetric(horizontal: 16.0),
      child: isTitle || index == 5 || index == 12
          ? ListTitle(
              text: index == 12
                  ? 'Last week'
                  : index == 5
                      ? 'Yesterday'
                      : 'Today',
            )
          : TransactionListItem(
              key: Key("history-list-item-$index"),
              n: index,
            ),
    );
