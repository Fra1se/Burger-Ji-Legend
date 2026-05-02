import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/cart_data.dart';
//...providers

import '../screens/cart_screen.dart';
//...screens

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName),
      icon: Consumer<Carts>(
        builder: (ctx, cart, ch) => Badge(
          isLabelVisible: cart.itemCount != 0,
          label: Text(cart.itemCount.toString()),
          alignment: const AlignmentDirectional(1.5, -2),
          child: const Icon(
            Icons.shopping_cart_rounded,
          ),
        ),
      ),
    );
  }
}
