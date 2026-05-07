import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../models/restaurant.dart';
//...models

import '../providers/restaurant_data.dart';
//...providers

import '../screens/product_category_screen.dart';
//...screens

class RestaurantItem extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  RestaurantItem({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurant = Provider.of<Restaurant>(context);
    final selectedRestaurantId = Provider.of<Restaurants>(context).selectedResId;
    //...Providers

    return Material(
      child: InkWell(
        onTap: () {
          if (restaurant.restaurantId == selectedRestaurantId || selectedRestaurantId == null) {
            Navigator.of(context).pushNamed(
              ProductCategoryScreen.routeName,
              arguments: {
                'restaurantId': restaurant.restaurantId,
                'restaurantTitle': restaurant.restaurantTitle,
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Alert'),
                content: const Text(
                  'Only Allow Order from Same Merchant per Session\n(Hanya Dibenarkan Order dari Usahawan Sama per Sesi)',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                child: restaurant.restaurantImageUrl == ''
                    ? Container(
                        margin: const EdgeInsets.all(5),
                        color: Colors.white,
                        height: 90,
                        width: 140,
                        child: const Center(
                          child: Icon(Icons.local_pizza),
                        ),
                      )
                    : FittedBox(
                        clipBehavior: Clip.hardEdge,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: CachedNetworkImage(
                            imageUrl: restaurant.restaurantImageUrl,
                            fit: BoxFit.cover,
                            height: 90,
                            width: 140,
                            errorWidget: (context, url, error) => Icon(Icons.local_pizza),
                            placeholder: (context, url) => Icon(Icons.local_pizza),
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.restaurantTitle,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (restaurant.address['town'] != '' && restaurant.address['town'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                '(${restaurant.address['town']})',
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                          //
                          if ((restaurant.address['subDistrict'] != '' && restaurant.address['subDistrict'] != null) &&
                              (restaurant.address['district'] != '' && restaurant.address['district'] != null))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                '(${restaurant.address['subDistrict']}, ${restaurant.address['district']})',
                                style: const TextStyle(fontSize: 12.5),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: const Icon(Icons.arrow_left),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
