import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/pages/search_results_page.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/bank_card/base_card.dart';
import 'package:verify_sa/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/presentation/widgets/history/history_list_item.dart';
import 'package:verify_sa/presentation/widgets/text/list_title.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
        body: const AccountPageContent());
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
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const SearchResultsPage(),
                                    ),
                                  );
                                },
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
                childCount: accountSettings.length,
                (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: accountSettings[index]["text"] == "balance"
                      ? Column(
                          children: [
                            const _ProfileName(),
                            Divider(
                              color: Colors.grey[400],
                              indent: 0,
                              endIndent: 0,
                            ),
                          ],
                        )
                      : (accountSettings[index]["text"] == "title")
                          ? Container(
                              alignment: Alignment.centerLeft,
                              padding: primaryPadding.copyWith(bottom: 22.0),
                              child: const ListTitle(
                                text: 'Account Settings',
                              ),
                            )
                          : accountSettings[index]['type'] == 'button'
                              ? ListTile(
                                  onTap: () {},
                                  leading: Icon(
                                    accountSettings[index]['icon'] as IconData?,
                                    color: primaryColor,
                                    size: 32.0,
                                  ),
                                  title: Text(
                                    accountSettings[index]['text'] as String,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  enableFeedback: true,
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 16.0,
                                  ),
                                )
                              : ExpansionTile(
                                  tilePadding: const EdgeInsets.all(0.0),
                                  leading: Icon(
                                    accountSettings[index]['icon'] as IconData?,
                                    color: primaryColor,
                                    size: 32.0,
                                  ),
                                  backgroundColor: Colors.grey[100],
                                  collapsedBackgroundColor: Colors.white,
                                  childrenPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  title: Text(
                                    accountSettings[index]['text'] as String,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                  children: const [
                                    Text('Big Bang'),
                                    TransactionListItem(
                                      n: 2,
                                    ),
                                    TransactionListItem(
                                      n: 3,
                                    ),
                                    Text('Earth is Born'),
                                  ],
                                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var accountSettings = [
  {
    'type': 'expandable',
    'text': 'balance',
  },
  {
    'type': 'expandable',
    'text': "title",
  },
  {
    'type': 'expandable',
    'text': "Personal",
    'icon': Icons.person,
  },
  {
    'type': 'expandable',
    'text': "Transactions",
    'icon': Icons.payments_sharp,
  },
  {
    'type': 'button',
    'text': "Help",
    'icon': Icons.info_outline,
  },
  {
    'type': 'expandable',
    'text': "App Information",
    'icon': Icons.app_settings_alt_rounded
  },
  {
    'type': 'button',
    'text': "Logout",
    'icon': Icons.logout_outlined,
  },
  {
    'type': 'expandable',
    'text': "Privacy &  Security",
    'icon': Icons.security_outlined
  },
  {
    'type': 'button',
    'text': "Terms of Use",
    'icon': Icons.article,
  },
  {
    'type': 'button',
    'text': "Delete Account",
    'icon': Icons.delete_outline_outlined
  }
];

class _ProfileName extends StatelessWidget {
  const _ProfileName();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: const Image(
                      image: AssetImage(
                        "assets/images/autumn-goodman-vTL_qy03D1.png",
                      ),
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// name
                Text(
                  "Steve Jobs",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.left,
                ),

                /// phone
                Text(
                  "(000) 546-2124",
                  style: TextStyle(),
                  textAlign: TextAlign.left,
                ),

                /// email
                Text(
                  "stevej@apple.com",
                  textAlign: TextAlign.left,
                )
              ],
            )
          ]),
    );
  }
}
