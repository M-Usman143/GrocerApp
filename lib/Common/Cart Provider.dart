import 'package:flutter/foundation.dart';

import '../Models/Cart Model.dart';
import '../Models/model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _mainCartItems = [];
  final List<CartItem> _listViewCartItems = [];

  int get uniqueProductCount {
    final mainCartProductIds = _mainCartItems.map((item) => item.variant.var_id).toSet();
    final listViewCartProductIds = _listViewCartItems.map((item) => item.variant.var_id).toSet();

    final combinedProductIds = {...mainCartProductIds, ...listViewCartProductIds};
    return combinedProductIds.isEmpty ? 0 : combinedProductIds.length;
  }

  List<CartItem> get mainCartItems => _mainCartItems;
  List<CartItem> get listViewCartItems => _listViewCartItems;

  // Add to main cart
  void addToMainCart(Variant variant) {
    final mainCartIndex = _mainCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);

    // If product exists in main cart, update its quantity
    if (mainCartIndex != -1) {
      _mainCartItems[mainCartIndex].quantity++;
    } else {
      // Add product to main cart if not already present
      _mainCartItems.add(CartItem(variant: variant, quantity: 1));
    }

    // Ensure product is not in the listView cart before adding
    _removeFromListView(variant);

    notifyListeners();
  }

  // Add to ListView cart
  void addToListViewCart(Variant variant) {
    final listViewIndex = _listViewCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);

    // If product exists in listView cart, update its quantity
    if (listViewIndex != -1) {
      _listViewCartItems[listViewIndex].quantity++;
    } else {
      // If not already in listView, add it
      _listViewCartItems.add(CartItem(variant: variant, quantity: 1));
    }

    // Product remains in main cart, no need to remove it there
    notifyListeners();
  }

  // Remove product from ListView if exists
  void _removeFromListView(Variant variant) {
    _listViewCartItems.removeWhere((item) => item.variant.var_id == variant.var_id);
  }

  // Remove from main cart
  void removeFromMainCart(String productId) {
    _mainCartItems.removeWhere((item) => item.variant.var_id == productId);
    notifyListeners();
  }

  // Remove from ListView cart
  void removeFromListViewCart(String productId) {
    _listViewCartItems.removeWhere((item) => item.variant.var_id == productId);
    notifyListeners();
  }

  // Update main cart quantity
  void updateMainCartQuantity(String productId, int newQuantity) {
    final index = _mainCartItems.indexWhere((item) => item.variant.var_id == productId);

    if (index != -1) {
      if (newQuantity <= 0) {
        _mainCartItems.removeAt(index);  // Remove the product if quantity reaches 0
      } else {
        _mainCartItems[index].quantity = newQuantity; // Update the quantity
      }
    }

    notifyListeners();
  }

  // Update ListView cart quantity
  void updateListViewCartQuantity(String productId, int newQuantity) {
    final index = _listViewCartItems.indexWhere((item) => item.variant.var_id == productId);

    if (index != -1) {
      if (newQuantity <= 0) {
        _listViewCartItems.removeAt(index);  // Remove product if quantity reaches 0
      } else {
        _listViewCartItems[index].quantity = newQuantity; // Update quantity
      }
    }

    notifyListeners();
  }

  // Get total price for main cart
  double get mainCartTotalPrice {
    return _mainCartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.variant.curr_price) ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  // Get total price for ListView cart
  double get listViewCartTotalPrice {
    return _listViewCartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.variant.curr_price) ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  // Get total item count for main cart
  int get mainCartTotalItemCount {
    return _mainCartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total item count for ListView cart
  int get listViewCartTotalItemCount {
    return _listViewCartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Clear main cart
  void clearMainCart() {
    _mainCartItems.clear();
    notifyListeners();
  }

  // Clear ListView cart
  void clearListViewCart() {
    _listViewCartItems.clear();
    notifyListeners();
  }

  // Get quantity of a product in the main cart
  int getMainCartQuantityOfProduct(Variant product) {
    final item = _mainCartItems.firstWhere(
          (cartItem) => cartItem.variant.var_id == product.var_id,
      orElse: () => CartItem(variant: product, quantity: 0),
    );
    return item.quantity;
  }

  // Get quantity of a product in the ListView cart
  int getListViewCartQuantityOfProduct(Variant product) {
    final item = _listViewCartItems.firstWhere(
          (cartItem) => cartItem.variant.var_id == product.var_id,
      orElse: () => CartItem(variant: product, quantity: 0),
    );
    return item.quantity;
  }

  double getTotalCost() {
    double total = 0;

    // For mainCartItems
    for (var item in mainCartItems) {
      final price = double.tryParse(item.variant.curr_price) ?? 0.0; // Parsing curr_price as double
      total += price * item.quantity;
    }

    // For listViewCartItems
    for (var item in listViewCartItems) {
      final price = double.tryParse(item.variant.curr_price) ?? 0.0; // Parsing curr_price as double
      total += price * item.quantity;
    }

    return total;
  }

  bool isProductInCart(Variant variant) {
    final cartItem = _mainCartItems.firstWhere(
          (item) => item.variant.var_id == variant.var_id,
      orElse: () => CartItem(variant: variant, quantity: 0),
    );
    return cartItem.quantity > 0;
  }

  /// Returns the number of unique products in the cart (not counting quantities)
  int getTotalItems() {
    return _mainCartItems.length;
  }

  /// Returns the quantity of a specific variant in the cart
  int getItemCount(Variant variant) {
    for (var item in _mainCartItems) {
      if (item.variant.var_id == variant.var_id) {
        return item.quantity;
      }
    }
    return 0;
  }

  /// Decreases the quantity of a variant in the cart by 1
  void decreaseItemQuantity(Variant variant) {
    for (int i = 0; i < _mainCartItems.length; i++) {
      if (_mainCartItems[i].variant.var_id == variant.var_id) {
        if (_mainCartItems[i].quantity > 1) {
          _mainCartItems[i] = CartItem(
            variant: _mainCartItems[i].variant,
            quantity: _mainCartItems[i].quantity - 1,
          );
          notifyListeners();
        } else {
          removeFromMainCart(variant.var_id);
        }
        return;
      }
    }
  }

  /// Increases the quantity of a variant in the cart by 1
  void increaseItemQuantity(Variant variant) {
    for (int i = 0; i < _mainCartItems.length; i++) {
      if (_mainCartItems[i].variant.var_id == variant.var_id) {
        _mainCartItems[i] = CartItem(
          variant: _mainCartItems[i].variant,
          quantity: _mainCartItems[i].quantity + 1,
        );
        notifyListeners();
        return;
      }
    }
    // If variant not in cart, add it
    addToMainCart(variant);
  }

  /// Removes a variant from the cart entirely
  void removeFromCart(Variant variant) {
    removeFromMainCart(variant.var_id);
  }
}
