import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//...packages

import '../models/product_category.dart';
//...models

class ProductCategories with ChangeNotifier {
  List<ProductCategory> _items = [];

  List<ProductCategory> get items {
    return [..._items];
  }

  Future<void> fetchItems() async {
    Uri url = Uri.parse(
        'https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/product-categories.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductCategory> loadedItems = [];

      extractedData.forEach(
        (id, item) {
          Map<String, dynamic> catIdMap = item['catId'];
          List<String> catIdList = [];

          catIdMap.forEach(
            (key, value) {
              catIdList.add(value);
            },
          );

          loadedItems.add(
            ProductCategory(
              productCatTitle: item['title'],
              productCatChTitle: item['chTitle'],
              productCatId: id,
              productCatImageUrl: item['imageUrl'],
              restaurantId: catIdList,
            ),
          );
        },
      );

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<ProductCategory> displayedItems(
    String id,
    String title,
  ) {
    List<ProductCategory> productCatByRestaurantId() {
      return items.where(
        (productCat) {
          return productCat.restaurantId.contains(id);
        },
      ).toList();
    }

    List<ProductCategory> productCatByTitle() {
      return productCatByRestaurantId().where((productCat) {
        return productCat.productCatTitle.toLowerCase().contains(
              title.toLowerCase(),
            );
      }).toList();
    }

    return productCatByTitle();
  }
}
