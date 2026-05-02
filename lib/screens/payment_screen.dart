import 'package:flutter/material.dart';
//...packages

import '../widgets/payment_item.dart';
//...widgets

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment-screen';

  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: const Column(
        children: [
          Expanded(
            child: PaymentItem(),
          ),
        ],
      ),
    );
  }
}
