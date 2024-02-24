import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/payments/payments_bloc.dart';
import 'package:verified/helpers/currency.dart';
import 'package:verified/presentation/pages/loading_page.dart';
import 'package:verified/presentation/pages/webviews/the_webview.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/popups/failed_payment_popup.dart';
import 'package:verified/presentation/widgets/popups/successful_payment_popup.dart';

class PaymentPage extends StatelessWidget {
  final String? paymentUrl;
  const PaymentPage({super.key, this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    final url = context.watch<PaymentsBloc>().state.paymentData?.redirectUrl ?? paymentUrl;
    final amount = context.watch<PaymentsBloc>().state.paymentData?.amount ?? 0;
    final currency = context.watch<PaymentsBloc>().state.paymentData?.currency ?? 'R';

    if (url == null) {
      return const LoadingPage(
        noScaffold: false,
      );
    }

    return TheWebView(
      hasBackBtn: false,
      webURL: url,
      onPageCancelled: () {
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
      onPageSuccess: () {
        /// go back
        Navigator.of(context).pop();

//and show a success popup
        showDialog(
          context: context,
          builder: (context) => SuccessfulPaymentModal(
            topUpAmount: formatCurrency(amount, currency),
          ),
        );
      },
      onPageFailed: () {
        showDialog(
          context: context,
          builder: (context) => const FailedPaymentModal(),
        );
      },
    );
  }
}
