import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//...packages

import '../models/restaurant.dart';
//...models

class Restaurants with ChangeNotifier {
  Restaurant? _items;

  Restaurant get items {
    return _items!;
  }

  String? selectedRestaurantId = 'ojas-satti-sorru';

  Future<void> receiveItems() async {
    Uri url = Uri.parse(
      'https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/restaurants/$selectedRestaurantId.json',
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      Restaurant? loadedItems;

      ReceiveExceptions? rcvEx;
      dynamic rcvExItems = extractedData['receiveExceptions'];

      if (rcvExItems != null) {
        rcvEx = ReceiveExceptions(
          delivery: rcvExItems['delivery'],
          dineIn: rcvExItems['dineIn'],
          takeAway: rcvExItems['takeAway'],
        );
      }

      loadedItems = Restaurant(
        isClosed: extractedData['isClosed'],
        restaurantTitle: extractedData['title'],
        restaurantChTitle: extractedData['chTitle'],
        restaurantId: selectedRestaurantId!,
        restaurantUserId: extractedData['userId'],
        restaurantCatId: List.from((extractedData['catId'] as Map).values),
        restaurantImageUrl: extractedData['imageUrl'],
        openTime: extractedData['openTime'],
        address: extractedData['address'],
        paymentDetails: extractedData['paymentDetails'],
        lalamove: extractedData['lalamove'],
        receiveExceptions: rcvEx,
        fusion: extractedData['fusion'],
        googleMapLink: extractedData['googleMapLink'],
        restaurantMapImg: extractedData['resMapImg'],
        email: extractedData['email'],
        number: extractedData['number'],
        rawNumber: extractedData['rawNumber'],
        facebook: extractedData['facebook'],
        whatsApp: extractedData['whatsApp'],
        line: extractedData['line'],
        instagram: extractedData['instagram'],
      );

      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Restaurant findById(String id) {
    return items;
  }
}
