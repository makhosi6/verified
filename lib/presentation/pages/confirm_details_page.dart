// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/data_view_item.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/popups/successful_action_popup.dart';

class ConfirmDetailsPage extends StatelessWidget {
  ConfirmDetailsPage({super.key});
  final person = [
    {'value': '971230 1313 131', 'key': 'Id Number'},
    {'value': 'John', 'key': 'name'},
    {'value': '30', 'key': 'age'},
    {'value': 'male', 'key': 'gender'},
    {'value': 'software engineer', 'key': 'occupation'},
    {'value': 'Cape town', 'key': 'city'},
    {'value': 'English', 'key': 'language'},
    {'value': 'johndoe@example.com', 'key': 'email'},
    {'value': '123-456-7890', 'key': 'phone'}
  ];
  final product = [
    {'value': 'Laptop', 'key': 'name'},
    {'value': '1000', 'key': 'price'},
    {'value': 'electronics', 'key': 'category'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppErrorWarningIndicator(),
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  automaticallyImplyLeading: true,
                  title: const Text('Search'),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: const Key('capture-details-page-back-btn'),
                  onTap: () => Navigator.pop(context),
                  isLight: true,
                ),
                actions: [
                  ActionButton(
                    key: const Key('go-to-search-btn'),
                    tooltip: 'Go to Search Page',
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const SearchOptionsPage(),
                      ),
                    ),
                    icon: Icons.person_2_outlined,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => UnconstrainedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                      constraints: appConstraints,
                      padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: primaryPadding.bottom, left: primaryPadding.left),
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
                                      text: ' Page 1 ',
                                    ),
                                    TextSpan(
                                      text: ' > ',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                        color: darkerPrimaryColor,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' Page 2 ',
                                    ),
                                    TextSpan(
                                      text: ' > ',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                        color: darkerPrimaryColor,
                                      ),
                                    ),
                                    const TextSpan(text: ' Page 3 ')
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 40,
                            width: 40,
                          ),

                          /// confirm details
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: primaryPadding.top),
                                  child: const Text(
                                    'Personal Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: person
                                          .map(
                                            (item) => _DataView(
                                              keyName: item['key'] ?? 'key',
                                              value: item['value'] ?? 'value',
                                              withDivider: item['key'] != person.last['key'],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///
                          const SizedBox(
                            height: 20,
                            width: 20,
                          ),

                          /// confirm page/category/product type
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: primaryPadding.top),
                                  child: const Text(
                                    'Selected Product',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: product
                                          .map(
                                            (item) => _DataView(
                                              keyName: item['key'] ?? 'key',
                                              value: item['value'] ?? 'value',
                                              withDivider: item['key'] != product.last['key'],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// next button
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: BaseButton(
                                key: UniqueKey(),
                                label: 'Confirm',
                                color: neutralGrey,
                                hasIcon: false,
                                bgColor: primaryColor,
                                buttonIcon: Icon(
                                  Icons.lock_outline,
                                  color: primaryColor,
                                ),
                                buttonSize: ButtonSize.large,
                                hasBorderLining: false,
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => SuccessfulActionModal(
                                    title: 'Action & Done',
                                    subtitle: 'Your Action of has been successfully processed. Thank you for your top-up! 🎉',
                                    nextAction: () => Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const HomePage()),
                                      (_) => false,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataView extends StatelessWidget {
  final String keyName;
  final String value;
  final bool withDivider;

  const _DataView({Key? key, required this.keyName, required this.value, required this.withDivider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataViewItem(keyName: keyName, value: value),
        if (withDivider)
          Divider(
            color: Colors.grey[400],
            indent: 0,
            endIndent: 0,
          ),
      ],
    );
  }
}
