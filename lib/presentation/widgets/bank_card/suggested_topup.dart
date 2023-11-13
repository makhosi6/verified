import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/presentation/pages/webviews/payments.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/chip/themed_chip.dart';

class SuggestedTopUp extends StatefulWidget {
  const SuggestedTopUp({super.key});

  @override
  State<SuggestedTopUp> createState() => _SuggestedTopUpState();
}

class _SuggestedTopUpState extends State<SuggestedTopUp> {
  //
  final _formKey = GlobalKey<FormState>();
  //
  String selectedAmount = 'R 150.00';

  num minimumPayment = 30;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: primaryPadding,
        constraints: const BoxConstraints(
          minWidth: 600.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///
                  const Text(
                    'Top Up',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  Text(
                    'How much would you like to top up?',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: neutralDarkGrey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      Form.of(primaryFocus!.context!).save();
                    },
                    child: TextFormField(
                      key: const Key('currency-input'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: selectedAmount),
                      inputFormatters: <TextInputFormatter>[
                        CurrencyTextInputFormatter(
                          symbol: 'R ',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select/type a valid top-up amount.';
                        }
                        final intValue = int.parse(value.split('.')[0].replaceAll('R', ''));
                        if (intValue < minimumPayment) {
                          return 'R $minimumPayment.00 is the minimum deposit amount required.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ),
            Wrap(
              children: ['50', '100', '200']
                  .map(
                    (amount) => ThemedChip(
                      key: Key(amount),
                      label: amount,
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            selectedAmount = 'R $amount.00';
                          });
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
              child: BaseButton(
                key: const Key('top-up-button'),
                onTap: () {
                  ///
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    ///
                    FocusScope.of(context).unfocus();

                    ///
                    Navigator.of(context).pop(selectedAmount);

                    ///
                    const stripeLink = 'https://buy.stripe.com/test_fZe17u02K7xx1TG6oo';

                    navigate(context, page: const PaymentPage(paymentUrl: stripeLink));
                  }
                },
                label: 'Continue',
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
      ),
    );
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
