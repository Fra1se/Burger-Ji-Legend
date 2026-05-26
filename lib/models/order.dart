import 'package:flutter/material.dart';
import 'cart.dart';

enum ReceiveOptions {
  takeAway,
  dineIn,
  delivery,
}

enum PaymentMethods {
  cash,
  transfer,
  bankQr,
  tng,
}

class Order with ChangeNotifier {
  final String? resName;
  final String orderId;
  final String? userId;
  final DateTime dateTime;
  final String customerName;
  final DateTime? orderDateTme;
  final int numberOfPeople;
  final String phoneNumber;
  final ReceiveOptions receive;
  final String? specialRequests;
  final List<Cart> products;
  final double totalProductSum;
  final double deliverySum;
  final String? deliveryDistance;
  final double taxSum;
  final double totalPrice;

  final bool? isValidated;
  final bool? isRain;
  final bool? isRemoved;

  final String? lalamoveShareLink;

  Order({
    required this.resName,
    required this.orderId,
    required this.userId,
    required this.dateTime,
    required this.customerName,
    required this.orderDateTme,
    required this.numberOfPeople,
    required this.phoneNumber,
    required this.receive,
    this.specialRequests = '',
    required this.products,
    required this.totalProductSum,
    required this.deliverySum,
    required this.deliveryDistance,
    required this.taxSum,
    required this.totalPrice,
    this.isValidated,
    this.isRain,
    this.isRemoved,
    this.lalamoveShareLink,
  });
}
