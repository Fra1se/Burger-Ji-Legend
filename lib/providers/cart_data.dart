import 'dart:convert';
import 'package:burger_ji_legend/providers/restaurant_data.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
//...packages

import '../models/cart.dart';
//...providers

class Carts with ChangeNotifier {
  bool isInit = true;

  final List<Cart> _items = [];

  List<Cart> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  double get totalProductSum {
    var total = 0.0;
    for (var cartItem in _items) {
      total += cartItem.cartPrice * cartItem.cartQuantity;
    }
    return total;
  }

  double deliverySum = 0;
  double taxSum = 0;
  String? distance;

  double get totalPrice {
    return deliverySum + totalProductSum;
  }

  void setQuotations({
    required String getDelivery,
    required String getDistance,
  }) {
    deliverySum = double.parse(getDelivery);
    distance = getDistance;
    totalPrice;
  }

  void clearQuotations() {
    deliverySum = 0;
    taxSum = 0;
    distance = null;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/cart.txt');
  }

  Future<dynamic> readItems() async {
    try {
      final file = await _localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return null;
    }
  }

  Future<void> receiveItems(
    BuildContext context,
  ) async {
    final data = await readItems().onError((error, stackTrace) => null);

    if (data != null) {
      final extractedData = json.decode(data) as List<dynamic>?;
      var resId;

      if (extractedData != null) {
        _items.addAll(
          extractedData.map((value) {
            resId = value['restaurantId'];
            return Cart(
              restaurantId: value['restaurantId'],
              productId: value['productId'],
              cartId: value['cartId'],
              cartTitle: value['cartTitle'],
              variationTitle: value['variationTitle'],
              cartQuantity: value['cartQuantity'],
              cartPrice: value['cartPrice'],
              cartSpecialRequests: value['cartSpecialRequests'],
            );
          }),
        );
      }

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm'),
            content: const Text(
              'Remove Previous Order?',
            ),
            actions: [
              TextButton(
                child: const Text('YES'),
                onPressed: () async {
                  Provider.of<Restaurants>(context, listen: false).setResId = resId;
                  final nav = Navigator.of(context);
                  await clearAllItems(context);
                  nav.pop();
                },
              ),
              TextButton(
                child: const Text('NO'),
                onPressed: () async {
                  Provider.of<Restaurants>(context, listen: false).setResId = resId;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> addItem({
    required String restaurantId,
    required String productId,
    required String id,
    required double price,
    required String title,
    required List<String>? variationTitle,
    required int quantity,
    String? specialRequests,
  }) async {
    final file = await _localFile;

    _items.add(
      Cart(
        restaurantId: restaurantId,
        productId: productId,
        cartId: id,
        cartTitle: title,
        variationTitle: variationTitle,
        cartQuantity: quantity,
        cartPrice: price,
        cartSpecialRequests: specialRequests == null || specialRequests == '' ? '' : specialRequests,
      ),
    );

    List<Map<dynamic, dynamic>> cartData = [];

    cartData = _items
        .map(
          (value) => {
            'restaurantId': value.restaurantId,
            'productId': value.productId,
            'cartId': value.cartId,
            'cartTitle': value.cartTitle,
            'variationTitle': value.variationTitle,
            'cartPrice': value.cartPrice,
            'cartQuantity': value.cartQuantity,
            'cartSpecialRequests': value.cartSpecialRequests,
          },
        )
        .toList();

    await file.writeAsString(
      json.encode(cartData),
    );

    notifyListeners();
  }

  Future<void> removeItem(
    String cartId,
    BuildContext context,
  ) async {
    final file = await _localFile;

    _items.removeWhere(
      (element) => element.cartId == cartId,
    );
    if (_items.isEmpty) {
      await file.delete();
    } else {
      List<Map<dynamic, dynamic>> cartData = [];

      cartData = _items
          .map(
            (value) => {
              'restaurantId': value.restaurantId,
              'productId': value.productId,
              'cartId': value.cartId,
              'cartTitle': value.cartTitle,
              'cartPrice': value.cartPrice,
              'cartQuantity': value.cartQuantity,
              'cartSpecialRequests': value.cartSpecialRequests,
            },
          )
          .toList();

      await file.writeAsString(
        json.encode(cartData),
      );
    }

    notifyListeners();
  }

  Future<void> clearAllItems(BuildContext context) async {
    final file = await _localFile;

    bool directoryExists = await file.exists();

    if (directoryExists) {
      try {
        await file.delete();
      } catch (error) {
        rethrow;
      }
    }

    _items.clear();
    clearQuotations();
    notifyListeners();
  }
}
