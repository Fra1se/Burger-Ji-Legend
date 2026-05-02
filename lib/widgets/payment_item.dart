import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../models/order_info.dart';
import '../models/order.dart';
import '../providers/cart_data.dart';
import '../providers/my_orders_data.dart';
import '../providers/order_data.dart';
//...providers

import '../screens/qr_code_screen.dart';
import '../screens/direct_payment_screen.dart';
import '../screens/tabs_screen.dart';
//...screens

class PaymentItem extends StatefulWidget {
  const PaymentItem({
    super.key,
  });

  @override
  State<PaymentItem> createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  PaymentMethods? _payment;

  @override
  Widget build(BuildContext context) {
    final scrollBarController = ScrollController();
    //...

    final carts = Provider.of<Carts>(context);
    //...

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final restaurantPaymentDetails = routeArgs['restaurantPaymentDetails'];

    final restaurantLalamove = routeArgs['restaurantLalamove'];
    final orderInfo = routeArgs['orderInfo'] as OrderInfo;
    //...RouteArgs

    void alertDialog({
      String title = '',
      String content = '',
      String chContent = '',
    }) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (content != '') Text(content),
              if (chContent != '') Text(chContent),
            ],
          ),
          actions: [
            TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: const Text('OK'))
          ],
        ),
      );
    }
    //...

    return RawScrollbar(
      controller: scrollBarController,
      thickness: 5,
      thumbColor: Theme.of(context).colorScheme.secondary,
      radius: const Radius.circular(5),
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollBarController,
        physics: const ScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          carts.totalProductSum.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
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
                          0.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
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
                          carts.deliverySum.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (carts.distance != null) const SizedBox(height: 5),
                    if (carts.distance != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distance :  ${carts.distance}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 15),
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
                          'MYR ${carts.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              RadioListTile<PaymentMethods>(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(
                  'Cash',
                  style: TextStyle(fontSize: 14),
                ),
                value: PaymentMethods.cash,
                groupValue: _payment,
                onChanged: !(orderInfo.receive == ReceiveOptions.dineIn || orderInfo.receive == ReceiveOptions.takeAway)
                    ? null
                    : (value) {
                        setState(() {
                          _payment = value;
                        });
                      },
              ),
              RadioListTile<PaymentMethods>(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(
                  'Bank Transfer',
                  style: TextStyle(fontSize: 14),
                ),
                value: PaymentMethods.transfer,
                groupValue: _payment,
                onChanged: restaurantPaymentDetails?['transfer'] == null
                    ? null
                    : (value) {
                        setState(() {
                          _payment = value;
                        });
                      },
              ),
              RadioListTile<PaymentMethods>(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(
                  'Bayarlah (QR Code)',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                value: PaymentMethods.bayarlah,
                groupValue: _payment,
                onChanged: restaurantPaymentDetails?['bayarlah'] == null
                    ? null
                    : (value) {
                        setState(() {
                          _payment = value;
                        });
                      },
              ),
              RadioListTile<PaymentMethods>(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(
                  'Bank (QR Code)',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                value: PaymentMethods.bank,
                groupValue: _payment,
                onChanged: restaurantPaymentDetails?['bank'] == null
                    ? null
                    : (value) {
                        setState(() {
                          _payment = value;
                        });
                      },
              ),
              RadioListTile<PaymentMethods>(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(
                  'e-Wallet (QR Code)',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                value: PaymentMethods.ewallet,
                groupValue: _payment,
                //onChanged: null,
                onChanged: restaurantPaymentDetails?['ewallet'] == null
                    ? null
                    : (value) {
                        setState(() {
                          _payment = value;
                        });
                      },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: Icon(
                    Icons.payment,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text(
                    'Pay Now',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 13,
                    ),
                  ),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () async {
                    if (_payment == null) {
                      return alertDialog(
                        title: 'Alert',
                        content: 'Please Choose Payment Method',
                      );
                    }

                    if (_payment == PaymentMethods.transfer) {
                      Navigator.of(context).pushNamed(
                        DirectPaymentScreen.routeName,
                        arguments: {
                          'restaurantLalamove': restaurantLalamove,
                          'restaurantBankDetails': restaurantPaymentDetails?['transfer'],
                          'paymentMethod': _payment,
                          'orderInfo': orderInfo,
                        },
                      );
                    } else if (_payment == PaymentMethods.bayarlah) {
                      Navigator.of(context).pushNamed(
                        QrCodeScreen.routeName,
                        arguments: {
                          'restaurantLalamove': restaurantLalamove,
                          'restaurantQrCode': restaurantPaymentDetails?['bayarlah'],
                          'paymentMethod': _payment,
                          'orderInfo': orderInfo,
                        },
                      );
                    } else if (_payment == PaymentMethods.bank) {
                      Navigator.of(context).pushNamed(
                        QrCodeScreen.routeName,
                        arguments: {
                          'restaurantLalamove': restaurantLalamove,
                          'restaurantQrCode': restaurantPaymentDetails?['bank'],
                          'paymentMethod': _payment,
                          'orderInfo': orderInfo,
                        },
                      );
                    } else if (_payment == PaymentMethods.ewallet) {
                      Navigator.of(context).pushNamed(
                        QrCodeScreen.routeName,
                        arguments: {
                          'restaurantLalamove': restaurantLalamove,
                          'restaurantQrCode': restaurantPaymentDetails?['ewallet'],
                          'paymentMethod': _payment,
                          'orderInfo': orderInfo,
                        },
                      );
                    } else if (_payment == PaymentMethods.cash) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text(
                            'Pay by Cash Later & Send Order Now?',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('YES'),
                              onPressed: () async {
                                Navigator.of(ctx).pop();

                                showDialog(
                                  context: context,
                                  builder: (c) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                final cart = Provider.of<Carts>(context, listen: false);
                                final order = Provider.of<Orders>(context, listen: false);
                                final myOrders = Provider.of<MyOrders>(context, listen: false);
                                final clearAllItems = cart.clearAllItems(context);
                                final nav = Navigator.of(context);
                                //...

                                try {
                                  await order.addOrder(
                                    paymentMethod: _payment!,
                                    resName: orderInfo.resName,
                                    deliveryInfo: orderInfo.receive != ReceiveOptions.delivery
                                        ? null
                                        : {
                                            'apiKey': restaurantLalamove!['apiKey'],
                                            'apiSecret': restaurantLalamove!['apiSecret'],
                                            //...
                                            'quotationId': orderInfo.lalamoveInfo!.quotationId,
                                            'restaurantStopId': orderInfo.lalamoveInfo!.restaurantStopId,
                                            'customerStopId': orderInfo.lalamoveInfo!.customerStopId,
                                            //...
                                            'restaurantName': orderInfo.resName,
                                            'restaurantRawNumber': orderInfo.resNumber,
                                            'customerName': orderInfo.cusName,
                                            'customerNumber': orderInfo.cusNumber,
                                            //...
                                            'restaurantAddress': orderInfo.lalamoveInfo!.restaurantAddress,
                                            'restaurantLat': orderInfo.lalamoveInfo!.restaurantLat,
                                            'restaurantLng': orderInfo.lalamoveInfo!.restaurantLng,
                                            //...
                                            'customerAddress': orderInfo.lalamoveInfo!.customerAddress,
                                            'customerLat': orderInfo.lalamoveInfo!.customerLat,
                                            'customerLng': orderInfo.lalamoveInfo!.customerLng,
                                            //...
                                            'customerState': orderInfo.lalamoveInfo!.customerState,
                                            'customerDistrict': orderInfo.lalamoveInfo!.customerDistrict,
                                            'customerSubDistrict': orderInfo.lalamoveInfo!.customerSubDistrict,
                                            'customerPostalCode': orderInfo.lalamoveInfo!.customerPostalCode,
                                            //...
                                            'quotedFee': cart.deliverySum.toString(),
                                            //...
                                          },
                                    userId: orderInfo.resUserId,
                                    customerName: orderInfo.cusName,
                                    scheduleAt: orderInfo.scheduledAt,
                                    numberOfPeople: orderInfo.numPax,
                                    phoneNumber: orderInfo.cusNumber,
                                    receiveOption: orderInfo.receive,
                                    specialRequests: orderInfo.specialRequests,
                                    products: orderInfo.products,
                                    totalProductSum: cart.totalProductSum,
                                    deliverySum: cart.deliverySum,
                                    deliveryDistance: cart.distance,
                                    taxSum: cart.taxSum,
                                    totalPrice: cart.totalPrice,
                                  );
                                } catch (error) {
                                  nav.pop();
                                  return;
                                }

                                await clearAllItems;
                                await myOrders.receiveMyOrders();
                                myOrders.notify();

                                nav.pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);

                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Navigator.of(context).pop(true);
                                      return const AlertDialog(
                                        title: Text('Alert'),
                                        content: Text(
                                          'Success - Order Sent',
                                        ),
                                      );
                                    },
                                  );
                                }
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
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
