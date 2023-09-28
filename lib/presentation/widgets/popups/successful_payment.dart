import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/dotted_line.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';

class SuccessfulPaymentModal extends StatefulWidget {
  const SuccessfulPaymentModal({super.key});

  /// convert to stateless and use a confetti with Bloc
  @override
  State<SuccessfulPaymentModal> createState() => _SuccessfulPaymentModalState();
}

class _SuccessfulPaymentModalState extends State<SuccessfulPaymentModal> {
  ///
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();

    _controllerCenter = ConfettiController(
      duration: const Duration(seconds: 10),
    )..play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500.0,
              minWidth: 400.0,
              maxHeight: 550.0,
            ),
            padding: primaryPadding,
            margin: primaryPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  const _Polygon8(),

                  ///header for the explainer
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        const Text(
                          "Payment Success",
                          style: TextStyle(
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
                            "Your payment for Verified has been successfully done",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      children: [
                        Text(
                          "Total payment",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: neutralDarkGrey,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          r"$15,901",
                          style: GoogleFonts.dmSans(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.right,
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: DottedLine(
                      color: neutralDarkGrey,
                    ),
                  ),

                  ListItemBanner(
                    type: BannerType.promotion,
                    bgColor: neutralGrey,
                    leadingIcon: Icons.rocket_launch_outlined,
                    leadingBgColor: primaryColor,
                    title: 'TItLe',
                    subtitle: "Subtttitle",
                    onTap: () {},
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: BaseButton(
                      key: UniqueKey(),
                      onTap: () => Navigator.pop(context),
                      label: "Done",
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

        /// confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
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
                Icons.close_outlined,
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
