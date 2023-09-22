// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/theme.dart';

class ActionButton extends StatelessWidget {
  final Color iconColor;
  final Color bgColor;
  final void Function() onTap;
  final IconData icon;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final bool hasBorderLining;

  const ActionButton({
    Key? key,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
    required this.icon,
    this.borderColor,
    this.hasBorderLining = true,
    this.padding = const EdgeInsets.only(right: 12.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        height: 49.0,
        width: 49.0,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: borderColor ??
                    ((bgColor == Colors.white)
                        ? neutralGrey
                        : const Color(0xFFC5FFEE)),
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
            iconColor: isLight ? Colors.black : Colors.white,
            bgColor: isLight ? Colors.white : darkerPrimaryColor,
            onTap: onTap,
            icon: Icons.arrow_back_ios_new_rounded,
            padding: const EdgeInsets.all(0.0),
          ),
        ),
      ],
    );
  }
}
