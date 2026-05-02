import 'dart:io';
import '../firebase_options.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gal/gal.dart';
import 'package:dio/dio.dart';
//...packages

import '../models/order.dart';
import '../models/order_address.dart';
import 'cart_data.dart';
import '../models/cart.dart';
//...providers

class Orders with ChangeNotifier {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _detailsFile async {
    final path = await _localPath;
    return File('$path/infoDetails.txt');
  }

  Future<File> get _addressFile async {
    final path = await _localPath;
    return File('$path/addressDetails.txt');
  }

  Future<void> saveDetails(
    String customerName,
    String numberOfPeople,
    String phoneNumber,
  ) async {
    final file = await _detailsFile;
    await file.writeAsString(
      json.encode(
        {
          'customerName': customerName,
          'numberOfPeople': numberOfPeople,
          'phoneNumber': phoneNumber,
        },
      ),
    );
  }

  dynamic details;
  Future<dynamic> receiveDetails() async {
    try {
      final file = await _detailsFile;
      String? body = await file.readAsString();

      dynamic extractedData = json.decode(body) as Map<String, dynamic>;
      if (extractedData != null) {
        details = extractedData;
      } else {
        details = null;
      }
    } catch (error) {
      details = null;
      return;
    }
  }

  OrderAddress? orderAddress;
  set setAddress(OrderAddress? addresss) {
    orderAddress = addresss;
  }

  Future<void> saveAddress({
    required String address,
    required String postalCode,
    required String state,
    required String distrcit,
    required String subDistrict,
  }) async {
    final file = await _addressFile;

    await file.writeAsString(
      json.encode(
        {
          'address': address,
          'postalCode': postalCode,
          'state': state,
          'district': distrcit,
          'subDistrict': subDistrict,
        },
      ),
    );
  }

  Future<dynamic> receiveAddres() async {
    try {
      final file = await _addressFile;
      String body = await file.readAsString();

      dynamic extractedData = json.decode(body) as Map<String, dynamic>;
      if (extractedData != null) {
        orderAddress = OrderAddress(
          addressValidate: true,
          address: extractedData['address'],
          latitude: '',
          longitude: '',
          state: extractedData['state'],
          district: extractedData['district'],
          subDistrict: extractedData['subDistrict'],
          postalCode: extractedData['postalCode'],
        );
      } else {
        orderAddress = null;
      }
    } catch (error) {
      orderAddress = null;
      return null;
    }
  }

  Future<Map<String, String>?> getQuotations({
    required String apiSecret,
    required String apiKey,
    //...
    required BuildContext context,
    required String time,
    required String? scheduledAt,
    //...
    required String restaurantName,
    required String restaurantRawNumber,
    required String customerName,
    required String customerNumber,

    //...
    required String restaurantAddress,
    required String restaurantLat,
    required String restaurantLng,
    required String customerAddress,
    required String customerLat,
    required String customerLng,
  }) async {
    const method = 'POST';
    const quotationsPath = '/v3/quotations';
    final cart = Provider.of<Carts>(context, listen: false);

    var body = json.encode(
      {
        "data": {
          "serviceType": "MOTORCYCLE",
          if (scheduledAt != null) "scheduleAt": scheduledAt,
          "language": "en_MY",
          "stops": [
            {
              "coordinates": {
                "lat": double.parse(restaurantLat).toStringAsFixed(15),
                "lng": double.parse(restaurantLng).toStringAsFixed(15),
              },
              "address": restaurantAddress,
            },
            {
              "coordinates": {
                "lat": double.parse(customerLat).toStringAsFixed(15),
                "lng": double.parse(customerLng).toStringAsFixed(15),
              },
              "address": customerAddress,
            },
          ],
        }
      },
    );

    var rawSignature = '$time\r\n$method\r\n$quotationsPath\r\n\r\n$body';

    var hmac = Hmac(sha256, utf8.encode(apiSecret));
    var signature = hmac.convert(utf8.encode(rawSignature));

    var token = 'hmac $apiKey:$time:$signature';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
      'Market': 'MY',
    };

