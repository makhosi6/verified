// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:verify_sa/theme.dart';

class BaseButton extends StatelessWidget {
  /// width of the button
  final double? width;

  /// height of the button
  final double? height;

  /// text and icon color inside the widget
  final Color color;

  /// background  color of the widget
  final Color bgColor;

  /// background color of the icon area
  final Color? iconBgColor;

  /// flag to show and hide the left side icon of the button, usually branded
  final bool hasIcon;

  /// icon button show on the left side of the button, usually branded
  final Widget? buttonIcon;

  final bool hasBorderLining;

  /// weather the button should be large or small
  final ButtonSize buttonSize;

  final String label;

  final void Function() onTap;

  const BaseButton({
    Key? key,
    this.width,
    this.height,
    this.color = Colors.black,
    this.bgColor = Colors.white,
    this.iconBgColor,
    this.hasIcon = true,
    required this.buttonIcon,
    required this.hasBorderLining,
    required this.buttonSize,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(
          minWidth: width ?? (buttonSize == ButtonSize.small ? 140.0 : 300.0),
          maxWidth: width ?? (buttonSize == ButtonSize.small ? 164.0 : 350.0),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: bgColor,
          border: hasBorderLining
              ? Border.all(color: neutralGrey, width: 2.0)
              : null,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              if (hasIcon)
                Container(
                  height: 40.0,
                  width: 40.0,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: iconBgColor ?? neutralGrey,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: buttonIcon,
                  ),
                ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

enum ButtonSize { small, large }
