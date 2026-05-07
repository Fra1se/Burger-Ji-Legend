import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/restaurant_data.dart';
//...providers

import '../widgets/restaurant_item.dart';
//...widgets

class RestaurantListView extends StatefulWidget {
  const RestaurantListView({super.key});

  @override
  State<RestaurantListView> createState() => _RestaurantListViewState();
}

class _RestaurantListViewState extends State<RestaurantListView> {
  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<Restaurants>(context, listen: false);
    //...Providers

    final scrollBarController = ScrollController();
    //...

    final resList = restaurants.items..sort((a, b) => a.address['state'].compareTo(b.address['state']));

    var resStateCount = 0;
    final resStates = [];
    for (var res in resList) {
      if (!resStates.contains(res.address['state'])) {
        resStates.add(res.address['state']);
      }
    }

    return resList.isEmpty
        ? const Center(child: Text('Work In Progress'))
        : RawScrollbar(
            controller: scrollBarController,
            thickness: 5,
            thumbColor: Theme.of(context).colorScheme.secondary,
            radius: const Radius.circular(5),
            thumbVisibility: true,
            child: ListView.separated(
              controller: scrollBarController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              separatorBuilder: (ctx, i) => Divider(
                color: Theme.of(context).colorScheme.shadow,
                height: 1,
                thickness: 1,
                endIndent: 15,
                indent: 5,
              ),
              itemCount: resList.length,
              itemBuilder: (ctx, i) {
                if (resList[i].address['state'] != resStates[resStateCount]) {
                  resStateCount++;
                }

                return ChangeNotifierProvider.value(
                  value: resList[i],
                  child: Column(
                    children: [
                      if (resList[i].address['state'] == resStates[resStateCount])
                        Container(
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            resList[i].address['state'],
                          ),
                        ),
                      RestaurantItem(),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
