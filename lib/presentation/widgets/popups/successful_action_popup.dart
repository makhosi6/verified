import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/dotted_line.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class SuccessfulActionModal extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback nextAction;
  final Widget? promoBanner;
  final bool showDottedDivider;
  final List<Widget>? children;
  const SuccessfulActionModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.nextAction,
     this.showDottedDivider = true,
    this.promoBanner,
    this.children,
  });

  @override
  State<SuccessfulActionModal> createState() => _SuccessfulActionModalState();
}

class _SuccessfulActionModalState extends State<SuccessfulActionModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: appConstraints.maxWidth,
        minWidth: 400.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: appConstraints.maxWidth,
              minWidth: 400.0,
            ),
            padding: primaryPadding,
            margin: primaryPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _Polygon8(),

                /// header for the explainer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: neutralDarkGrey,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                ///
                ...(widget.children ?? []),

                ///divider
               if(widget.showDottedDivider) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DottedLine(
                    color: neutralDarkGrey,
                  ),
                ),

                ///
                (widget.promoBanner ?? const SizedBox.shrink()),

                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: BaseButton(
                    key: UniqueKey(),
                    onTap: widget.nextAction,
                    label: 'Done',
                    color: neutralGrey,
                    hasIcon: false,
                    bgColor: primaryColor,
                    buttonIcon: Icon(
                      Icons.lock_outline,
                      color: primaryColor,
                    ),
                    buttonSize: ButtonSize.large,
                    hasBorderLining: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Polygon8 extends StatelessWidget {
  const _Polygon8();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ///
        SizedBox(
          width: 100.0,
          child: ClipPolygon(
            sides: 8,
            borderRadius: 8.0,
            rotate: 90.0,
            boxShadows: [
              PolygonBoxShadow(color: darkerPrimaryColor, elevation: 1.0),
              PolygonBoxShadow(color: Colors.grey, elevation: 1.0)
            ],
            child: Container(
              color: darkerPrimaryColor,
              width: 30.0,
              height: 30.0,
            ),
          ),
        ),

        ///
        SizedBox(
          width: 80.0,
          child: ClipPolygon(
            sides: 8,
            borderRadius: 8.0,
            rotate: 90.0,
            boxShadows: const [],
            child: Container(
              color: neutralYellow,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 54.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
