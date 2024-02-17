import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/dotted_line.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class FailedPaymentModal extends StatefulWidget {
  const FailedPaymentModal({super.key});

  /// convert to stateless and use a confetti with Bloc
  @override
  State<FailedPaymentModal> createState() => _FailedPaymentModalState();
}

class _FailedPaymentModalState extends State<FailedPaymentModal> {
  ///

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: appConstraints.maxWidth,
              minWidth: 400.0,
              maxHeight: 380.0,
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
                          'Payment Failed',
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
                            'We\'re sorry, but something went wrong.\nPlease check all your payment info \nand let\'s try again.',
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         'Total payment',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.w400,
                  //           color: neutralDarkGrey,
                  //           fontSize: 14.0,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       Text(
                  //         r'$15,901',
                  //         style: GoogleFonts.dmSans(
                  //           fontSize: 24.0,
                  //           fontWeight: FontWeight.w700,
                  //           fontStyle: FontStyle.normal,
                  //         ),
                  //         textAlign: TextAlign.right,
                  //       )
                  //     ],
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: DottedLine(
                      color: neutralDarkGrey,
                    ),
                  ),

                  // ListItemBanner(
                  //   type: BannerType..er,
                  //   bgColor: neutralGrey,
                  //   leadingIcon: Icons.rocket_launch_outlined,
                  //   leadingBgColor: Colors.red.shade600,
                  //   title: 'TItLe',
                  //   subtitle: 'Subtttitle',
                  //   onTap: () {},
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: BaseButton(
                      key: UniqueKey(),
                      onTap: () => Navigator.pop(context),
                      label: 'Try Again',
                      color: neutralGrey,
                      hasIcon: false,
                      bgColor: errorColor,
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
      ],
    );
  }

  @override
  void dispose() {
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
              PolygonBoxShadow(color: errorColor, elevation: 1.0),
              PolygonBoxShadow(color: Colors.grey, elevation: 1.0)
            ],
            child: Container(
              color: errorColor,
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
              color: const Color.fromARGB(255, 255, 217, 217),
              child: Icon(
                Icons.close_outlined,
                color: errorColor,
                size: 54.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
