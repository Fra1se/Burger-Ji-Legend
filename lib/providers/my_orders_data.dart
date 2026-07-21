import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
//...packages

import '../models/cart.dart';
import '../models/order.dart';
//...providers

class MyOrders with ChangeNotifier {
  final List<Order> _items = [];
  List<Order> get items {
    return [..._items].reversed.toList();
  }

  List<Order> get shownItems {
    return items.where((e) => e.isRemoved != true).toList();
  }

  int get badgeItems {
    return shownItems.where((e) => e.isValidated != false).length;
  }

  Future<void> receiveMyOrders() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      Uri url = Uri.parse('https://us-central1-valueat-app.cloudfunctions.net/receiveMyOrders?text=$fcmToken');
      final response = await http.get(url);

      if (response.body.isEmpty || response.body == 'null') {
        return;
      } else {
        final data = (json.decode(response.body) as Map<String, dynamic>);
        _items.clear();
        data.forEach(
          (key, value) {
            _items.add(
              Order(
                resName: value['resName'],
                lalamoveShareLink: value['lalamoveShareLink'],
                specialRequests: value['specialRequests'],
                isValidated: value['isValidated'],
                isRain: value['isRain'],
                isRemoved: value['isRemoved'],
                orderId: key,
                userId: value['userId'],
                dateTime: DateTime.parse(value['timeStamp']),
                customerName: value['customerName'],
                orderDateTme: value['orderDateTime'] == null ? null : DateTime.parse(value['orderDateTme']),
                numberOfPeople: value['numberOfPeople'],
                phoneNumber: value['phoneNumber'],
                receive: value['receiveOption'] == 'ReceiveOptions.delivery'
                    ? ReceiveOptions.delivery
                    : value['receiveOption'] == 'ReceiveOptions.dineIn'
                        ? ReceiveOptions.dineIn
                        : ReceiveOptions.takeAway,
                products: (value['products'] as List)
                    .map(
                      (e) => Cart(
                        restaurantId: e['restaurantId'],
                        productId: e['productId'],
                        cartId: e['id'],
                        cartTitle: e['title'],
                        variationTitle: e['variationTitle'] == null ? null : e['variationTitle'] as List<dynamic>,
                        cartQuantity: e['quantity'],
                        cartPrice: double.parse(e['price'].toString()),
                        cartSpecialRequests: e['specialRequests'],
                      ),
                    )
                    .toList(),
                totalProductSum: double.parse(value['totalProductSum'].toString()),
                deliverySum: double.parse(value['deliverySum'].toString()),
                deliveryDistance: value['deliveryDistance'],
                taxSum: double.parse(value['taxSum'].toString()),
                totalPrice: double.parse(value['totalPrice'].toString()),
              ),
            );
          },
        );
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> removeOrder(
    String orderId,
    String? userId,
  ) async {
    Uri url = Uri.parse('https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId/$orderId.json');

    await http.patch(
      url,
      body: json.encode({
        'isRemoved': true,
      }),
    );
  }

  void notify() {
    return notifyListeners();
  }
}
