import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//...packages

import '../models/order.dart';
import '../models/order_info.dart';
import '../providers/my_orders_data.dart';
import '../providers/cart_data.dart';
import '../providers/order_data.dart';
//...providers

import 'tabs_screen.dart';
//...screens

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  static const routeName = '/qr-code-screen';

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  bool _isLoading = false;
  bool _isLoading2 = false;

  String? downloadUrl;
  String uploadContainerTitle = 'Press Here to Upload Payment Receipt';

  @override
  Widget build(BuildContext context) {
    final scrollBarController = ScrollController();

    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final restaurantLalamove = routeArgs['restaurantLalamove'];
    final restaurantQrCode = routeArgs['restaurantQrCode'];
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
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      body: RawScrollbar(
        controller: scrollBarController,
        thickness: 5,
        thumbColor: Theme.of(context).colorScheme.secondary,
        radius: const Radius.circular(5),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollBarController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                restaurantQrCode,
                height: MediaQuery.of(context).size.height - 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: InkWell(
                  onTap: _isLoading2 || _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading2 = true;
                          });

                          await Provider.of<Orders>(
                            context,
                            listen: false,
                          ).downloadImage(
                            restaurantQrCode,
                          );

                          setState(() {
                            _isLoading2 = false;
                          });

                          alertDialog(
                            title: 'Saved',
                            content: 'Image saved to your gallery',
                          );
                        },
                  child: Material(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      color: Colors.white,
                      width: double.infinity,
                      child: _isLoading2
                          ? const LinearProgressIndicator()
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Press Here to Save QR Code into Smartphone',
                                  textAlign: TextAlign.center,
                                ),
                                Icon(
                                  Icons.download,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          final order = Provider.of<Orders>(context, listen: false);
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
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
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
                              onPopInvokedWithResult: (_, _) => Future.value(false),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );

                          final cart = Provider.of<Carts>(context, listen: false);
                          final order = Provider.of<Orders>(context, listen: false);
                          final myOrders = Provider.of<MyOrders>(context, listen: false);

                          final nav = Navigator.of(context);

                          bool addOrderValidator = true;

                          try {
                            if (paymentMethod != PaymentMethods.cash && downloadUrl == null) {
                              throw const HttpException('Invalid Payment Receipt');
                            }

                            await order.addOrder(
                              paymentMethod: paymentMethod,
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
                          nav.pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(
                                  const Duration(
                                    seconds: 5,
                                  ),
                                  () {
                                    nav.pop(true);
                                  },
                                );
                                return const AlertDialog(
                                  title: Text('Alert'),
                                  content: Text('Success - Order Sent'),
                                );
                              },
                            );
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
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
