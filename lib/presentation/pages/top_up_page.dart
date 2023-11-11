import 'package:flutter/material.dart';
import 'package:verified/presentation/widgets/bank_card/suggested_topup.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text('Top Up Page'),
        ),
      ),
    );
  }
}

Future showTopUpBottomSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 500.0,
          ),
          padding: const EdgeInsets.only(top: 20.0),
          child: const SuggestedTopUp(),
        ),
      ),
    );
