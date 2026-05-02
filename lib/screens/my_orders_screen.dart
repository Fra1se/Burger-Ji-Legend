import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../providers/my_orders_data.dart';
//...providers

import '../widgets/my_orders_item.dart';
//...widgets

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollBarController = ScrollController();

    return Column(
      children: [
        Expanded(
          child: Consumer<MyOrders>(
            builder: (ctx, myOrders, ch) {
              return FutureBuilder(
                future: myOrders.receiveMyOrders(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'Error, try again later\n${snapshot.error.toString()}',
                        ),
                      ),
                    );
                  }

                  if (myOrders.shownItems.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'No Orders',
                        ),
                      ),
                    );
                  }

                  return RawScrollbar(
                    controller: scrollBarController,
                    thickness: 5,
                    thumbColor: Theme.of(context).colorScheme.secondary,
                    radius: const Radius.circular(5),
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: scrollBarController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: Provider.of<MyOrders>(
                        context,
                        listen: false,
                      ).shownItems.length,
                      itemBuilder: (ctx, i) => MyOrdersItem(
                        Provider.of<MyOrders>(
                          context,
                          listen: false,
                        ).shownItems[i],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
