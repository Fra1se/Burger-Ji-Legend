import 'package:flutter/material.dart';
//...packages

class ReceiveExceptions {
  bool delivery = false;
  bool dineIn = false;
  bool takeAway = false;

  ReceiveExceptions({
    required this.delivery,
    required this.dineIn,
    required this.takeAway,
  });
}

class Restaurant with ChangeNotifier {
  bool? isClosed;

  String restaurantTitle;
  String restaurantChTitle;
  String restaurantId;
  String? restaurantUserId;
  List<String> restaurantCatId;
  String restaurantImageUrl;

  String openTime;

  Map<String, dynamic> address;
  Map<String, dynamic>? lalamove;

  Map<String, dynamic>? paymentDetails;

  ReceiveExceptions? receiveExceptions;

  String googleMapLink;
  //String restaurantMapImg;
  String email;
  String number;
  String rawNumber;
  String facebook;
  String whatsApp;
  String line;
  String instagram;

  Restaurant({
    required this.isClosed,
    required this.restaurantTitle,
    required this.restaurantChTitle,
    required this.restaurantId,
    required this.restaurantUserId,
    required this.restaurantCatId,
    required this.restaurantImageUrl,
    required this.openTime,
    required this.address,
    required this.paymentDetails,
    required this.lalamove,
    required this.receiveExceptions,
    required this.googleMapLink,
    //required this.restaurantMapImg,
    required this.email,
    required this.number,
    required this.rawNumber,
    required this.facebook,
    required this.whatsApp,
    required this.line,
    required this.instagram,
  });
}
