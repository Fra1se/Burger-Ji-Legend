import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//...packages

import '../models/product.dart';
//...models

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchItems() async {
    Uri url = Uri.parse('https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedItems = [];

      extractedData.forEach(
        (id, item) {
          Map<String, dynamic> catIdMap = item['catId'];
          List<String> catIdList = [];

          catIdMap.forEach(
            (key, value) {
              catIdList.add(value);
            },
          );

          try {
            loadedItems.add(
              Product(
                productId: id,
                productCategoryId: catIdList,
                productTitle: item['title'],
                productChTitle: item['chTitle'],
                productPrice: item['price'],
                productRawPrice: double.parse(item['rawPrice']),
                productImageUrl: item['imageUrl'],
                productServeAmount: item['servings'],
                productOrderMins: item['orderMins'],
                productOrderHours: item['orderHours'],
                productExtraInfo: item['extraInfo'],
                isOut: item['isOut'],
                variations: item['variations'] == null
                    ? null
                    : {
                        'base': item['variations']['base'] == null
                            ? null
                            : {
                                "title": item['variations']['base']['title'],
                                "list": (item['variations']['base']['list'] as List<dynamic>)
                                    .map(
                                      (e) => ProductVariations(
                                        title: e['title'],
                                        price: double.parse(e['price']),
                                        isOut: e['isOut'] as bool,
                                      ),
                                    )
                                    .toList(),
                              },
                        'extra': item['variations']['extra'] == null
                            ? null
                            : (item['variations']['extra'] as List<dynamic>)
                                .map(
                                  (extra) => {
                                    'title': extra['title'],
                                    'isSingle': extra['isSingle'],
                                    'isRequired': extra['isRequired'],
                                    'list': (extra['list'] as List<dynamic>)
                                        .map(
                                          (e) => ProductVariations(
                                            title: e['title'],
                                            price: double.parse(e['price']),
                                            isOut: e['isOut'],
                                          ),
                                        )
                                        .toList(),
                                  },
                                )
                                .toList(),
                      },
              ),
            );
          } catch (error) {
            return;
          }
        },
      );

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.productId == id);
  }

  List<Product> displayedItems(
    String id,
    String title,
  ) {
    List<Product> productById() {
      return items.where(
        (product) {
          return product.productCategoryId.contains(id);
        },
      ).toList();
    }

    List<Product> productByTitle() {
      return productById().where(
        (product) {
          return product.productTitle.toLowerCase().contains(
                title.toLowerCase(),
              );
        },
      ).toList();
    }

    return productByTitle();
  }
}
