import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/popups/successful_payment.dart';

class TrioHomeButtons extends StatelessWidget {
  const TrioHomeButtons({super.key});

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
            iconWidget: const Image(
              height: 23.0,
              image: AssetImage("assets/icons/find-icon.png"),
            ),
          ),
          _separator,
          _ClickableItem(
            onTap: () {},
            text: "Top Up",
            iconWidget: const Icon(
              Icons.credit_score,
              color: Colors.white,
            ),
          ),
          _separator,
          _ClickableItem(
            onTap: () {},
            text: "History",
            iconWidget: const Icon(
              Icons.history_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClickableItem extends StatelessWidget {
  final Widget iconWidget;

  final String text;

  final void Function() onTap;

  const _ClickableItem({
    Key? key,
    required this.iconWidget,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconWidget,
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