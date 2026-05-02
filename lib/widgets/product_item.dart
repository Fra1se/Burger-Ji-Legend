import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../models/product.dart';
//...models

import '../providers/product_data.dart';
//...providers

import '../screens/product_detail_screen.dart';
//...screens

class ProductItem extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    Provider.of<Products>(context);
    //...Providers

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final restaurantId = routeArgs['restaurantId'];
    //...RouteArgs

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: {
              'restaurantId': restaurantId,
              'productId': product.productId,
              'isOut': product.isOut,
            },
          );
        },
        child: Row(
          children: [
            Container(
              child: product.productImageUrl == ''
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      color: Colors.white,
                      height: 93.33,
                      width: 140,
                      child: const Center(
                        child: Text('Empty ):'),
                      ),
                    )
                  : FittedBox(
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: CachedNetworkImage(
                          imageUrl: product.productImageUrl,
                          fit: BoxFit.cover,
                          height: 93.33,
                          width: 140,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productTitle,
                      style: const TextStyle(fontSize: 14),
                    ),
                    product.productChTitle == ''
                        ? const SizedBox()
                        : Text(
                            product.productChTitle,
                            style: const TextStyle(fontSize: 14),
                          ),
                    Text('MYR ${product.productPrice}'),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: const Icon(Icons.arrow_left),
            ),
          ],
        ),
      ),
    );
  }
}
