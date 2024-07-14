// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:verified/presentation/theme.dart';

class ActionButton extends StatelessWidget {
  final Color iconColor;
  final Color bgColor;
  final void Function() onTap;
  final IconData icon;
  final String tooltip;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry innerPadding;
  final Color? borderColor;
  final bool hasBorderLining;

  ActionButton({
    Key? key,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
    required this.icon,
    required this.tooltip,
    this.borderColor,
    this.hasBorderLining = true,
    this.padding = const EdgeInsets.only(right: 12.0),
    this.innerPadding = const  EdgeInsets.all(4.0),
  }) : super(key: key);

  late final _tooltipKey = GlobalKey<TooltipState>(debugLabel: 'action-button-tooltip-[$tooltip][${key.toString()}]');
  @override
  Widget build(BuildContext context) {
    ///
    return Tooltip(
      key: _tooltipKey,
      message: tooltip,
      showDuration: const Duration(seconds: 5),
      child: Padding(
        padding: padding,
        child: Container(
          height: 49.0,
          width: 49.0,
          padding: innerPadding,
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                  color: borderColor ?? ((bgColor == Colors.white) ? neutralGrey : const Color(0xFFC5FFEE)),
                  width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: neutralGrey,
                )
              ]),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerifiedBackButton extends StatelessWidget {
  final void Function() onTap;
  final bool isLight;

  const VerifiedBackButton({
    super.key,
    required this.onTap,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ActionButton(
            key: ValueKey('action-btn-${key.toString()}'),
            tooltip: 'Go Back',
            iconColor: isLight ? Colors.black : Colors.white,
            bgColor: isLight ? Colors.white : darkerPrimaryColor,
            onTap: onTap,
            borderColor: isLight ? const Color.fromARGB(70, 237, 237, 237) : null,
            icon: Icons.arrow_back_ios_new_rounded,
            padding: const EdgeInsets.all(0.0),
          ),
        ),
      ],
    );
  }
}
