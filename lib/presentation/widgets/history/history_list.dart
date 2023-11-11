import 'package:flutter/material.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';
import 'package:verified/presentation/widgets/text/list_title.dart';

class HistoryList extends StatelessWidget {
  final List<TransactionHistory> historyList;
  final String title;
  const HistoryList({super.key, required this.historyList, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// list title
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
          child: ListTitle(
            text: title,
          ),
        ),

        /// list items
        ...historyList.map(
          (item) => TransactionListItem(
            key: Key('history-list-item-${item.hashCode}'),
            data: item,
          ),
        ),
      ],
    );
  }
}
