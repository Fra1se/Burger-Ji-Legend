import 'package:flutter/material.dart';
//...packages

import '../widgets/cart_button.dart';
import '../widgets/home_button.dart';
import '../widgets/product_detail_item.dart';
//...widgets

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          CartButton(),
          HomeButton(),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: ProductDetailItem(),
          ),
        ],
      ),
    );
  }
}
