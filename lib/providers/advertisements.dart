import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//...packages

class Advertisement {
  final String imageUrl;
  final String advertUrl;

  Advertisement({
    required this.imageUrl,
    required this.advertUrl,
  });
}

class Advertisements with ChangeNotifier {
  final List<Advertisement> _items = [];

  List<Advertisement> get items {
    return [..._items];
  }

  void shuffleItems() {
    _items.shuffle();
  }

  Future<void> receiveItems() async {
    try {
      final url = Uri.parse('https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/advertisements/valueat.json');
      final data = await http.get(url);
      final advertData = json.decode(data.body) as Map<String, dynamic>;

      advertData.forEach(
        (key, value) {
          _items.add(
            Advertisement(
              imageUrl: value['imageUrl'],
              advertUrl: value['advertUrl'],
            ),
          );
        },
      );

      shuffleItems();

      notifyListeners();
    } catch (error) {
      return;
    }
  }

  int index = 0;

  void nextItem() {
    if (index == (_items.length - 1)) {
      shuffleItems();
      index = 0;
    } else {
      index++;
    }

    notifyListeners();
  }
}
