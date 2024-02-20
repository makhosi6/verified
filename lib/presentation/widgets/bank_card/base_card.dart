import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/wallet.dart';
import 'package:verified/helpers/currency.dart';
import 'package:verified/presentation/theme.dart';

class BaseBankCard extends StatelessWidget {
  final BankCardSize? size;

  const BaseBankCard({super.key, this.size});

  @override
  Widget build(BuildContext context) => BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          Wallet? wallet = state.walletData;

// get card provider name
          final scheme = (() {
            if (wallet?.cardProvider == 'mastercard' || wallet?.cardProvider == 'visa') {
              return wallet?.cardProvider;
            }
            return 'mastercard';
          })();

          ///
          return Container(
            padding: const EdgeInsets.all(16.0),
            constraints: const BoxConstraints(
              minWidth: 350.0,
              maxWidth: 600.0,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
                bottomRight: Radius.circular(size == BankCardSize.short ? 0 : 16.0),
                bottomLeft: Radius.circular(size == BankCardSize.short ? 0 : 16.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// first row [balance label & logo]
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance',
                      style: boldCardStyles.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/icons/$scheme.png'),
                      width: 45.0,
                      height: 28.0,
                    )
                  ],
                ),

                /// balance value in dollars/rands
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatCurrency(wallet?.balance ?? 0, wallet?.isoCurrencyCode),
                    textAlign: TextAlign.start,
                    style: boldCardStyles.copyWith(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                /// middle part - card number
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: size == BankCardSize.short ? 16.0 : .0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Image(
                        image: AssetImage('assets/icons/card-chip.png'),
                        width: 48.0,
                        height: 32.0,
                      ),
                      Padding(
                        padding: primaryPadding.copyWith(right: 0, left: 8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '**** **** ****',
                                style: boldCardStyles.copyWith(
                                  fontSize: 12.0,
                                  letterSpacing: 2.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              wallet?.accountName?.replaceAll('-', '').replaceAll('*', '') ?? '0000',
                              style: boldCardStyles,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                /// Name and date
                size != BankCardSize.short
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wallet?.accountHolderName ?? 'Name Surname',
                            style: boldCardStyles,
                          ),
                          Text(
                            wallet?.expDate ?? 'MM/YY',
                            style: boldCardStyles,
                          )
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          );
        },
      );
}

class DummyBankCard extends StatelessWidget {
  const DummyBankCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(80.0),
      margin: primaryPadding,
      constraints: const BoxConstraints(
        minWidth: 350.0,
      ),
      decoration: BoxDecoration(
        color: neutralYellow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
    );
  }
}

final boldCardStyles = GoogleFonts.ibmPlexMono(
  fontWeight: FontWeight.w500,
  fontStyle: FontStyle.normal,
  fontSize: 16.0,
  color: Colors.white,
);

enum BankCardSize { short, tall }
