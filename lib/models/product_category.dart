import 'package:flutter/material.dart';
//...packages

class ProductCategory with ChangeNotifier {
  List<String> restaurantId;
  String productCatTitle;
  String productCatChTitle;
  String productCatId;
  String productCatImageUrl;

  ProductCategory({
    required this.restaurantId,
    required this.productCatTitle,
    required this.productCatChTitle,
    required this.productCatId,
    required this.productCatImageUrl,
  });
}