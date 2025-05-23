import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/currency.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/theme.dart';

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    var wallet = context.watch<StoreBloc>().state.walletData;
    var user = context.watch<StoreBloc>().state.userProfileData;

    verifiedLogger('WALLET: ${wallet?.toJson()}\n\n');

    verifiedLogger('\n\nUSER${user?.toJson()}\n');
    return Container(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        top: 20.0,
      ),
      width: MediaQuery.of(context).size.width - 12,
      constraints: appConstraints,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //name
              Text(
                wallet?.accountHolderName ?? user?.displayName ?? user?.actualName ?? user?.name ?? 'Hello',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
              // subtitle
              Text(
                'Your available balance',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: neutralDarkGrey,
                  fontSize: 14.0,
                ),
              )
            ],
          ),
          //balance
          Text(
            formatCurrency(wallet?.balance ?? 0, wallet?.isoCurrencyCode),
            style: GoogleFonts.dmSans(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.right,
          )
        ],
      ),
    );
  }
}
