import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/product_data.dart';
//...providers

import '../widgets/product_item.dart';
//...widgets

class ProductListView extends StatelessWidget {
  final String searchText;
  const ProductListView({
    this.searchText = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final productCatId = routeArgs['productCatId'];
    //...RouteArgs

    final productDisplayedItems = Provider.of<Products>(context).displayedItems(
      productCatId,
      searchText,
    );
    //...Providers

    final scrollBarController = ScrollController();
    //...

    return productDisplayedItems.isEmpty
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
              itemCount: productDisplayedItems.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: productDisplayedItems[i],
                child: productDisplayedItems[i].isOut == true
                    ? ClipRRect(
                        child: Banner(
                          location: BannerLocation.topStart,
                          message: 'Out of Stock',
                          textStyle: const TextStyle(
                            fontSize: 10,
                          ),
                          child: ProductItem(),
                        ),
                      )
                    : ProductItem(),
              ),
            ),
          );
  }
}
