import 'package:flutter/material.dart';
//...packages

class RestaurantCategory with ChangeNotifier {
  String restaurantCatTitle;
  String restaurantCatChTitle;
  String restaurantCatId;
  String restaurantCatImageUrl;
  bool? isOutlet;
  String? restaurantCatState;

  RestaurantCategory({
    required this.restaurantCatTitle,
    required this.restaurantCatChTitle,
    required this.restaurantCatId,    
    required this.restaurantCatImageUrl,
    this.isOutlet,
    this.restaurantCatState,
  });
}
