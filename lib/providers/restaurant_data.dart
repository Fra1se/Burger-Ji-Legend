import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//...packages

import '../models/restaurant.dart';
//...models

class Restaurants with ChangeNotifier {
  final List<Restaurant> _items = [];

  List<Restaurant> get items {
    return [..._items];
  }

  String? selectedResId;

  set setResId(String? id) {
    selectedResId = id;
    notifyListeners();
  }

  String? chainId = 'burger_ji_legend';

  Future<void> receiveItems() async {
    Uri url = Uri.parse('https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/restaurants.json');
    _items.clear();

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((key, value) {
        ReceiveExceptions? rcvEx;
        dynamic rcvExItems = extractedData['receiveExceptions'];

        if (rcvExItems != null) {
          rcvEx = ReceiveExceptions(
            delivery: rcvExItems['delivery'],
            dineIn: rcvExItems['dineIn'],
            takeAway: rcvExItems['takeAway'],
          );
        }

        if (value['chainId'] == chainId) {
          _items.add(
            Restaurant(
              isClosed: value['isClosed'],
              restaurantTitle: value['title'],
              restaurantChTitle: value['chTitle'],
              restaurantId: key,
              restaurantUserId: value['userId'],
              restaurantCatId: List.from((value['catId'] as Map).values),
              restaurantImageUrl: value['imageUrl'],
              openTime: value['openTime'],
              address: value['address'],
              paymentDetails: value['paymentDetails'],
              lalamove: value['lalamove'],
              googleMapLink: value['googleMapLink'],
              //restaurantMapImg: value['resMapImg'],
              email: value['email'],
              number: value['number'],
              rawNumber: value['rawNumber'],
              facebook: value['facebook'],
              whatsApp: value['whatsApp'],
              line: value['line'],
              instagram: value['instagram'],

              receiveExceptions: rcvEx,
            ),
          );
        }
      });
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  Restaurant findById(String id) {
    return _items.firstWhere((item) => item.restaurantId == id);
  }

  Restaurant get selectedRestaurant {
    return _items.firstWhere((item) => item.restaurantId == selectedResId);
  }
}
