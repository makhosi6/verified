import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/form_type.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/globals.dart';
import 'package:verified/main.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';

class SearchResultsPage extends StatelessWidget {
  final FormType type;
  const SearchResultsPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: type == FormType.idForm
            ? const IdVerificationSearchResultsPageContent()
            : const ContactVerificationSearchResultsPageContent());
  }
}

class ContactVerificationSearchResultsPageContent extends StatelessWidget {
  const ContactVerificationSearchResultsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifySaBloc, VerifySaState>(
      builder: (context, state) {
        if (state.contactTracingData == null || state.contactTracingDataLoading) {
          showAppLoader(context);
        } else {
          hideAppLoader();
        }
        final results = state.contactTracingData?.contactEnquiry?.results;
        print('STATE \n\n$results\n: $state');
        return Center(
          child: SizedBox(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppErrorWarningIndicator(
                  show: context.watch<VerifySaBloc>().state.resourceHealthStatus == ResourceHealthStatus.bad,
                  message: 'The DHA service is down! Please try again later.',
                ),
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
                              height: 20,
                              width: 100,
                              color: Colors.transparent,
                            )
                          : Container(
                              constraints: appConstraints,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(top: primaryPadding.top),
                              child: Column(
                                key: ValueKey(results),
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8),
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: GoogleFonts.dmSans(
                                            color: neutralDarkGrey,
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                  ...(results ?? []).map((result) {
                                    var data = result.toJson();
                                    var keys = data.keys.toList();
                                    var values = data.values.toList();
                                    print('DATA: $data');
                                    print('KEYS : $keys');

                                    print('VALUES: $values');

                                    return SizedBox(
                                      child: Column(
                                        key: ValueKey(data),
                                        children: List.generate(
                                          keys.length,
                                          (i) => _renderSliverListItems(
                                            key: keys[i],
                                            value: values[i] ?? 'Not Set',
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IdVerificationSearchResultsPageContent extends StatelessWidget {
  const IdVerificationSearchResultsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifySaBloc, VerifySaState>(
      builder: (context, state) {
        
        if (state.verifyIdDataLoading || state.verifyIdData == null) {
          showAppLoader(context);
        } else {
          hideAppLoader();
        }

        Map<String, dynamic>? results = state.verifyIdData?.verification?.toJson();
        print('STATE \n\n$results\n: $state');
        final apiHealthStatus = context.read<StoreBloc>().state.resourceHealthStatus;
        return Center(
          child: SizedBox(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppErrorWarningIndicator(
                  show: apiHealthStatus == ResourceHealthStatus.bad || apiHealthStatus == ResourceHealthStatus.unknown,
                  message: 'The DHA service is down! Please try again later.',
                ),
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
                    onTap: () => navigate(context, page: const SearchOptionsPage(), replaceCurrentPage: true),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: (results?.length ?? 0) + 1,
                    (_, int index) => UnconstrainedBox(
                      child: (index == results?.length)
                          ? Container(
                              height: 20,
                              width: 100,
                              color: Colors.transparent,
                            )
                          : Container(
                              padding: EdgeInsets.only(top: (index == 0 ? 12 : 0)),
                              constraints: appConstraints,
                              width: MediaQuery.of(context).size.width,
                              child: _renderSliverListItems(
                                key: results?.keys.toList()[index] ?? 'Key',
                                value: '${results?.values.toList()[index] ?? 'Unknown'}',
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _renderSliverListItems({
  required String key,
  required String value,
}) =>
    Container(
      alignment: Alignment.centerLeft,
      constraints: appConstraints,
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 12.0,
        top: 15.0,
      ),
      child: Column(
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
