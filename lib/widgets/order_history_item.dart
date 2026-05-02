import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//...packages

import '../models/order.dart';
//...providers

class OrderHistoryItem extends StatefulWidget {
  final Order order;

  const OrderHistoryItem(
    this.order, {
    super.key,
  });

  @override
  OrderHistoryItemState createState() => OrderHistoryItemState();
}

class OrderHistoryItemState extends State<OrderHistoryItem> {
  final _scrollBarController = ScrollController();

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 20, top: 5),
            child: Text(widget.order.resName!),
          ),
          ListTile(
            title: Text('MYR ${widget.order.totalPrice.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy  hh:mm aa').format(
                widget.order.dateTime,
              ),
            ),
            trailing: IconButton(
              icon: _expanded
                  ? const Icon(
                      Icons.expand_less_rounded,
                    )
                  : const Icon(
                      Icons.expand_more_rounded,
                    ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (widget.order.specialRequests != null && widget.order.specialRequests != '')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.order.specialRequests!,
                style: const TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              height: min(
                widget.order.products.length * 100 + 50,
                150,
              ),
              child: RawScrollbar(
                controller: _scrollBarController,
                thickness: 5,
                thumbColor: Theme.of(context).colorScheme.secondary,
                radius: const Radius.circular(5),
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollBarController,
                  physics: const ScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order Price :',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.order.totalProductSum.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tax : (6%)',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.order.taxSum.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery Fee :',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.order.deliverySum.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price :',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'MYR ${widget.order.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.shadow,
                          height: 5,
                          thickness: 2,
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.order.products.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Theme.of(context).colorScheme.shadow,
                            height: 5,
                            thickness: 2,
                          ),
                          itemBuilder: (context, index) {
                            List<Widget> item = widget.order.products
                                .map(
                                  (prod) => Container(
                                    margin: const EdgeInsets.only(
                                      top: 8,
                                      bottom: 8,
                                      right: 5,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prod.cartTitle,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                        if (prod.variationTitle != null)
                                          for (var i in prod.variationTitle!)
                                            Text(
                                              i,
                                              softWrap: true,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF686868),
                                              ),
                                            ),
                                        const SizedBox(height: 5),
                                        if (prod.cartSpecialRequests != '' && prod.cartSpecialRequests != null)
                                          Text(
                                            prod.cartSpecialRequests!,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('MYR ${prod.cartPrice.toStringAsFixed(2)} x ${prod.cartQuantity.toStringAsFixed(0)}'),
                                            const Spacer(),
                                            Chip(
                                              backgroundColor: Theme.of(context).colorScheme.surface,
                                              label: Text(
                                                'MYR ${(prod.cartPrice * prod.cartQuantity).toStringAsFixed(2)}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList();

                            return item[index];
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
