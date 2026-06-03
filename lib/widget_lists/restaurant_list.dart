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
                indent: 15,
              ),
              itemCount: resList.length,
              itemBuilder: (ctx, i) {
                if (resStates.length != resStateCount) {
                  if (resList[i].address['state'] == resStates[resStateCount]) {
                    resStateCount++;
                  }

                  return ChangeNotifierProvider.value(
                    value: resList[i],
                    child: Column(
                      children: [
                        if (resList[i].address['state'] == resStates[resStateCount - 1])
                          Container(
                            width: double.infinity,
                            //color: Theme.of(context).colorScheme.secondaryContainer,
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                              bottom: 5,
                            ),
                            child: Text(
                              resList[i].address['state'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        resList[i].isClosed == true
                            ? ClipRRect(
                                child: Banner(
                                  location: BannerLocation.topStart,
                                  message: 'Closed',
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  child: RestaurantItem(),
                                ),
                              )
                            : resList[i].isTempClosed == true
                            ? Column(
                                children: [
                                  RestaurantItem(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 5,
                                      ),
                                      width: double.infinity,
                                      color: Colors.red,
                                      child: Text(
                                        'Too Many Orders (Try Again Later)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : RestaurantItem(),
                      ],
                    ),
                  );
                } else {
                  return ChangeNotifierProvider.value(
                    value: resList[i],
                    child: resList[i].isClosed == true
                        ? ClipRRect(
                            child: Banner(
                              location: BannerLocation.topStart,
                              message: 'Closed',
                              textStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              child: RestaurantItem(),
                            ),
                          )
                        : resList[i].isTempClosed == true
                        ? Column(
                            children: [
                              RestaurantItem(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  width: double.infinity,
                                  color: Colors.red,
                                  child: Text(
                                    'Too Many Orders (Try Again Later)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : RestaurantItem(),
                  );
                }
              },
            ),
          );
  }
}
