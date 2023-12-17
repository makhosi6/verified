import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/how_it_works_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/history/history_list.dart';
import 'package:verified/helpers/extensions/date.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';

class CombinedHistoryList extends StatelessWidget {
  final int? limit;
  final bool? showBanner;

  const CombinedHistoryList({super.key, this.limit, this.showBanner = true});

  @override
  Widget build(BuildContext context) {
    var learnMoreBanner = ListItemBanner(
      type: BannerType.promotion,
      bgColor: neutralGrey,
      leadingIcon: Icons.local_library_outlined,
      leadingBgColor: primaryColor,
      title: 'How it Works',
      subtitle: '',
      buttonText: 'Learn More',
      onTap: () => navigate(context, page: const HowItWorksPage()),
    );

    return Container(
      width: MediaQuery.of(context).size.width - 12,
      constraints: appConstraints,
      child: BlocBuilder<StoreBloc, StoreState>(
        bloc: context.watch<StoreBloc>(),
        builder: (context, state) {
          /// IF TRANSACTION == 0, SHOW A PROMOTION
          if (state.historyData.isEmpty && limit == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  learnMoreBanner,
                  const SizedBox(
                    height: 20.0,
                  ),
                  ListItemBanner(
                    type: BannerType.defualt,
                    bgColor: neutralGrey,
                    leadingIcon: Icons.rocket_launch_outlined,
                    leadingBgColor: primaryColor,
                    title: 'Top-Up and get rewarded with a Free Search.',
                    subtitle: 'Reload with ZAR 50 or more and unlock rewards',
                    onTap: () {},
                  ),
                ],
              ),
            );
          }

          if (state.historyData.isEmpty) {
            return Center(
              child: Text(
                'NO TRANSACTIONS HISTORY',
                style: GoogleFonts.dmSans(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          /// ELSE SHOW TRANSACTIONS HISTORY
          /// ..sort((a, b) => ((a.createdAt ?? 0) as int) - ((b.createdAt ?? 0) as int))
          final list = sortByDate(state.historyData);

          var today = list.today;
          var yesterday = list.yesterday;
          var thisMonth = list.thisMonth;
          var older = list.older;

          return Column(
            children: [
              if (showBanner == true) learnMoreBanner,
              if (showBanner == true)
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 28.0, left: 8.0),
                    child: Text(
                      'TRANSACTIONS HISTORY',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              if (today.isNotEmpty)
                HistoryList(key: const Key('history-list-today'), historyList: today, title: 'Today'),
              if (yesterday.isNotEmpty)
                HistoryList(key: const Key('history-list-yesterday'), historyList: yesterday, title: 'yesterday'),
              if (thisMonth.isNotEmpty)
                HistoryList(key: const Key('history-list-this-month'), historyList: thisMonth, title: 'This Month'),
              if (older.isNotEmpty)
                HistoryList(key: const Key('history-list-older'), historyList: older, title: 'Older Than A Month'),
              if (showBanner == true)
                Container(
                  height: 90,
                  width: 100,
                  color: Colors.transparent,
                )
            ],
          );
        },
      ),
    );
  }
}

class HistoryListData {
  HistoryListData();
  List<TransactionHistory> today = [];
  List<TransactionHistory> yesterday = [];
  List<TransactionHistory> thisMonth = [];
  List<TransactionHistory> older = [];

  Map<String, List> toJson() {
    Map<String, List> map = {};

    map['today'] = today;
    map['yesterday'] = yesterday;
    map['this month'] = thisMonth;
    map['older'] = older;

    return map;
  }
}

HistoryListData sortByDate(List<TransactionHistory> items) {
  final historyList = HistoryListData();
  for (var i = 0; i < items.length; i++) {
    ///
    final item = items[i];
    final date = DateTime.fromMillisecondsSinceEpoch((item.timestamp?.toInt() ?? 0) * 1000);
    if (date.isToday) {
      historyList.today.add(item);
    } else if (date.isYesterday) {
      historyList.yesterday.add(item);
    } else if (date.isThisMonth) {
      historyList.thisMonth.add(item);
    } else {
      historyList.older.add(item);
    }
  }

  return historyList;
}
