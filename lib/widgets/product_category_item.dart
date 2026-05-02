import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../models/product_category.dart';
//...models

import '../providers/product_category_data.dart';
//...providers

import '../screens/product_screen.dart';
//...screens

class ProductCategoryItem extends StatelessWidget {
  const ProductCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    final productCategory = Provider.of<ProductCategory>(context, listen: false);

    Provider.of<ProductCategories>(context);
    //...Providers

    const restaurantId = 'ojas-satti-sorru';
    //...RouteArgs

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductScreen.routeName,
            arguments: {
              'restaurantId': restaurantId,
              'productCatId': productCategory.productCatId,
              'productCatTitle': productCategory.productCatTitle,
              'productCatChTitle': productCategory.productCatChTitle,
            },
          );
        },
        child: Row(
          children: [
            Container(
              child: productCategory.productCatImageUrl == ''
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
                          imageUrl: productCategory.productCatImageUrl,
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
                      productCategory.productCatTitle,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 1),
                    productCategory.productCatChTitle == ''
                        ? const SizedBox.shrink()
                        : Text(
                            productCategory.productCatChTitle,
                            style: const TextStyle(fontSize: 14),
                          ),
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
