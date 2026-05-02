import 'package:flutter/material.dart';
//...packages

import '../widgets/order_item.dart';
//...widgets

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  static const routeName = '/order-screen';
  @override
  Widget build(BuildContext context) {
    //...

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        appBar: AppBar(
          title: const Text(
            'Order Now',
          ),
        ),
        body: const Column(
          children: [
            OrderItem(),
          ],
        ),
      ),
    );
  }
}