    var url = Uri.parse('https://rest.lalamove.com$quotationsPath');

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 201) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error ${response.statusCode}'),
            content: Text(response.body),
          ),
        );
      }
      return null;
    } else {
      final quote = json.decode(response.body) as Map<String, dynamic>;
      cart.setQuotations(
        getDelivery: quote['data']['priceBreakdown']['total'],
        getDistance: quote['data']['distance']['unit'] == "m"
            ? '${((double.parse(quote['data']['distance']['value'])) / 1000).toStringAsFixed(2)} km'
            : '${quote['data']['distance']['value']} km',
      );
      return {
        'quotationId': quote['data']['quotationId'],
        'restaurantStopId': quote['data']['stops'][0]['stopId'],
        'customerStopId': quote['data']['stops'][1]['stopId'],
      };
    }
  }

  Future<void> addOrder({
    Map<String, String?>? deliveryInfo,
    required PaymentMethods paymentMethod,
    //...
    String? userId,
    String? receiptUrl,
    required String resName,
    required String customerName,
    required DateTime? scheduleAt,
    required int numberOfPeople,
    required String phoneNumber,
    required ReceiveOptions receiveOption,
    required String? specialRequests,
    required List<Cart> products,
    required double totalProductSum,
    required double deliverySum,
    required String? deliveryDistance,
    required double taxSum,
    required double totalPrice,
  }) async {
    Uri url = Uri.parse(userId != null
        ? 'https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json'
        : 'https://valueat-app-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');

    final timeStamp = DateTime.now();

    int itemCount = 0;

    for (var prod in products) {
      itemCount += prod.cartQuantity;
    }

    try {
      await http.post(
        url,
        body: json.encode(
          {
            'resName': resName,
            'userId': userId,
            'fcmToken': await FirebaseMessaging.instance.getToken(),
            if (receiptUrl != null) 'receiptUrl': receiptUrl,
            if (deliveryInfo != null) 'deliveryInfo': deliveryInfo,
            'paymentMethod': paymentMethod.toString(),
            'timeStamp': timeStamp.toIso8601String(),
            'customerName': customerName,
            'orderDateTme': scheduleAt?.toIso8601String(),
            'numberOfPeople': numberOfPeople,
            'phoneNumber': phoneNumber,
            'receiveOption': receiveOption.toString(),
            'specialRequests': specialRequests ?? '',
            'totalProductSum': totalProductSum,
            'deliverySum': deliverySum,
            'deliveryDistance': deliveryDistance,
            'taxSum': taxSum,
            'totalPrice': totalPrice,
            'itemCount': itemCount,
            'products': products
                .map((value) => {
                      'restaurantId': value.restaurantId,
                      'productId': value.productId,
                      'id': value.cartId,
                      'title': value.cartTitle,
                      'variationTitle': value.variationTitle,
                      'price': value.cartPrice,
                      'quantity': value.cartQuantity,
                      'specialRequests': value.cartSpecialRequests,
                    })
                .toList()
          },
        ),
      );
    } catch (error) {
      rethrow;
    }

    notifyListeners();
  }

  Future<Map<String, String>> uploadReceipt() async {
    File? selectedFile;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      selectedFile = File(result!.files.single.path!);
      String filePath = 'receipts/${DateTime.now()}_';

      final app = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: DefaultFirebaseOptions.currentPlatform.storageBucket,
        app: app,
      );

      final reference = storage.ref().child(filePath);
      await reference.putFile(selectedFile);
      final downloadUrl = await reference.getDownloadURL();

      return {
        'downloadUrl': downloadUrl,
        'fileName': selectedFile.path.split('/').last,
      };
    } catch (error) {
      rethrow;
    }
  }

  Future<void> downloadImage(String url) async {
    final path = '${Directory.systemTemp.path}/done.jpg';
    await Dio().download(
      'url',
      path,
    );
    await Gal.putImage(path);
  }
}
