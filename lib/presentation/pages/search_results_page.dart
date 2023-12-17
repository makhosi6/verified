import 'package:flutter/material.dart';
import 'package:verified/domain/models/verify_id_response.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/transactions_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';
import 'package:verified/presentation/widgets/text/list_title.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const TransactionPage(),
                ),
              );
            },
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
        body: const SearchResultsPageContent());
  }
}

class SearchResultsPageContent extends StatelessWidget {
  const SearchResultsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    var results =

        //  ContactTracingResponse(
        //   contactEnquiry: ContactEnquiry(results: [
        //     Results(
        //       idnumber: '90900909091221',
        //       forename1: 'Kennedy',
        //       forename2: 'F',
        //       surname: 'John',
        //     )
        //   ]),
        // ).contactEnquiry?.results?[0].toJson();

        // ??
        (VerifyIdResponse(
      status: '',
      verification: Verification(
        firstnames: 'Nelson',
        lastname: 'Mandela',
        dob: '18/07/1924',
        age: 99,
        gender: 'Male',
        citizenship: 'African',
        dateIssued: '00/00/00',
      ),
    ).verification)
            ?.toJson();

    return Center(
      child: Container(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const AppErrorWarningIndicator(),
            SliverAppBar(
              stretch: true,
              onStretchTrigger: () async {},
              surfaceTintColor: Colors.transparent,
              stretchTriggerOffset: 250.0,
              expandedHeight: 250.0,
              title: const Text(
                'Search',
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
                            'Please put your phone in front',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        const ConfidenceBanner()
                      ],
                    ),
                  ),
                ),
              ),
              leadingWidth: 80.0,
              leading: VerifiedBackButton(
                key: const Key('search-results-page-back-btn'),
                onTap: () => Navigator.pop(context),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: (results?.length ?? 0) + 1,
                (_, int index) => UnconstrainedBox(
                  child: (index == results?.length)
                      ? Container(
                          height: 90,
                          width: 100,
                          color: Colors.transparent,
                        )
                      : Container(
                          constraints: appConstraints,
                          width: MediaQuery.of(context).size.width,
                          child: _renderSliverListItems(
                            key: results?.keys.toList()[index] ?? 'Key',
                            value: '${results?.values.toList()[index] ?? 'Value'}',
                            isTitle: (index == 0 || index == results?.length),
                          ),
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

Widget _renderSliverListItems({required String key, required String value, required bool isTitle}) => Container(
      alignment: Alignment.centerLeft,
      constraints: appConstraints,
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 12.0,
        top: isTitle ? 30.0 : 20.0,
      ),
      child: isTitle
          ? const ListTitle(
              text: 'Account Settings',
            )
          : Column(
              children: [
                DataItem(keyName: key, value: value),
                Divider(
                  color: Colors.grey[400],
                  indent: 0,
                  endIndent: 0,
                ),
              ],
            ),
    );

class DataItem extends StatelessWidget {
  final String keyName;

  /// can be a Widget or String
  final dynamic value;
  const DataItem({
    super.key,
    required this.keyName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            keyName,
            style: TextStyle(color: neutralDarkGrey, fontSize: 16.0),
          ),
          value is Widget
              ? value
              : Text(
                  value,
                )
        ],
      ),
    );
  }
}
