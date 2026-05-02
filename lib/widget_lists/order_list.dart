import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/cart_data.dart';
//...providers

class OrderList extends StatelessWidget {
  final bool isList;

  const OrderList({
    this.isList = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(
      context,
      listen: false,
    );
    //...Providers

    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (ctx, i) => Divider(
            color: Theme.of(context).colorScheme.shadow,
            height: 0,
            thickness: 1,
          ),
          itemCount: cart.items.length,
          itemBuilder: (context, i) => Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cart.items[i].cartTitle),
                if (cart.items[i].variationTitle != null)
                  for (var i in cart.items[i].variationTitle!)
                    Text(
                      i,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF686868),
                      ),
                    ),
                const SizedBox(height: 2.5),
                if (cart.items[i].cartSpecialRequests != null && cart.items[i].cartSpecialRequests != '') Text(cart.items[i].cartSpecialRequests!),
                const SizedBox(height: 2.5),
                Row(
                  children: [
                    Text('MYR ${cart.items[i].cartPrice.toStringAsFixed(2)} x ${cart.items[i].cartQuantity}'),
                    const Spacer(),
                    Text('MYR ${(cart.items[i].cartPrice * cart.items[i].cartQuantity).toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.shadow,
          height: 0,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Price :',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    cart.totalProductSum.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tax : (6%)',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    cart.taxSum.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price :',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'MYR ${cart.totalProductSum.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
