import 'package:flutter/material.dart';
import '../models/product.dart';

class Variations with ChangeNotifier {
  ProductVariations? baseValue;
  Map<String, ProductVariations?> extraValues = {};

  List<double> get extraPrice {
    return extraValues.values.map((e) => e!.price).toList();
  }

  List<String> get extraTitle {
    return extraValues.values.map((e) => e!.title).toList();
  }

  double get totalPrice => (baseValue?.price ?? 0) + (extraPrice.isEmpty ? 0 : extraPrice.reduce((v, e) => v + e));
  List<String> get totalTitle {
    if (baseValue != null) {
      List<String> list = [];
      list = extraTitle;
      list.insert(0, baseValue!.title);
      return list;
    } else {
      return extraTitle;
    }
  }

  set setBaseValue(ProductVariations? value) => baseValue = value;
  set setExtraValue(Map<String, ProductVariations?> map) {
    if (map.entries.first.value == null) {
      extraValues.removeWhere((key, value) => key == map.keys.first);
    } else {
      extraValues.addAll(map);
    }
  }

  void notify() {
    notifyListeners();
  }

  void disposeValues() {
    baseValue = null;
    extraValues = {};
  }
}
