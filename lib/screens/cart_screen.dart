import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/order_data.dart';
import '../providers/restaurant_data.dart';
import '../providers/cart_data.dart';
//...providers

import 'tabs_screen.dart';
import 'order_screen.dart';
//...screens

import '../widgets/home_button.dart';
import '../widgets/cart_item.dart';
//...widgets

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Carts>(context);
    //...Providers

    final scrollBarController = ScrollController();
    //...

    Provider.of<Orders>(context, listen: false).receiveDetails();

    Widget buttonBuilder({
      required IconData icon,
      required String text,
      required Color color,
      required Color onColor,
      required void Function() onPressed,
    }) {
      return SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
              color,
            ),
          ),
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: onColor,
            size: 18,
          ),
          label: Text(
            text,
            style: TextStyle(
              color: onColor,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    //...

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('My Cart'),
        actions: const [
          HomeButton(),
        ],
      ),
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        'MYR ${cart.totalProductSum.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: RawScrollbar(
              controller: scrollBarController,
              thickness: 5,
              thumbColor: Theme.of(context).colorScheme.secondary,
              radius: const Radius.circular(5),
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollBarController,
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5),
                        child: Text('Details'),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, i) {
                          final cartItem = cart.items.reversed.toList()[i];
                          return CartItem(
                            productId: cartItem.productId,
                            restaurantId: cartItem.restaurantId,
                            id: cartItem.cartId,
                            price: cartItem.cartPrice,
                            quantity: cartItem.cartQuantity,
                            title: cartItem.cartTitle,
                            variationTitle: cartItem.variationTitle,
                            specialRequests: cartItem.cartSpecialRequests,
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 6,
                          right: 6,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          children: [
                            Consumer<Restaurants>(
                              builder: (context, restaurant, child) {
                                  return buttonBuilder(
                                  color: Theme.of(context).colorScheme.primary,
                                  onColor: Theme.of(context).colorScheme.onPrimary,
                                    icon: Icons.add_circle_outline_rounded,
                                    text: 'Add More Orders',
                                    onPressed: () async {
                                    Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
                                    },
                                  );
                              },
                            ),
                            buttonBuilder(
                              icon: Icons.clear,
                              text: 'Remove All Orders',
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              onColor: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              onPressed: () {
                                if (cart.items.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text('There Is No Order'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'OK',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Confirm',
                                      ),
                                      content: const Text('Remove All Orders?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            cart.clearAllItems(context);

                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'YES',
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'NO',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                            buttonBuilder(
                              icon: Icons.access_alarms,
                              text: 'Order Now',
                              color: Theme.of(context).colorScheme.primary,
                              onColor: Theme.of(context).colorScheme.onPrimary,
                              onPressed: () async {
                                if (cart.items.isEmpty) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text('There Is No Order'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'OK',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => PopScope(
                                    onPopInvokedWithResult: (_, __) =>
                                        Future.value(false),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );

                                final nav = Navigator.of(context);
                                final restaurant = Provider.of<Restaurants>(
                                  context,
                                  listen: false,
                                );

                                try {
                                  await restaurant.receiveItems();
                                } catch (error) {
                                  nav.pop();
                                  return;
                                }

                                bool? isClosed = restaurant
                                    .findById(cart.items[0].restaurantId)
                                    .isClosed;
                                if (isClosed == true) {
                                  nav.pop();
                                  if (context.mounted) {
                                    return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Closed'),
                                        content: const Text(
                                          'Merchant is Now Closed',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              nav.pop();
                                            },
                                            child: const Text(
                                              'OK',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }

                                nav.popAndPushNamed(OrderScreen.routeName);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
