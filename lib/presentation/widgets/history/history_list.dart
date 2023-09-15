import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/widgets/history/history_list_item.dart';
import 'package:verify_sa/presentation/widgets/text/list_title.dart';

class HistoryList extends StatelessWidget {
  final List historyList;
  final String title;
  const HistoryList(
      {super.key, required this.historyList, required this.title});

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
            key: Key("history-list-item-${Random().nextInt(100)}"),
            n: Random().nextInt(10),
          ),
        )
      ],
    );
  }
}
