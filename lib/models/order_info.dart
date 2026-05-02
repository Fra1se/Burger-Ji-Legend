import 'order.dart';
import 'cart.dart';
//...providers

class LalamoveDeliveryInfo {
  final String? quotationId;
  final String? restaurantStopId;
  final String? customerStopId;
  //...
  final String customerAddress;
  final String customerLat;
  final String customerLng;
  //...
  final String customerState;
  final String customerDistrict;
  final String customerSubDistrict;
  final String customerPostalCode;
  //...
  final String restaurantAddress;
  final String restaurantLat;
  final String restaurantLng;

  LalamoveDeliveryInfo({
    required this.quotationId,
    required this.restaurantStopId,
    required this.customerStopId,
    //...
    required this.restaurantAddress,
    required this.restaurantLat,
    required this.restaurantLng,
    //...
    required this.customerAddress,
    required this.customerLat,
    required this.customerLng,
    //...
    required this.customerState,
    required this.customerDistrict,
    required this.customerSubDistrict,
    required this.customerPostalCode,
  });
}

class OrderInfo {
  final LalamoveDeliveryInfo? lalamoveInfo;
  final String? resUserId;
  //...
  final DateTime? scheduledAt;
  final int numPax;
  final ReceiveOptions receive;
  final String? specialRequests;
  //...
  final String resName;
  final String resNumber;
  final String cusName;
  final String cusNumber;
  //...
  final List<Cart> products;

  OrderInfo({
    required this.lalamoveInfo,
    required this.resUserId,
    //...
    required this.scheduledAt,
    required this.numPax,
    required this.receive,
    required this.specialRequests,
    //...
    required this.resName,
    required this.resNumber,
    required this.cusName,
    required this.cusNumber,
    //...
    required this.products,
  });
}
