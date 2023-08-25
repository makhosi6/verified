import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/theme.dart';
import 'package:verify_sa/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/widgets/chip/themed_chip.dart';

class SuggestedTopUp extends StatelessWidget {
  const SuggestedTopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///
                  const Text(
                    "Set Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Text(
                    "How much would you like to top up?",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: neutralDarkGrey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          ///

          Padding(
            padding: const EdgeInsets.only(bottom: 30.0, top: 12.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 320,
                  minWidth: 300.0,
                ),
                child: TextFormField(
                  key: const Key("currency-input"),
                  initialValue: r"R 120",
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    CurrencyTextInputFormatter(
                      symbol: "R ",
                    )
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  style: GoogleFonts.dmSans(
                    fontSize: 28.0,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Wrap(children: [
            ThemedChip(
              label: "R50",
              onTap: () {},
            ),
            ThemedChip(
              label: "R100",
              onTap: () {},
            ),
            ThemedChip(
              label: "Own Amount",
              onTap: () {},
            ),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: BaseButton(
              key: UniqueKey(),
              onTap: () {},
              label: "Top Up Now",
              color: Colors.white,
              hasIcon: false,
              bgColor: primaryColor,
              buttonIcon: Icon(
                Icons.lock_outline,
                color: primaryColor,
              ),
              buttonSize: ButtonSize.large,
              hasBorderLining: false,
            ),
          )
        ],
      ),
    );
  }
}
