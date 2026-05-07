import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/product_category_data.dart';
//...providers

import '../widget_lists/product_category_list.dart';
import '../widgets/cart_button.dart';
import '../widgets/home_button.dart';
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
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final restaurantTitle = routeArgs['restaurantTitle'];

    Future<void> refreshItems() async {
      Provider.of<ProductCategories>(context, listen: false).fetchItems().catchError((error) {
        (error);
      });
    }
    //...

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: !isSearching
            ? const Text(
                '',
              )
            : SizedBox(
                height: 35,
                child: TextField(
                  autofocus: true,
                  controller: _searchTextController,
                  textInputAction: TextInputAction.search,
                  cursorColor: Colors.black,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Search...',
                    contentPadding: const EdgeInsets.only(
                      bottom: 11,
                      left: 8,
                    ),
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                          _searchTextController.text = '';
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
        actions: [
          if (!isSearching)
            (IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            )),
          const CartButton(),
          const HomeButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshItems,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Wrap(
                  spacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        restaurantTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<ProductCategories>(context, listen: false).fetchItems(),
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
      ),
    );
  }
}
