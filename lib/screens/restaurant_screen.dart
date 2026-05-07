import 'package:flutter/material.dart';
//...packages

import '../widget_lists/restaurant_list.dart';
//...widgets

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});
  static const routeName = '/restaurant-screen';

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return RestaurantListView();
  }
}
