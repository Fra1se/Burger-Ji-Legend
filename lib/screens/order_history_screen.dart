import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/my_orders_data.dart';
//...providers

import '../widgets/order_history_item.dart';
//...widgets

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  static const routeName = '/order-history';

  @override
  Widget build(BuildContext context) {
    final scrollBarController = ScrollController();
    final orderData = Provider.of<MyOrders>(context, listen: false).items;

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orderData.isEmpty
          ? const Center(
              child: Text('No orders'),
            )
          : RawScrollbar(
              controller: scrollBarController,
              thickness: 5,
              thumbColor: Theme.of(context).colorScheme.secondary,
              radius: const Radius.circular(5),
              thumbVisibility: true,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ListView.builder(
                  controller: scrollBarController,
                  itemCount: orderData.length,
                  itemBuilder: (ctx, i) => OrderHistoryItem(
                    orderData.toList()[i],
                  ),
                ),
              ),
            ),
    );
  }
}
