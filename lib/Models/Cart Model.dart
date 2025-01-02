import 'model.dart';

class CartItem {
  final Variant variant;
  int quantity;

  CartItem({
    required this.variant,
    this.quantity = 1,
  });
}
