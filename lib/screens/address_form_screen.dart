import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'package:geocoding/geocoding.dart' as geoCode;
//...packages

import '../providers/order_data.dart';
//...providers

import '../models/order_address.dart';
//...models

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  static const routeName = '/location-screen';

  @override
  AddressFormScreenState createState() => AddressFormScreenState();
}

class AddressFormScreenState extends State<AddressFormScreen> {
  final _form = GlobalKey<FormState>();

  final _addressFocusNode = FocusNode();
  final _postalCodeFocusNode = FocusNode();

  String? _address;
  String? _postalCode;

  String? _stateValue;
  String? _districtValue;
  String? _subDistrictValue;

  @override
  void dispose() {
    _addressFocusNode.dispose();
    _postalCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardVisibilityController.onChange.listen((visible) {
      if (!visible) {
        _addressFocusNode.unfocus();
        _postalCodeFocusNode.unfocus();
      }
    });

    _stateValue = addressState.keys.first;
    _districtValue = addressState.entries.first.value.keys.first;
    _subDistrictValue =
        addressState.entries.first.value.entries.first.value.first;

    final details = Provider.of<Orders>(context, listen: false).orderAddress;
    if (details?.state != null) {
      _stateValue = details!.state;
    }
    if (details?.district != null) {
      _districtValue = details!.district;
    }
    if (details?.subDistrict != null) {
      _subDistrictValue = details!.subDistrict;
    }

    super.initState();
  }
  //...

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final orders = Provider.of<Orders>(context, listen: false);
    //...

    Widget textFormFieldBuilder({
      required FocusNode focusNode,
      TextInputAction? textInputAction,
      TextInputType? keyboardType,
      String? hintText,
      String? Function(String?)? validator,
      String? Function(String?)? onSaved,
      String? initialValue,
    }) {
      return TextFormField(
        focusNode: focusNode,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
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
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        cursorColor: Colors.black,
        validator: validator,
        onEditingComplete: () {
          focusNode.unfocus();
        },
        onSaved: onSaved,
      );
    }

    Widget titleTextBuilder({
      required Widget title,
    }) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 5,
          left: 8.0,
          right: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
          ],
        ),
      );
    }

    Widget dropDownBuilder({
      required BuildContext context,
      required List<String> items,
      required String value,
      required Function(String?) onChanged,
    }) {
      return FormField<String>(builder: (context) {
        return InputDecorator(
          decoration: const InputDecoration(
            isCollapsed: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                dropdownColor: Colors.white,
                menuMaxHeight: 200,
                iconSize: 20,
                isExpanded: true,
                isDense: true,
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      });
    }
    //...

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Delivery Address')),
      body: LayoutBuilder(builder: (context, constraints) {
        return RawScrollbar(
          controller: scrollController,
          thickness: 5,
          thumbColor: Colors.blueAccent,
          radius: const Radius.circular(5),
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 20,
                      top: 15,
                      bottom: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleTextBuilder(
                          title: const Text(
                            'State',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        dropDownBuilder(
                            context: context,
                            items: addressState.keys.toList(),
                            value: _stateValue!,
                            onChanged: (value) {
                              if (_stateValue == value) {
                                return;
                              }
                              setState(() {
                                _stateValue = value!;
                                _districtValue =
                                    addressState[value]!.keys.first;
                                _subDistrictValue =
                                    addressState[value]![_districtValue]!.first;
                              });
                            }),
                        titleTextBuilder(
                          title: const Text(
                            'District',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        dropDownBuilder(
                            context: context,
                            items: addressState[_stateValue]!.keys.toList(),
                            value: _districtValue!,
                            onChanged: (value) {
                              if (_districtValue == value!) {
                                return;
                              }
                              setState(() {
                                _districtValue = value;
                                _subDistrictValue =
                                    addressState[_stateValue]![value]!.first;
                              });
                            }),
                        titleTextBuilder(
                          title: const Text(
                            'Sub-District',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        dropDownBuilder(
                            context: context,
                            items: addressState[_stateValue]![_districtValue]!,
                            value: _subDistrictValue!,
                            onChanged: (value) {
                              if (_subDistrictValue == value) {
                                return;
                              }
                              setState(() {
                                _subDistrictValue = value!;
                              });
                            }),
                        titleTextBuilder(
                          title: const Text(
                            'Postal Code',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        textFormFieldBuilder(
                          focusNode: _postalCodeFocusNode,
                          hintText: '58200',
                          initialValue: orders.orderAddress?.postalCode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Postal Code';
                            } else {
                              _postalCode = value;
                              return null;
                            }
                          },
                        ),
                        titleTextBuilder(
                          title: Text(
                            '*Full Delivery Address',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        textFormFieldBuilder(
                          focusNode: _addressFocusNode,
                          initialValue: orders.orderAddress?.address,
                          hintText:
                              '8-8-8, Block 8A, Suria Condominium, Jalan Sepadu, Taman United, 58200 Kuala Lumpur',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Delivery Address';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _address = value;
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Colors.grey.shade800,
                                  ),
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                ),
                                child: const Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  final nav = Navigator.of(context);

                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (ctx) {
                                        return Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const CircularProgressIndicator(),
                                            const SizedBox(height: 5),
                                            Container(
                                              color: Colors.black38,
                                              padding: const EdgeInsets.all(10),
                                              child: const Text(
                                                'If Delay, Go Back & Try Again',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ));
                                      });

                                  _form.currentState!.save();

                                  if (_form.currentState!.validate() == true) {
                                    try {
                                      final List<geoCode.Location> location =
                                          await geoCode
                                              .locationFromAddress(_address!);
                                      orders.setAddress = OrderAddress(
                                        addressValidate: true,
                                        address: _address!,
                                        latitude:
                                            location[0].latitude.toString(),
                                        longitude:
                                            location[0].longitude.toString(),
                                        state: _stateValue!,
                                        district: _districtValue!,
                                        subDistrict: _subDistrictValue!,
                                        postalCode: _postalCode.toString(),
                                      );

                                      await orders.saveAddress(
                                        address: _address!,
                                        postalCode: _postalCode!,
                                        state: _stateValue!,
                                        distrcit: _districtValue!,
                                        subDistrict: _subDistrictValue!,
                                      );

                                      nav.pop();
                                      nav.pop(true);
                                    } catch (error) {
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text(
                                              'ERROR',
                                            ),
                                            content: Text(error.toString()),
                                          ),
                                        );
                                      }
                                      nav.pop();
                                    }
                                  } else {
                                    nav.pop();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    Colors.grey.shade800,
                                  ),
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop(false);
                                  orders.setAddress = null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
