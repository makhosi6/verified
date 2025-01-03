import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/payments/payments_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/payment_checkout_request.dart';
import 'package:verified/domain/models/payment_metadata.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/helpers/logger.dart';
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

  num parsedAmount = 15000;

  num minimumPayment = 3000;

  late var inputController = TextEditingController(text: selectedAmount);

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
                    'Get started with a minimum top-up of just R30 (one transaction)',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: neutralDarkGrey,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
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
                      try {
                        Form.of(primaryFocus!.context ?? context).save();
                      } catch (error, stackTrace) {
                        verifiedErrorLogger(error, stackTrace);
                      }
                    },
                    child: TextFormField(
                      key: const Key('currency-input'),
                      keyboardType: TextInputType.number,
                      controller: inputController,
                      inputFormatters: <TextInputFormatter>[
                        CurrencyTextInputFormatter.currency(
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
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      onTapOutside: (_) {
                        final amount = inputController.value.text;

                        ///
                        final intValue = int.parse(amount.split('.').join('').replaceAll(',', '').replaceAll('R', ''));

                        ///
                        if (mounted) {
                          /// delay til build/frame is done
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            /// then set state
                            setState(() {
                              parsedAmount = intValue;
                            });
                          });
                        }
                      },
                      validator: (amount) {
                        try {
                          if (amount == null || amount.isEmpty) {
                            return 'Please select/type a valid top-up amount.';
                          }
                          final intValue =
                              int.parse(amount.split('.').join('').replaceAll(',', '').replaceAll('R', ''));

                          if (intValue < minimumPayment) {
                            return 'R 30.00 is the minimum deposit amount required.';
                          }

                          if (mounted) {
                            /// delay til build/frame is done
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              /// then set state
                              setState(() {
                                parsedAmount = intValue;
                              });
                            });
                          }

                          return null;
                        } catch (error, stackTrace) {
                          verifiedErrorLogger(error, stackTrace);
                          return null;
                        }
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
                          inputController.value = inputController.value.copyWith(text: 'R $amount.00');

                          /// delay til build/frame is done
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            /// then set state
                            setState(() {
                              selectedAmount = 'R $amount.00';
                              parsedAmount = int.parse('${amount}00');
                            });
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
                    final user = context.read<StoreBloc>().state.userProfileData ?? UserProfile.empty;
                    final wallet = context.read<StoreBloc>().state.walletData;

                    ///
                    context.read<PaymentsBloc>().add(
                          PaymentsEvent.yocoPayment(
                            PaymentCheckoutRequest(
                              currency: 'ZAR',
                              amount: parsedAmount,
                              successUrl: 'https://verified.byteestudio.com/success',
                              cancelUrl: 'https://verified.byteestudio.com/cancelled',
                              failureUrl: 'https://verified.byteestudio.com/failed',
                              metadata: PaymentMetadata(
                                walletId: wallet?.id ?? user.walletId,
                                payerId: user.id,
                                env: user.env,
                              ),
                            ),
                          ),
                        );

                    /// hide top-up bottom-sheet
                    Navigator.of(context).pop();

                    /// navigate to payment webview
                    navigate(context, page: const PaymentPage(paymentUrl: null));
                  }

                  log('THERE THERE HERE $parsedAmount');
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
