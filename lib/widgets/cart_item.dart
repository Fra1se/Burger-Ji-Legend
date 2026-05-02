import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/cart_data.dart';
//...providers

//...screens

class CartItem extends StatelessWidget {
  final String productId;
  final String restaurantId;
  final String id;
  final double price;
  final int quantity;
  final String title;
  final List<dynamic>? variationTitle;
  final String? specialRequests;

  const CartItem({
    required this.productId,
    required this.restaurantId,
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.variationTitle,
    required this.specialRequests,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Confirm'),
              content: const Text('Remove This Order?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    final nav = Navigator.of(context);
                    await Provider.of<Carts>(
                      context,
                      listen: false,
                    ).removeItem(id, context).catchError(
                      (error, stackTrace) {
                        return;
                      },
                    );
                    nav.pop();
                  },
                  child: const Text('YES'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('NO'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        Provider.of<Carts>(
          context,
          listen: false,
        ).removeItem(id, context).catchError(
          (error, stackTrace) {
            return;
          },
        );
      },
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 4,
        ),
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete_rounded,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      child: Card(
        elevation: 4,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 4,
        ),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 15),
                          softWrap: true,
                        ),
                        const SizedBox(height: 2.5),
                        if (variationTitle != null)
                          for (var i in variationTitle!)
                            Text(
                              i,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF686868),
                              ),
                            ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text('Remove This Order?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final nav = Navigator.of(context);
                                await Provider.of<Carts>(
                                  context,
                                  listen: false,
                                ).removeItem(id, context).catchError(
                                  (error, stackTrace) {
                                    return;
                                  },
                                );
                                nav.pop();
                              },
                              child: const Text('YES'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('NO'),
                            ),
                          ],
                        ),
                      );
                    },
                    iconSize: 20,
                    icon: const Icon(Icons.delete_rounded),
                  ),
                ],
              ),
              if (specialRequests != '' && specialRequests != null)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    specialRequests!,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(right: 11, top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'MYR ${price.toStringAsFixed(2)} x $quantity',
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'MYR ${(price * quantity).toStringAsFixed(2)}',
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
