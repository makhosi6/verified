import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/history/history_list.dart';
import 'package:verified/helpers/extensions/date.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';

class CombinedHistoryList extends StatelessWidget {
  const CombinedHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      bloc: context.read<StoreBloc>(),
      builder: (context, state) {
        /// IF TRANSACTION == 0, SHOW A PROMOTION
        if (state.historyData.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                ListItemBanner(
                  type: BannerType.promotion,
                  bgColor: neutralGrey,
                  leadingIcon: Icons.local_library_outlined,
                  leadingBgColor: primaryColor,
                  title: "How it Works",
                  subtitle: "",
                  buttonText: "Learn More",
                  onTap: () {},
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ListItemBanner(
                  type: BannerType.defualt,
                  bgColor: neutralGrey,
                  leadingIcon: Icons.rocket_launch_outlined,
                  leadingBgColor: primaryColor,
                  title: "Top-Up and get rewarded with a Free Search.",
                  subtitle: "Reload with ZAR 50 or more and unlock rewards",
                  onTap: () {},
                ),
              ],
            ),
          );
        }

        /// ELSE SHOW TRANSACTIONS HISTORY
        final list = sortByDate(state.historyData);

        var today = list.today;
        var yesterday = list.yesterday;
        var thisMonth = list.thisMonth;
        var older = list.older;

        return Column(
          children: [
            if (today.isNotEmpty) HistoryList(key: const Key('history-list-today'), historyList: today, title: 'Today'),
            if (yesterday.isNotEmpty)
              HistoryList(key: const Key('history-list-yesterday'), historyList: yesterday, title: 'yesterday'),
            if (thisMonth.isNotEmpty)
              HistoryList(key: const Key('history-list-this-month'), historyList: thisMonth, title: 'This Month'),
            if (older.isNotEmpty) HistoryList(key: const Key('history-list-older'), historyList: older, title: 'Older'),
          ],
        );
      },
    );
  }
}

class HistoryListData {
  HistoryListData();
  var today = <TransactionHistory>[];
  var yesterday = <TransactionHistory>[];
  var thisMonth = <TransactionHistory>[];
  var older = <TransactionHistory>[];

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
    final date = DateTime.fromMillisecondsSinceEpoch((item.timestamp?.toInt() ?? 23587199) * 1000);
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
