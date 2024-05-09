import 'package:flutter/material.dart';
import 'package:verified/presentation/theme.dart';

class DataViewItem extends StatelessWidget {
  final String keyName;

  /// can be a Widget or String
  final dynamic value;
  const DataViewItem({
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
          const SizedBox(
            width: 40,
            height: 10,
          ),
          value is Widget
              ? value
              : Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.right,
                  ),
                )
        ],
      ),
    );
  }
}
