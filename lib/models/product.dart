import 'package:flutter/material.dart';

class ProductVariations {
  String title;
  double price;

  bool? isOut;

  ProductVariations({
    required this.title,
    required this.price,
    required this.isOut,
  });
}

class Product with ChangeNotifier {
  List<String> productCategoryId;
  String productTitle;
  String productChTitle;
  String productPrice;
  double productRawPrice;
  String productId;
  String productImageUrl;
  int productServeAmount;
  int? productOrderMins;
  int? productOrderHours;
  String productExtraInfo;

  bool? isOut;

  Map<String, dynamic>? variations;

  Product({
    required this.productCategoryId,
    required this.productTitle,
    required this.productChTitle,
    required this.productPrice,
    required this.productRawPrice,
    required this.productId,
    required this.productImageUrl,
    required this.productExtraInfo,
    required this.productServeAmount,
    required this.productOrderMins,
    required this.productOrderHours,
    required this.isOut,
    required this.variations,
  });
}
