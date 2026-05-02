import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//...packages

import '../models/order_info.dart';
import '../models/order.dart';
import '../providers/cart_data.dart';
import '../providers/my_orders_data.dart';
import '../providers/order_data.dart';
//...providers

import 'tabs_screen.dart';
//...screens

class DirectPaymentScreen extends StatefulWidget {
  const DirectPaymentScreen({super.key});

  static const routeName = '/direct-payment-screen';

  @override
  State<DirectPaymentScreen> createState() => _DirectPaymentScreenState();
}

class _DirectPaymentScreenState extends State<DirectPaymentScreen> {
  bool _isLoading = false;
  String? downloadUrl;
  String uploadContainerTitle = 'Press Here to Upload Payment Receipt';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final restaurantBankDetails = routeArgs['restaurantBankDetails'];
    final restaurantLalamove = routeArgs['restaurantLalamove'];
    final paymentMethod = routeArgs['paymentMethod'];
    final orderInfo = routeArgs['orderInfo'] as OrderInfo;

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

    Widget infoRow(
      String header,
      String value, {
      bool? copy,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              header,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                if (copy == true)
                  IconButton(
                    onPressed: () async {
                      final scaffMes = ScaffoldMessenger.of(context);
                      await Clipboard.setData(ClipboardData(text: value));
                      scaffMes.showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 4),
                          content: Text(
                            'Copied to Clipboard',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.copy,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Bank Transfer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoRow(
                    'Pay To :',
                    orderInfo.resName,
                  ),
                  const SizedBox(height: 5),
                  infoRow(
                    'Bank :',
                    restaurantBankDetails!['bank'],
                  ),
                  const SizedBox(height: 5),
                  infoRow(
                    'Account Name :',
                    restaurantBankDetails!['accountName'],
                  ),
                  const SizedBox(height: 5),
                  infoRow(
                    'Account No. :',
                    restaurantBankDetails!['accountNo'],
                    copy: true,
                  ),
                  const SizedBox(height: 5),
                  infoRow(
                    'Total Price :',
                    'MYR ${Provider.of<Carts>(context, listen: false).totalPrice.toStringAsFixed(2)}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text('Payment Receipt:'),
              ),
              InkWell(
                onTap: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final order =
                            Provider.of<Orders>(context, listen: false);
                        dynamic response;

                        try {
                          response = await order.uploadReceipt();
                        } catch (error) {
                          setState(() {
                            _isLoading = false;
                          });
                        }

                        setState(() {
                          _isLoading = false;
                          downloadUrl = response['downloadUrl'];
                          uploadContainerTitle = response['fileName'];
                        });
                      },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  color: Colors.white,
                  width: double.infinity,
                  child: _isLoading
                      ? const LinearProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              uploadContainerTitle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Icon(Icons.upload),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
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
                  onPressed: _isLoading
                      ? null
                      : () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => PopScope(
                              onPopInvokedWithResult: (_, __) => Future.value(false),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );

                          final cart =
                              Provider.of<Carts>(context, listen: false);
                          final order =
                              Provider.of<Orders>(context, listen: false);
                          final myOrders =
                              Provider.of<MyOrders>(context, listen: false);

                          final nav = Navigator.of(context);

                          bool addOrderValidator = true;

                          try {
                            if (paymentMethod != PaymentMethods.cash &&
                                downloadUrl == null) {
                              throw const HttpException(
                                  'Invalid Payment Receipt');
                            }

                            await order.addOrder(
                              paymentMethod: paymentMethod,
                              resName: orderInfo.resName,
                              deliveryInfo: orderInfo.receive !=
                                      ReceiveOptions.delivery
                                  ? null
                                  : {
                                      'apiKey': restaurantLalamove!['apiKey'],
                                      'apiSecret':
                                          restaurantLalamove!['apiSecret'],
                                      //...
                                      'quotationId':
                                          orderInfo.lalamoveInfo!.quotationId,
                                      'restaurantStopId': orderInfo
                                          .lalamoveInfo!.restaurantStopId,
                                      'customerStopId': orderInfo
                                          .lalamoveInfo!.customerStopId,
                                      //...
                                      'restaurantName': orderInfo.resName,
                                      'restaurantRawNumber':
                                          orderInfo.resNumber,
                                      'customerName': orderInfo.cusName,
                                      'customerNumber': orderInfo.cusNumber,
                                      //...
                                      'restaurantAddress': orderInfo
                                          .lalamoveInfo!.restaurantAddress,
                                      'restaurantLat':
                                          orderInfo.lalamoveInfo!.restaurantLat,
                                      'restaurantLng':
                                          orderInfo.lalamoveInfo!.restaurantLng,
                                      //...
                                      'customerAddress': orderInfo
                                          .lalamoveInfo!.customerAddress,
                                      'customerLat':
                                          orderInfo.lalamoveInfo!.customerLat,
                                      'customerLng':
                                          orderInfo.lalamoveInfo!.customerLng,
                                      //...
                                      'customerState':
                                          orderInfo.lalamoveInfo!.customerState,
                                      'customerDistrict': orderInfo
                                          .lalamoveInfo!.customerDistrict,
                                      'customerSubDistrict': orderInfo
                                          .lalamoveInfo!.customerSubDistrict,
                                      'customerPostalCode': orderInfo
                                          .lalamoveInfo!.customerPostalCode,
                                      //...
                                      'quotedFee': cart.deliverySum.toString(),
                                      //...
                                    },
                              receiptUrl: downloadUrl,
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
                            alertDialog(
                              title: 'ERROR',
                              content: error.toString(),
                            );
                            addOrderValidator = false;
                          }

                          if (addOrderValidator == false) {
                            return;
                          }

                          if (context.mounted) {
                            await cart.clearAllItems(context);
                          }

                          try {
                            await myOrders.receiveMyOrders();
                          } catch (error) {
                            return;
                          }

                          nav.pop();
                          nav.pushNamedAndRemoveUntil(
                              TabsScreen.routeName, (route) => false);

                          if (context.mounted) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(
                                      const Duration(
                                        seconds: 5,
                                      ), () {
                                    nav.pop(true);
                                  });
                                  return const AlertDialog(
                                    title: Text('Alert'),
                                    content: Text('Success - Order Sent'),
                                  );
                                });
                          }
                        },
                  icon: Icon(
                    Icons.alarm,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text(
                    'Order Now',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
