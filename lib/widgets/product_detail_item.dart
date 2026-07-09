import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
//...packages

import '../models/product.dart';
import '../providers/restaurant_data.dart';
import '../providers/cart_data.dart';
import '../providers/product_data.dart';
import '../providers/variations.dart';
//...providers

import '../screens/cart_screen.dart';
//...screens

class ProductDetailItem extends StatefulWidget {
  const ProductDetailItem({super.key});

  @override
  ProductDetailItemState createState() => ProductDetailItemState();
}

class ProductDetailItemState extends State<ProductDetailItem> {
  var productQuantity = 0;
  final scrollBarController = ScrollController();

  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen(
      (visible) {
        if (!visible && context.mounted) {
          _descriptionFocusNode.unfocus();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final productId = routeArgs['productId'];
    final restaurantId = routeArgs['restaurantId'];
    final isOut = routeArgs['isOut'];
    //...RouteArgs

    final productById = Provider.of<Products>(context, listen: false).findById(productId!);
    final restaurantById = Provider.of<Restaurants>(context).findById(restaurantId);
    //...Providers

    Widget textBuilder(String text, double size) {
      return SelectableText(
        text,
        style: TextStyle(
          fontSize: size,
        ),
      );
    }

    Widget contactInfoBuilder(IconData iconData, String text) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: textBuilder(
              text,
              13,
            ),
          ),
        ],
      );
    }

    Widget cardBuilder(List<Widget> children) {
      return Card(
        elevation: 3,
        margin: const EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 15,
          ),
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      );
    }

    //...

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: RawScrollbar(
        controller: scrollBarController,
        thickness: 5,
        thumbColor: Theme.of(context).colorScheme.secondary,
        radius: const Radius.circular(5),
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollBarController,
          child: Container(
            padding: const EdgeInsets.only(
              right: 5,
              top: 20,
              bottom: 20,
            ),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: productById.productImageUrl == ''
                        ? Container(
                            color: Theme.of(context).colorScheme.secondary,
                            height: 210,
                            width: double.infinity,
                            child: const Center(
                              child: Text('Empty'),
                            ),
                          )
                        : Image.network(
                            productById.productImageUrl,
                            fit: BoxFit.cover,
                            height: 210,
                            width: double.infinity,
                          ),
                  ),
                ),
                cardBuilder(
                  [
                    textBuilder(
                      productById.productTitle,
                      15,
                    ),
                    if (productById.productChTitle != '')
                      textBuilder(
                        productById.productChTitle,
                        15,
                      ),
                    const Divider(),
                    textBuilder(
                      'MYR ${productById.productPrice}',
                      15,
                    ),
                    const Divider(),
                    textBuilder(
                      'Serving for ${productById.productServeAmount} Person(s)',
                      15,
                    ),
                    const Divider(),
                    textBuilder(
                      productById.productOrderHours != null
                          ? 'Order in Advance ${productById.productOrderHours} Hour(s)'
                          : 'Order in Advance ${productById.productOrderMins} Minutes',
                      15,
                    ),
                  ],
                ),
                cardBuilder(
                  [
                    if (productById.productExtraInfo != '')
                      textBuilder(
                        productById.productExtraInfo,
                        13,
                      ),
                  ],
                ),
                cardBuilder(
                  [
                    if (restaurantById.openTime != '')
                      textBuilder(
                        restaurantById.openTime,
                        13,
                      ),
                    if (restaurantById.openTime != '' &&
                        (restaurantById.address['addressLine'] != '' && restaurantById.address['addressLine'] != null))
                      const Divider(),
                    if (restaurantById.address['addressLine'] != '' && restaurantById.address['addressLine'] != null)
                      textBuilder(
                        restaurantById.address['addressLine']!,
                        13,
                      ),

                    //...
                    if (restaurantById.googleMapLink != '') const Divider(),
                    if (restaurantById.googleMapLink != '')
                      contactInfoBuilder(
                        Icons.place_rounded,
                        restaurantById.googleMapLink,
                      ),

                    if (restaurantById.number != '') const Divider(),
                    if (restaurantById.number != '')
                      contactInfoBuilder(
                        Icons.call_rounded,
                        restaurantById.number,
                      ),

                    if (restaurantById.email != '') const Divider(),
                    if (restaurantById.email != '')
                      contactInfoBuilder(
                        Icons.email_rounded,
                        restaurantById.email,
                      ),

                    if (restaurantById.whatsApp != '') const Divider(),
                    if (restaurantById.whatsApp != '')
                      contactInfoBuilder(
                        FontAwesomeIcons.whatsapp,
                        restaurantById.whatsApp,
                      ),

                    if (restaurantById.tiktok != '') const Divider(),
                    if (restaurantById.tiktok != '')
                      contactInfoBuilder(
                        FontAwesomeIcons.tiktok,
                        restaurantById.tiktok,
                      ),

                    if (restaurantById.facebook != '') const Divider(),
                    if (restaurantById.facebook != '')
                      contactInfoBuilder(
                        Icons.facebook,
                        restaurantById.facebook,
                      ),

                    if (restaurantById.instagram != '') const Divider(),
                    if (restaurantById.instagram != '')
                      contactInfoBuilder(
                        FontAwesomeIcons.instagram,
                        restaurantById.instagram,
                      ),
                  ],
                ),
                cardBuilder(
                  [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  child: Icon(
                                    Icons.remove,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    size: 15,
                                  ),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (productQuantity <= 0) {
                                    return;
                                  } else {
                                    setState(() {
                                      productQuantity--;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(width: 10),
                              Text('$productQuantity'),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    size: 15,
                                  ),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    productQuantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primaryContainer,
                        contentPadding: const EdgeInsets.all(10),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Special Requests',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.shadow,
                          fontSize: 15,
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 15,
                      ),
                      cursorColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      maxLines: 2,
                    ),
                    // const SizedBox(height: 6),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: TextButton.icon(
                    //     style: ButtonStyle(
                    //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //         RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //       ),
                    //       backgroundColor: MaterialStateProperty.all<Color>(
                    //         Theme.of(context).colorScheme.primaryContainer,
                    //       ),
                    //     ),
                    //     icon: Icon(
                    //       Icons.share,
                    //       color: Theme.of(context).colorScheme.onPrimaryContainer,
                    //       size: 18,
                    //     ),
                    //     label: Text(
                    //       'Share This Page',
                    //       style: TextStyle(
                    //         color: Theme.of(context).colorScheme.onPrimaryContainer,
                    //         fontSize: 13,
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       FocusScope.of(context).unfocus();
                    //     },
                    //   ),
                    // ),
                    Consumer<Carts>(
                      builder: (context, cart, ch) => SizedBox(
                        width: double.infinity,
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
                          icon: Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 18,
                          ),
                          label: Text(
                            'Add to My Cart',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 13,
                            ),
                          ),
                          onPressed: () async {
                            showAlert(
                              String title,
                              String content,
                            ) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(title),
                                  content: Text(content),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'OK',
                                      ),
                                      onPressed: () => Navigator.of(ctx).pop(),
                                    ),
                                  ],
                                ),
                              );
                            }

                            FocusScope.of(context).unfocus();

                            if (restaurantById.isClosed == true) {
                              return showAlert(
                                'Closed',
                                'Merchant is Now Closed',
                              );
                            }
                            if (restaurantById.isClosed == true) {
                              return showAlert(
                                'Temporarily Closed',
                                'Too Many Orders\nTry Again in 1 Hour',
                              );
                            }
                            if (isOut == true) {
                              return showAlert(
                                'Out of Stock',
                                'No More Stock',
                              );
                            }
                            if (productQuantity <= 0) {
                              return showAlert(
                                'Alert',
                                'Insert Quantity to Order',
                              );
                            }

                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            final nav = Navigator.of(context);
                            final vari = Provider.of<Variations>(context, listen: false);
                            final extraIsValid = [];

                            vari.disposeValues();

                            dynamic response;

                            if (productById.variations != null) {
                              final map = productById.variations!;
                              final variController = ScrollController();

                              ProductVariations? baseValue;
                              if (map['base'] == null) {
                                vari.setBaseValue = ProductVariations(
                                  title: '',
                                  price: productById.productRawPrice,
                                  isOut: false,
                                );
                              }

                              response = await showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SingleChildScrollView(
                                      controller: variController,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (map['base'] != null)
                                                Text(
                                                  map['base']['title'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (map['base'] != null) const SizedBox(height: 5),
                                              if (map['base'] != null)
                                                StatefulBuilder(
                                                  builder: (_, setBaseState) {
                                                    return RadioGroup<ProductVariations>(
                                                      groupValue: baseValue,
                                                      onChanged: (value) {
                                                        setBaseState(() {
                                                          baseValue = value;
                                                        });

                                                        vari.setBaseValue = value;
                                                        vari.notify();
                                                      },
                                                      child: ListView.builder(
                                                        controller: variController,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: map['base']['list'].length,
                                                        itemBuilder: (_, i) {
                                                          final item = map['base']['list'][i];
                                                          return RadioListTile<ProductVariations>(
                                                            value: item,
                                                            title: Text(item.title),
                                                            toggleable: true,
                                                            subtitle: Text(
                                                              'MYR  ${(item.price as double).toStringAsFixed(2)}',
                                                            ),
                                                            enabled: !item.isOut,
                                                          );

                                                          // RadioListTile<ProductVariations>(
                                                          //   toggleable: true,
                                                          //   title: Text(item.title),
                                                          //   subtitle: Text(
                                                          //     'MYR  ${(item.price as double).toStringAsFixed(2)}',
                                                          //   ),
                                                          //   value: item,
                                                          //   groupValue: baseValue,
                                                          //   onChanged: item.isOut
                                                          //       ? null
                                                          //       : (value) {
                                                          //           setBaseState(() {
                                                          //             baseValue = value;
                                                          //           });

                                                          //           vari.setBaseValue = value;
                                                          //           vari.notify();
                                                          //         },
                                                          // );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              if (map['base'] != null) const SizedBox(height: 10),
                                              if (map['extra'] != null)
                                                ListView.builder(
                                                  controller: variController,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: map['extra'].length,
                                                  itemBuilder: (context, index) {
                                                    ProductVariations? extraValue;
                                                    if (map['extra'][index]['isRequired'] == true) {
                                                      extraIsValid.add(false);
                                                    }
                                                    return Column(
                                                      children: [
                                                        Text(
                                                          map['extra'][index]['title'],
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        if (map['extra'][index]['isRequired'] == true)
                                                          Text(
                                                            '*Required',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Theme.of(context).colorScheme.error,
                                                            ),
                                                          ),
                                                        map['extra'][index]['isSingle'] == true
                                                            ? StatefulBuilder(
                                                                builder: (_, setExtraState) {
                                                                  return RadioGroup<ProductVariations>(
                                                                    groupValue: extraValue,
                                                                    onChanged: (value) {
                                                                      setExtraState(() {
                                                                        extraValue = value;
                                                                        if (map['extra'][index]['isRequired'] == true) {
                                                                          extraIsValid[index] = value == null ? false : true;
                                                                        }
                                                                      });

                                                                      vari.setExtraValue = value == null
                                                                          ? {'$index': null}
                                                                          : {'$index': value};
                                                                      vari.notify();
                                                                    },
                                                                    child: ListView.builder(
                                                                      controller: variController,
                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                      shrinkWrap: true,
                                                                      itemCount: map['extra'][index]['list'].length,
                                                                      itemBuilder: (context, i) {
                                                                        final item =
                                                                            map['extra'][index]['list'][i]
                                                                                as ProductVariations;

                                                                        return RadioListTile<ProductVariations>(
                                                                          value: item,
                                                                          title: Text(item.title),
                                                                          toggleable: true,
                                                                          subtitle: Text(
                                                                            'MYR  ${(item.price).toStringAsFixed(2)}',
                                                                          ),
                                                                          enabled: item.isOut ?? false ? false : true,
                                                                        );

                                                                        // RadioListTile<ProductVariations>(
                                                                        //   toggleable: true,
                                                                        //   title: Text(item.title),
                                                                        //   subtitle: Text(
                                                                        //     'MYR  ${(item.price).toStringAsFixed(2)}',
                                                                        //   ),
                                                                        //   value: item,
                                                                        //   groupValue: extraValue,
                                                                        //   onChanged: item.isOut == true
                                                                        //       ? null
                                                                        //       : (value) {
                                                                        //           setExtraState(() {
                                                                        //             extraValue = value;
                                                                        //             if (map['extra'][index]['isRequired'] ==
                                                                        //                 true) {
                                                                        //               extraIsValid[index] = value == null
                                                                        //                   ? false
                                                                        //                   : true;
                                                                        //             }
                                                                        //           });

                                                                        //           vari.setExtraValue = value == null
                                                                        //               ? {'$index': null}
                                                                        //               : {'$index': value};
                                                                        //           vari.notify();
                                                                        //         },
                                                                        // );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : ListView.builder(
                                                                controller: variController,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                shrinkWrap: true,
                                                                itemCount: map['extra'][index]['list'].length,
                                                                itemBuilder: (context, i) {
                                                                  final item =
                                                                      map['extra'][index]['list'][i] as ProductVariations;
                                                                  bool? select = false;

                                                                  return StatefulBuilder(
                                                                    builder: (_, setExtraState) {
                                                                      return CheckboxListTile(
                                                                        title: Text(item.title),
                                                                        subtitle: Text(
                                                                          'MYR ${(item.price).toStringAsFixed(2)}',
                                                                        ),
                                                                        controlAffinity: ListTileControlAffinity.leading,
                                                                        value: select,
                                                                        onChanged: item.isOut == true
                                                                            ? null
                                                                            : (value) {
                                                                                setExtraState(() {
                                                                                  select = value;
                                                                                  if (map['extra'][index]['isRequired'] ==
                                                                                      true) {
                                                                                    extraIsValid[index] =
                                                                                        (value == false || value == null)
                                                                                        ? false
                                                                                        : true;
                                                                                  }
                                                                                });

                                                                                vari.setExtraValue = select == false
                                                                                    ? {'$index$i': null}
                                                                                    : {'$index$i': item};
                                                                                vari.notify();
                                                                              },
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Total',
                                                      style: TextStyle(fontSize: 15),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: Container(
                                                        color: Theme.of(context).colorScheme.primary,
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                        child: Consumer<Variations>(
                                                          builder: (ctx, vari, _) {
                                                            return Text(
                                                              'MYR ${(vari.totalPrice).toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                color: Theme.of(context).colorScheme.onPrimary,
                                                                fontSize: 15,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 15),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop(false);
                                                      },
                                                    ),
                                                    const SizedBox(width: 15),
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        backgroundColor: WidgetStateProperty.all(
                                                          Theme.of(context).colorScheme.primary,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Confirm',
                                                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                                      ),
                                                      onPressed: () {
                                                        if (vari.baseValue == null) {
                                                          return showAlert(
                                                            'Alert',
                                                            'Please Select 1',
                                                          );
                                                        }
                                                        if (extraIsValid.contains(false)) {
                                                          return showAlert(
                                                            'Alert',
                                                            'Please Select 1',
                                                          );
                                                        }
                                                        Navigator.of(ctx).pop(true);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (productById.variations != null && (response == false || response == null)) {
                              return nav.pop();
                            }

                            try {
                              await cart.addItem(
                                restaurantId: restaurantId,
                                productId: productId,
                                id: DateTime.now().toString(),
                                price: productById.variations == null ? productById.productRawPrice : vari.totalPrice,
                                title: productById.productTitle,
                                variationTitle: productById.variations == null ? null : vari.totalTitle,
                                quantity: productQuantity,
                                specialRequests: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                              );
                            } catch (error) {
                              return showAlert('Error', 'Sorry there was an error');
                            }

                            if (context.mounted) {
                              Provider.of<Restaurants>(context, listen: false).setResId = restaurantId;
                            }

                            nav.pop();
                            nav.pushNamed(CartScreen.routeName);

                            _descriptionController.clear();

                            setState(() {
                              productQuantity = 0;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
