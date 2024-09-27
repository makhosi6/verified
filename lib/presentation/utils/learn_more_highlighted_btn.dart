import 'package:flutter/material.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/theme.dart';

class LearnMoreHighlightedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  LearnMoreHighlightedButton({super.key, required this.text, required this.onTap}) {
    VerifiedAppAnalytics.logActionTaken(
      VerifiedAppAnalytics.ACTION_OPEN_LEARN_MORE,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.help_rounded,
                color: darkerPrimaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(
                  color: darkerPrimaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
