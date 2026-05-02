class Cart {
  final String restaurantId;
  final String productId;
  final String cartId;
  final String cartTitle;
  final List<dynamic>? variationTitle;
  final int cartQuantity;
  final double cartPrice;
  final String? cartSpecialRequests;

  Cart({
    required this.restaurantId,
    required this.productId,
    required this.cartId,
    required this.cartTitle,
    required this.variationTitle,
    required this.cartQuantity,
    required this.cartPrice,
    required this.cartSpecialRequests,
  });
}
