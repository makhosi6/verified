// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
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
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  automaticallyImplyLeading: true,
                  title: const Text('Confirm'),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: const Key('capture-details-page-back-btn'),
                  onTap: () => Navigator.pop(context),
                  isLight: true,
                ),
                actions: const [],
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
                            padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                            child: Text(
                              'Instantly confirm the legitimacy of personal information with our user-friendly app.',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: neutralDarkGrey,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0, left: 0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: neutralDarkGrey,
                                  fontSize: 14.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Details ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                        ..pop()
                                        ..pop(),
                                    style: GoogleFonts.ibmPlexSans(
                                      color: darkerPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' > ',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Options ',
                                    recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pop(),
                                    style: GoogleFonts.ibmPlexSans(
                                      color: darkerPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' > ',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Confirm ',
                                    style: GoogleFonts.ibmPlexSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                    'Selected Options',
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
                                    subtitle:
                                        'Your Action of has been successfully processed. Thank you for your top-up! 🎉',
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
