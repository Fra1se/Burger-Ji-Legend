import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//...packages

import '../models/order.dart';
import '../providers/my_orders_data.dart';
//...providers

class MyOrdersItem extends StatefulWidget {
  final Order order;

  const MyOrdersItem(
    this.order, {
    super.key,
  });

  @override
  State<MyOrdersItem> createState() => _MyOrdersItemState();
}

class _MyOrdersItemState extends State<MyOrdersItem> {
  final _scrollBarController = ScrollController();
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final String orderStatus;
    final Color orderColor;
    final String receiveOption;
    final IconData receiveIcon;

    final bool? isValidated = widget.order.isValidated;
    final ReceiveOptions receive = widget.order.receive;

    if (isValidated == true) {
      orderStatus = 'Confirmed';
      orderColor = Colors.green;
    } else if (isValidated == false) {
      orderStatus = 'Cancelled';
      orderColor = Colors.red;
    } else {
      orderStatus = 'Waiting';
      orderColor = Colors.blue;
    }

    if (receive == ReceiveOptions.delivery) {
      receiveOption = 'Delivery';
      receiveIcon = Icons.delivery_dining;
    } else if (receive == ReceiveOptions.dineIn) {
      receiveOption = 'Dine-In';
      receiveIcon = Icons.dining;
    } else {
      receiveOption = 'Take-Away';
      receiveIcon = Icons.shopping_bag;
    }

    return Card(
      margin: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
      color: Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: orderColor,
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    orderStatus,
                    style: const TextStyle(fontSize: 15),
                  ),
                  if (widget.order.isRain == true)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        color: Colors.white,
                        child: Text(
                          'Raining',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receiveOption,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy  hh:mm aa').format(widget.order.dateTime),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF686868),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(receiveIcon, size: 25),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MYR ${widget.order.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            if (widget.order.resName != null)
                              Text(
                                widget.order.resName!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF686868),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Material(
                        shape: const CircleBorder(),
                        color: Theme.of(context).colorScheme.surface,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          child: Ink(
                            height: 50,
                            width: 50,
                            child: Icon(
                              _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                              size: 25,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_expanded)
              Column(
                children: [
                  Container(
                    color: Colors.grey[200],
                    height: 150,
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    child: RawScrollbar(
                      controller: _scrollBarController,
                      thickness: 2.5,
                      thumbColor: Theme.of(context).colorScheme.shadow,
                      thumbVisibility: true,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: SingleChildScrollView(
                          controller: _scrollBarController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.order.specialRequests != null && widget.order.specialRequests != '')
                                Text(
                                  widget.order.specialRequests!,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              const SizedBox(height: 5),
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
                              if (widget.order.deliveryDistance != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Distance :  ${widget.order.deliveryDistance}',
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
                                    widget.order.totalPrice.toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
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
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemCount: prod.variationTitle!.length,
                                                  itemBuilder: (context, index) => Text(
                                                    prod.variationTitle![index],
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
                                                  Text(
                                                    'MYR ${prod.cartPrice.toStringAsFixed(2)} x ${prod.cartQuantity.toStringAsFixed(0)}',
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    'MYR ${(prod.cartPrice * prod.cartQuantity).toStringAsFixed(2)}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.order.isValidated == null
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text('Remove This Order?'),
                              actions: [
                                TextButton(
                                  child: const Text('YES'),
                                  onPressed: () async {
                                    final nav = Navigator.of(context);
                                    nav.pop();

                                    showDialog(
                                      context: ctx,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );

                                    final myOrders = Provider.of<MyOrders>(context, listen: false);
                                    await myOrders.removeOrder(
                                      widget.order.orderId,
                                      widget.order.userId,
                                    );

                                    nav.pop();
                                    myOrders.notify();
                                  },
                                ),
                                TextButton(
                                  child: const Text('NO'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                if (widget.order.lalamoveShareLink != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primaryContainer,
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                        ),
                      ),
                      icon: Icon(
                        Icons.track_changes,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 18,
                      ),
                      label: Text(
                        'Track Driver',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () => launchUrl(
                        Uri.parse(widget.order.lalamoveShareLink!),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
