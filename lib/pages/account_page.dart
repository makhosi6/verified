import 'package:flutter/material.dart';
import 'package:verify_sa/theme.dart';
import 'package:verify_sa/widgets/bank_card/base_card.dart';
import 'package:verify_sa/widgets/buttons/app_bar_action_btn.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AccountPageContent());
  }
}

class AccountPageContent extends StatelessWidget {
  const AccountPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500.0),
        // padding: primaryPadding,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              onStretchTrigger: () async {},
              surfaceTintColor: Colors.transparent,
              stretchTriggerOffset: 360.0,
              expandedHeight: 360.0,
              title: const Text(
                'Account',
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Payment with QR Code",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Please put your phone in front",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              ActionButton(
                                iconColor: Colors.white,
                                bgColor: neutralYellow,
                                onTap: () {},
                                icon: Icons.delete_forever_rounded,
                                borderColor: neutralYellow,
                              )
                            ],
                          ),
                        ),
                        const BaseBankCard(size: BankCardSize.short),
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
                (BuildContext context, int index) => Text(
                  "data $index",
                  key: UniqueKey(),
                ),
                childCount: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
