// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:verify_sa/theme.dart';
import 'package:verify_sa/widgets/popups/sucessful_payment.dart';

class TrioButtons extends StatelessWidget {
  const TrioButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: primaryPadding,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ClickableItem(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const SuccessfulPaymentModal(),
            ),
            text: "Transfer",
            icon: Icons.sensor_occupied,
          ),
          _separator,
          _ClickableItem(
            onTap: () {},
            text: "Top Up",
            icon: Icons.credit_score,
          ),
          _separator,
          _ClickableItem(
            onTap: () {},
            text: "History",
            icon: Icons.history_sharp,
          ),
        ],
      ),
    );
  }
}

class _ClickableItem extends StatelessWidget {
  final IconData icon;

  final String text;

  final void Function() onTap;

  const _ClickableItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

var _separator = Container(
  width: 2.0,
  height: 57.0,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.2, 0.2, 0.1, 0.2, 0.1, 0.2],
      colors: [
        neutralGrey.withOpacity(0.4),
        neutralGrey.withOpacity(0.4),
        Colors.white,
        Colors.white,
        neutralGrey.withOpacity(0.4),
        neutralGrey.withOpacity(0.4),
      ],
    ),
  ),
);
