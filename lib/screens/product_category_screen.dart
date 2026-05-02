import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/product_category_data.dart';
//...providers

import '../widget_lists/icon_row.dart';
import '../widget_lists/product_category_list.dart';
//...widgets

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  static const routeName = '/product-category-screen';

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  bool isSearching = false;

  final TextEditingController _searchTextController = TextEditingController();

  //...
  @override
  Widget build(BuildContext context) {
    Future<void> refreshItems() async {
      Provider.of<ProductCategories>(context, listen: false)
          .fetchItems()
          .catchError((error) {
        (error);
      });
    }
    //...

    return RefreshIndicator(
      onRefresh: refreshItems,
      child: Column(
        children: [
          const IconRow(),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<ProductCategories>(context, listen: false)
                  .fetchItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.error != null) {
                  return Center(
                    child: Text(
                      'Sorry there was an error :( ${snapshot.error.toString()}',
                    ),
                  );
                } else {
                  return ProductCategoryListView(
                    searchText: _searchTextController.text,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
