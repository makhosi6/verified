import 'package:flutter/material.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/widgets/bank_card/suggested_topup.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Top Up Page'),
      ),
    );
  }
}

Future showTopUpBottomSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: appConstraints,
          padding: const EdgeInsets.only(top: 20.0),
          child: const SuggestedTopUp(),
        ),
      ),
    );
