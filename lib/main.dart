import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/config.dart';
import 'package:verify_sa/pages/landing_page.dart';
import 'package:verify_sa/theme.dart';
import 'package:verify_sa/widgets/bank_card/base_card.dart';
import 'package:verify_sa/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/widgets/buttons/trio_cta_buttons.dart';
import 'package:verify_sa/widgets/history/history_list_item.dart';
import 'package:verify_sa/widgets/profile/balance.dart';
import 'package:verify_sa/widgets/text/list_title.dart';

void main() => runApp(const MyApp());

// https://api.flutter.dev/flutter/material/SliverAppBar-class.html

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    var baseTheme = ThemeData(brightness: Brightness.light);

    ///
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.dmSansTextTheme(baseTheme.textTheme),
        primaryColor: primaryColor,
        colorScheme: ColorScheme(
          brightness: baseTheme.brightness,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: neutralYellow,
          onSecondary: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      title: displayAppName,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

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
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500.0),
          padding: primaryPadding,
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
                  centerTitle: false,
                  title: const Text('SliverAppBar'),
                ),
                // flexibleSpace: const FlexibleSpaceBar(
                //   title: Text('SliverAppBar'),
                //   background: FlutterLogo(),
                // ),
                actions: [
                  ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LandingPage(),
                          ),
                        );
                    },
                    icon: Icons.power_settings_new_sharp,
                  ),
                  ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LandingPage(),
                          ),
                        );
                    },
                    icon: Icons.settings,
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
}

final _widgets = [
  BaseButton(
    key: UniqueKey(),
    onTap: () {},
    label: "Copy",
    color: neutralGrey,
    bgColor: primaryColor,
    buttonIcon: Icon(
      Icons.copy,
      color: primaryColor,
    ),
    buttonSize: ButtonSize.small,
    hasBorderLining: false,
  ),
  BaseButton(
    key: UniqueKey(),
    onTap: () {},
    label: "Login with Google",
    buttonIcon: const Image(
      image: AssetImage("assets/icons/google.png"),
    ),
    buttonSize: ButtonSize.large,
    hasBorderLining: true,
  ),
  BaseButton(
    key: UniqueKey(),
    onTap: () {},
    label: "Facebook",
    buttonIcon: const Image(
      image: AssetImage("assets/icons/facebook.png"),
    ),
    buttonSize: ButtonSize.small,
    hasBorderLining: true,
  ),
  BaseBankCard(
    key: UniqueKey(),
  ),
  const Balance(),
  TrioButtons(
    key: UniqueKey(),
  ),
  Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
    child: const ListTitle(
      text: 'YESTERDAy',
    ),
  ),
  const TransactionListItem(
    key: Key("history-list-item-3"),
    n: 3,
  ),
  const TransactionListItem(
    key: Key("history-list-item-1"),
    n: 1,
  ),
  const TransactionListItem(
    key: Key("history-list-item-2"),
    n: 2,
  ),
  const TransactionListItem(
    key: Key("history-list-item-4"),
    n: 4,
  ),
  Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
    child: const ListTitle(
      text: 'LAST month',
    ),
  ),
  const TransactionListItem(
    key: Key("history-list-item-5"),
    n: 3,
  ),
  const TransactionListItem(
    key: Key("history-list-item-6"),
    n: 1,
  ),
  const TransactionListItem(
    key: Key("history-list-item-7"),
    n: 2,
  ),
];
