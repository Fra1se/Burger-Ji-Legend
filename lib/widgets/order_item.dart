import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
//...packages

import '../models/order_info.dart';
import '../models/order.dart';
import '../providers/cart_data.dart';
import '../providers/restaurant_data.dart';
import '../providers/order_data.dart';
//...providers

import '../screens/payment_screen.dart';
import '../screens/address_form_screen.dart';
//...screens

import '../widget_lists/order_list.dart';
//...widgets

class OrderItem extends StatefulWidget {
  const OrderItem({super.key});

  @override
  OrderItemState createState() => OrderItemState();
}

class OrderItemState extends State<OrderItem> {
  final _form = GlobalKey<FormState>();

  DateTime date = DateTime.now();
  DateTime time = DateTime.now();

  bool dateValidator = false;
  bool timeValidator = false;

  ReceiveOptions? _receive;

  bool? isAsap;
  //...

  String? inputNum = '';

  String customerName = '';
  DateTime orderDateTime = DateTime.now();
  int numberOfPeople = 1;
  String phoneNumber = '';
  String? specialRequests;
  //...

  final _nameFocusNode = FocusNode();
  final _numberOfPplFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _specialRequestsFocusNode = FocusNode();

  String? _initialName;
  String? _initialNumberOfPpl;
  String? _initialPhoneNumber;
  //...

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _numberOfPplFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _specialRequestsFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible) {
        _nameFocusNode.unfocus();
        _numberOfPplFocusNode.unfocus();
        _phoneNumberFocusNode.unfocus();
        _specialRequestsFocusNode.unfocus();
      }
    });

    final details = Provider.of<Orders>(context, listen: false).details;

    if (details != null) {
      _initialName = details['customerName'];
      _initialPhoneNumber = details['phoneNumber'];
      _initialNumberOfPpl = details['numberOfPeople'];
    }

    super.initState();
  }
  //...

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context, listen: false);
    final restaurants = Provider.of<Restaurants>(context, listen: false);
    final cart = Provider.of<Carts>(context, listen: false);

    final restaurant = restaurants.selectedRestaurant;
    //...

    final scrollBarController = ScrollController();
    //...

    Widget dividerBuilder() {
      return Divider(color: Theme.of(context).colorScheme.shadow, height: 0, thickness: 1);
    }

    Widget textFormFieldBuilder({
      FocusNode? focusNode,
      String? initialValue,
      TextInputAction? textInputAction,
      TextInputType? keyboardType,
      String? hintText,
      String? Function(String?)? validator,
      void Function(String?)? onSaved,
      int? maxLines,
    }) {
      return TextFormField(
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        maxLines: maxLines,
        focusNode: focusNode,
        initialValue: initialValue,
        decoration: InputDecoration(
          isCollapsed: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 15),
        cursorColor: Colors.black,
        onEditingComplete: () {
          focusNode!.unfocus();
        },
        validator: validator,
        onSaved: onSaved,
      );
    }

    Widget headerBuilder(String text) {
      return Padding(
        padding: const EdgeInsets.only(top: 5, left: 8.0, bottom: 5),
        child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black)),
      );
    }

    void alertDialog({String title = '', String content = '', String chContent = ''}) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [if (content != '') Text(content), if (chContent != '') Text(chContent)],
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

    //...

    return Expanded(
      child: RawScrollbar(
        controller: scrollBarController,
        thickness: 5,
        thumbColor: Theme.of(context).colorScheme.secondary,
        radius: const Radius.circular(5),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollBarController,
          physics: const ScrollPhysics(),
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: RadioGroup<ReceiveOptions>(
                groupValue: _receive,
                onChanged: (value) async {
                  if (value == ReceiveOptions.delivery) {
                    if (value == null) {
                      return setState(() {
                        _receive = value;
                      });
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => PopScope(
                        onPopInvokedWithResult: (_, _) => Future.value(false),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    );

                    final nav = Navigator.of(context);

                    await Provider.of<Orders>(context, listen: false).receiveAddres();

                    nav.pop();

                    final response = await nav.pushNamed(AddressFormScreen.routeName);

                    setState(() {
                      if (response == false || response == null) {
                        _receive = null;
                      } else {
                        _receive = value;
                      }
                    });
                  } else {
                    setState(() {
                      Provider.of<Carts>(context, listen: false).clearQuotations();
                      _receive = value;
                    });
                  }
                },
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerBuilder('Customer Name'),
                        textFormFieldBuilder(
                          focusNode: _nameFocusNode,
                          initialValue: _initialName,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          hintText: 'Your Name',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Your Name';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            customerName = value!;
                          },
                        ),
                        headerBuilder('No. of Person'),
                        textFormFieldBuilder(
                          focusNode: _numberOfPplFocusNode,
                          initialValue: _initialNumberOfPpl,
                          textInputAction: TextInputAction.done,
                          keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                          maxLines: 1,
                          hintText: 'No. of Person',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Number';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a Valid Number';
                            }
                            if (int.parse(value) <= 0) {
                              return 'Please enter a Number Greater Than 0';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            if (value != null && value != "") {
                              numberOfPeople = int.parse(value);
                            }
                          },
                        ),
                        headerBuilder('Mobile No.'),
                        Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 5, top: 2),
                                child: Text('+60', style: TextStyle(color: Colors.black, fontSize: 15)),
                              ),
                              Expanded(
                                child: textFormFieldBuilder(
                                  focusNode: _phoneNumberFocusNode,
                                  initialValue: _initialPhoneNumber,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.phone,
                                  hintText: 'Your Mobile No.',
                                  maxLines: 1,
                                  validator: (value) {
                                    RegExp regExp = RegExp(r'(^(\+?6?01)[02-46-9]-*[0-9]{7}$|^(\+?6?01)[1]-*[0-9]{8}$)');

                                    if (value == null) {
                                      return 'Please enter Mobile No.';
                                    } else if (!regExp.hasMatch(phoneNumber)) {
                                      return 'Please enter a Valid Phone Number';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    inputNum = value;
                                    phoneNumber = '+60$value';
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const OrderList(),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAsap = false;
                        });
                        DatePicker.showDatePicker(
                          context,
                          maxTime: DateTime(DateTime.now().year + 5),
                          minTime: DateTime.now(),
                          onConfirm: (confirmedDate) {
                            setState(() {
                              orderDateTime = confirmedDate;
                              date = confirmedDate;
                              dateValidator = true;
                            });
                          },
                        );
                      },
                      child: Container(
                        color: isAsap == false ? const Color.fromARGB(255, 224, 224, 224) : Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Date:', style: TextStyle(fontSize: 14)),
                            Text(
                              DateFormat('EEE, dd/MM/yyyy').format(date),
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAsap = false;
                        });
                        DatePicker.showTime12hPicker(
                          context,
                          currentTime: date,
                          onConfirm: (confirmedTime) {
                            setState(() {
                              orderDateTime = confirmedTime;
                              time = confirmedTime;
                              timeValidator = true;
                            });
                          },
                        );
                      },
                      child: Container(
                        color: isAsap == false ? const Color.fromARGB(255, 224, 224, 224) : Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Time:', style: TextStyle(fontSize: 14)),
                            Text(
                              DateFormat('hh : mm aa').format(time),
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    headerBuilder('OR'),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isAsap = true;
                        });
                      },
                      child: Container(
                        color: isAsap == true ? const Color.fromARGB(255, 179, 179, 179) : Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text('Press Here for ASAP Delivery/Take-Away'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RadioListTile<ReceiveOptions>(
                      toggleable: true,
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Dine-In', style: TextStyle(fontSize: 14)),
                      tileColor: Theme.of(context).colorScheme.surface,
                      value: ReceiveOptions.dineIn,
                      enabled: restaurant.receiveExceptions?.dineIn != false,
                    ),
                    dividerBuilder(),
                    RadioListTile<ReceiveOptions>(
                      toggleable: true,
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Take-Away', style: TextStyle(fontSize: 14)),
                      tileColor: Theme.of(context).colorScheme.surface,
                      value: ReceiveOptions.takeAway,
                      enabled: restaurant.receiveExceptions?.takeAway != false,
                    ),
                    dividerBuilder(),
                    RadioListTile<ReceiveOptions>(
                      toggleable: true,
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Delivery', style: TextStyle(fontSize: 14)),
                      tileColor: Theme.of(context).colorScheme.surface,
                      value: ReceiveOptions.delivery,
                      enabled: restaurant.receiveExceptions?.delivery != false && restaurant.lalamove != null,
                    ),
                    const SizedBox(height: 10),
                    textFormFieldBuilder(
                      focusNode: _specialRequestsFocusNode,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      hintText: 'Special Requests',
                      onSaved: (value) {
                        specialRequests = value;
                      },
                    ),
                    const SizedBox(height: 2.5),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                        ),
                        icon: Icon(Icons.alarm, color: Theme.of(context).colorScheme.onPrimary, size: 18),
                        label: Text(
                          'Order Now',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 13),
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          _form.currentState!.save();

                          final isValid = _form.currentState!.validate();
                          final nav = Navigator.of(context);
                          final dateTimeNow = DateTime.now();

                          Future showAlert(Widget Function(BuildContext) builder) {
                            return showDialog(context: context, builder: builder);
                          }

                          await orders.saveDetails(customerName, numberOfPeople.toString(), inputNum!);

                          if (!isValid) {
                            alertDialog(title: 'Alert', content: 'Please Fill In All Information');
                            return;
                          }
                          if (isAsap == null) {
                            alertDialog(title: 'Alert', content: 'Please Choose Time');
                            return;
                          }
                          if (isAsap == false && orderDateTime.isBefore(dateTimeNow)) {
                            alertDialog(title: 'Alert', content: 'Please Choose Time Again');
                            return;
                          }
                          if (_receive == null) {
                            alertDialog(title: 'Alert', content: 'Please Choose A Pick Up Option');
                            return;
                          }
                          if (_receive == ReceiveOptions.delivery &&
                              (orders.orderAddress?.addressValidate == false ||
                                  orders.orderAddress?.addressValidate == null)) {
                            alertDialog(title: 'Alert', content: 'Please Fill In Delivery Address Again');
                            return;
                          }

                          final response = await showAlert(
                            (ctx) => AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text('Order Now?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('YES'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('NO'),
                                ),
                              ],
                            ),
                          );

                          if (response == false || response == null) {
                            return;
                          }

                          Map<String, dynamic>? quote;

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => PopScope(
                                onPopInvokedWithResult: (_, _) => Future.value(false),
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                            );
                          }

                          if (_receive == ReceiveOptions.delivery && context.mounted) {
                            quote = await orders.getQuotations(
                              apiKey: restaurant.lalamove!['apiKey'],
                              apiSecret: restaurant.lalamove!['apiSecret'],
                              context: context,
                              time: dateTimeNow.millisecondsSinceEpoch.toString(),
                              scheduledAt: isAsap == true ? null : orderDateTime.toUtc().toIso8601String(),
                              //...
                              restaurantName: restaurant.restaurantTitle,
                              restaurantRawNumber: restaurant.rawNumber,
                              customerName: customerName,
                              customerNumber: phoneNumber,
                              //...
                              restaurantAddress: restaurant.address['addressLine'],
                              restaurantLat: restaurant.address['lat'],
                              restaurantLng: restaurant.address['lng'],
                              //...
                              customerAddress: orders.orderAddress!.address,
                              customerLat: orders.orderAddress!.latitude,
                              customerLng: orders.orderAddress!.longitude,
                            );
                          }

                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }

                          if (_receive == ReceiveOptions.delivery && quote?['quotationId'] == null) {
                            showAlert(
                              (ctx) => AlertDialog(
                                title: const Text('ERROR'),
                                content: const Text("There was an error with getting a delivery price"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          nav.pushNamed(
                            PaymentScreen.routeName,
                            arguments: {
                              'orderInfo': OrderInfo(
                                lalamoveInfo: _receive != ReceiveOptions.delivery
                                    ? null
                                    : LalamoveDeliveryInfo(
                                        quotationId: quote!['quotationId'],
                                        restaurantStopId: quote['restaurantStopId'],
                                        customerStopId: quote['customerStopId'],
                                        restaurantAddress: restaurant.address['addressLine'],
                                        restaurantLat: restaurant.address['lat'],
                                        restaurantLng: restaurant.address['lng'],
                                        customerAddress: orders.orderAddress!.address,
                                        customerLat: orders.orderAddress!.latitude,
                                        customerLng: orders.orderAddress!.longitude,
                                        customerState: orders.orderAddress!.state,
                                        customerDistrict: orders.orderAddress!.district,
                                        customerSubDistrict: orders.orderAddress!.subDistrict,
                                        customerPostalCode: orders.orderAddress!.postalCode,
                                      ),
                                resUserId: restaurant.restaurantUserId,
                                scheduledAt: isAsap == true ? null : orderDateTime,
                                numPax: numberOfPeople,
                                receive: _receive!,
                                specialRequests: specialRequests,
                                resName: restaurant.restaurantTitle,
                                resNumber: restaurant.rawNumber,
                                cusName: customerName,
                                cusNumber: phoneNumber,
                                products: [...cart.items],
                              ),
                              'restaurantPaymentDetails': restaurant.paymentDetails,
                              'restaurantLalamove': restaurant.lalamove,
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
