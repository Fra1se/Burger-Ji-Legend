import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/product_category_data.dart';
//...providers

import '../widgets/product_category_item.dart';
//...widgets

class ProductCategoryListView extends StatelessWidget {
  final String searchText;

  const ProductCategoryListView({
    this.searchText = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const restaurantId = 'ojas-satti-sorru';
    //...RouteArgs

    final productCatDisplayedItems = Provider.of<ProductCategories>(context).displayedItems(
      restaurantId,
      searchText,
    );
    //...Providers

    final scrollBarController = ScrollController();
    //...

    return productCatDisplayedItems.isEmpty
        ? const Center(
            child: Text('Nothing Here'),
          )
        : RawScrollbar(
            controller: scrollBarController,
            thickness: 5,
            thumbColor: Theme.of(context).colorScheme.secondary,
            radius: const Radius.circular(5),
            thumbVisibility: true,
            child: ListView.separated(
              controller: scrollBarController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              separatorBuilder: (ctx, i) => Divider(
                color: Theme.of(context).colorScheme.shadow,
                height: 1,
                thickness: 1,
                endIndent: 15,
                indent: 5,
              ),
              itemCount: productCatDisplayedItems.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: productCatDisplayedItems[i],
                child: const ProductCategoryItem(),
              ),
            ),
          );
  }
}
