import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/payments/payments_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/wallet.dart';
import 'package:verified/helpers/currency.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/pages/loading_page.dart';
import 'package:verified/presentation/pages/webviews/the_webview.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/lottie_loader.dart';
import 'package:verified/presentation/widgets/popups/failed_payment_popup.dart';
import 'package:verified/presentation/widgets/popups/successful_payment_popup.dart';

class PaymentPage extends StatelessWidget {
  final String? paymentUrl;
  const PaymentPage({super.key, this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<PaymentsBloc>().state.paymentData;
    final wallet = context.watch<StoreBloc>().state.walletData;
    final url = context.watch<PaymentsBloc>().state.paymentData?.redirectUrl ?? paymentUrl;
    final amount = context.watch<PaymentsBloc>().state.paymentData?.amount ?? 0;
    final currency = context.watch<PaymentsBloc>().state.paymentData?.currency ?? 'R';

    if (url == null) {
      return const Center(
        child: LottieProgressLoader(
          key: Key('app-splash-screen-loader-for-payments'),
        ),
      );
    }

    FirebaseAnalytics.instance.logBeginCheckout(
        value: checkout?.amount?.toDouble(),
        currency: checkout?.currency,
        items: [
          AnalyticsEventItem(
            itemName: 'TopUp',
            itemId: checkout?.metadata?.checkoutId,
            price: checkout?.amount?.toDouble(),
          ),
        ],
        coupon: 'TOPUP');

    return TheWebView(
      hasBackBtn: false,
      webURL: url,
      onPageCancelled: () {
            VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_ON_PAYMENT_CANCELLED);
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              showCloseIcon: true,
              closeIconColor: const Color.fromARGB(255, 254, 226, 226),
              content: const Text(
                'Payment cancelled! 🙁',
                style: TextStyle(
                  color: Color.fromARGB(255, 254, 226, 226),
                ),
              ),
              backgroundColor: errorColor,
            ),
          );

        /// then go back
        Navigator.of(context).pop();
      },
      onPageSuccess: (_) {
        VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_ON_SUCCESSFUL_PAYMENT);

        /// go back
        Navigator.of(context).pop();

        /// update local wallet
        context.read<StoreBloc>()
          ..add(
            StoreEvent.updateLocalWallet(
              Wallet(balance: (wallet?.balance) ?? 0 + amount),
            ),
          )
          ..add(
            StoreEvent.getWallet(
              context.read<StoreBloc>().state.userProfileData?.walletId ??
                  context.read<PaymentsBloc>().state.paymentData?.metadata?.walletId ??
                  'wltR_uid',
            ),
          );

        /// and show a success popup
        showDialog(
          context: context,
          barrierColor: darkBlurColor,
          builder: (context) => SuccessfulPaymentModal(
            topUpAmount: formatCurrency(amount, currency),
          ),
        );
      },
      onPageFailed: (_) {
        VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_ON_FAILED_PAYMENT);
        showDialog(
          context: context,
          builder: (context) => const FailedPaymentModal(),
        );
      },
    );
  }
}
