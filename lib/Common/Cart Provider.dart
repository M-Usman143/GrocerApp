// import 'package:flutter/foundation.dart';
// import '../Models/Cart Model.dart';
// import '../Models/model.dart';
//
// class CartProvider with ChangeNotifier {
//   final List<CartItem> _mainCartItems = [];
//   final List<CartItem> _listViewCartItems = [];
//
//   int get uniqueProductCount {
//     final mainCartProductIds = _mainCartItems.map((item) => item.variant.var_id).toSet();
//     final listViewCartProductIds = _listViewCartItems.map((item) => item.variant.var_id).toSet();
//
//
//     final combinedProductIds = {...mainCartProductIds, ...listViewCartProductIds};
//     return combinedProductIds.isEmpty ? 0 : combinedProductIds.length;
//   }
//
//
//   List<CartItem> get mainCartItems => _mainCartItems;
//   List<CartItem> get listViewCartItems => _listViewCartItems;
//
//   void addToMainCart(Variant variant) {
//     final listViewCartIndex = _listViewCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);
//     final mainCartIndex = _mainCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);
//
//     final index = _mainCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);
//
//     if (index != -1) {
//       _mainCartItems[index].quantity++;
//     } else {
//       _mainCartItems.add(CartItem(variant: variant));
//     }
//     // Sync quantity with ListViewCart
//     if (listViewCartIndex != -1) {
//       final listViewItem = _listViewCartItems[listViewCartIndex];
//
//       listViewItem.quantity = listViewItem.quantity; // Keep quantity intact from ListView
//     }
//
//
//     notifyListeners();
//   }
//
//
//
//
//   // Add to ListView cart
//   void addToListViewCart(Variant variant) {
//     final index = _listViewCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);
//     final mainCartIndex = _mainCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);
//     final listViewCartIndex = _listViewCartItems.indexWhere((item) => item.variant.var_id == variant.var_id);
//
//     if (index != -1) {
//       _listViewCartItems[index].quantity++;
//     } else {
//       _listViewCartItems.add(CartItem(variant: variant));
//     }
//
//     if (mainCartIndex != -1) {
//       _mainCartItems[mainCartIndex].quantity = _listViewCartItems[listViewCartIndex].quantity;
//     }
//     notifyListeners();
//   }
//
//
//
//   void removeFromMainCart(String productId) {
//     _mainCartItems.removeWhere((item) => item.variant.var_id == productId);
//     _listViewCartItems.removeWhere((item) => item.variant.var_id == productId);
//     notifyListeners();
//   }
//
//   void removeFromListViewCart(String productId) {
//     _listViewCartItems.removeWhere((item) => item.variant.var_id == productId);
//     _mainCartItems.removeWhere((item) => item.variant.var_id == productId);  // Remove from main cart as well
//     notifyListeners();
//   }
//
//   void updateMainCartQuantity(String productId, int newQuantity) {
//     for (var item in _mainCartItems) {
//       if (item.variant.var_id == productId) {
//         if (newQuantity <= 0) {
//           _mainCartItems.remove(item);
//         } else {
//           item.quantity = newQuantity; // directly set the updated quantity
//         }
//         break;
//       }
//     }
//     _syncQuantityAcrossCarts(productId); // Sync with ListView Cart after update
//     notifyListeners();
//   }
//
//
//   /// Update the quantity of a product in the ListView cart
//   void updateListViewCartQuantity(String productId, int newQuantity) {
//     for (var item in _listViewCartItems) {
//       if (item.variant.var_id == productId) {
//         if (newQuantity <= 0) {
//           item.quantity = newQuantity;
//         } else {
//           _listViewCartItems.remove(item);
//         }
//         break;
//       }
//     }
//     _syncQuantityAcrossCarts(productId);
//     notifyListeners();
//   }
//
//
//   // Sync quantities between Main Cart and ListView Cart
//   void _syncQuantityAcrossCarts(String productId) {
//     final mainCartIndex = _mainCartItems.indexWhere((item) => item.variant.var_id == productId);
//     final listViewCartIndex = _listViewCartItems.indexWhere((item) => item.variant.var_id == productId);
//
//     if (mainCartIndex != -1 && listViewCartIndex != -1) {
//       final mainCartItem = _mainCartItems[mainCartIndex];
//       _listViewCartItems[listViewCartIndex].quantity = mainCartItem.quantity;
//     } else if (mainCartIndex != -1) {
//       final mainCartItem = _mainCartItems[mainCartIndex];
//       if (listViewCartIndex == -1) {
//         _listViewCartItems.add(CartItem(variant: mainCartItem.variant, quantity: mainCartItem.quantity));
//       }
//     } else if (listViewCartIndex != -1) {
//       final listViewItem = _listViewCartItems[listViewCartIndex];
//       if (mainCartIndex == -1) {
//         _mainCartItems.add(CartItem(variant: listViewItem.variant, quantity: listViewItem.quantity));
//       }
//     }
//   }
//
//
//
//   // Get total price for main cart
//   double get mainCartTotalPrice {
//     return _mainCartItems.fold(0.0, (sum, item) {
//       final price = double.tryParse(item.variant.curr_price) ?? 0.0;
//       return sum + (price * item.quantity);
//     });
//   }
//
//   // Get total price for ListView cart
//   double get listViewCartTotalPrice {
//     return _listViewCartItems.fold(0.0, (sum, item) {
//       final price = double.tryParse(item.variant.curr_price) ?? 0.0;
//       return sum + (price * item.quantity);
//     });
//   }
//
//   // Get total item count for main cart
//   int get mainCartTotalItemCount {
//     return _mainCartItems.fold(0, (sum, item) => sum + item.quantity);
//   }
//
//   // Get total item count for ListView cart
//   int get listViewCartTotalItemCount {
//     return _listViewCartItems.fold(0, (sum, item) => sum + item.quantity);
//   }
//
//   // Clear main cart
//   void clearMainCart() {
//     _mainCartItems.clear();
//     notifyListeners();
//   }
//
//   // Clear ListView cart
//   void clearListViewCart() {
//     _listViewCartItems.clear();
//     notifyListeners();
//   }
//
//   // Get quantity of a product in the main cart
//   int getMainCartQuantityOfProduct(Variant product) {
//     final item = _mainCartItems.firstWhere(
//           (cartItem) => cartItem.variant.var_id == product.var_id,
//       orElse: () => CartItem(variant: product, quantity: 0),
//     );
//     return item.quantity;
//   }
//
//   // Get quantity of a product in the ListView cart
//   int getListViewCartQuantityOfProduct(Variant product) {
//     final item = _listViewCartItems.firstWhere(
//           (cartItem) => cartItem.variant.var_id == product.var_id,
//       orElse: () => CartItem(variant: product, quantity: 0),
//     );
//     return item.quantity;
//   }
//   double getTotalCost() {
//     double total = 0;
//
//     // For mainCartItems
//     for (var item in mainCartItems) {
//       final price = double.tryParse(item.variant.curr_price) ?? 0.0; // Parsing curr_price as double
//       total += price * item.quantity;
//     }
//
//     // For listViewCartItems
//     for (var item in listViewCartItems) {
//       final price = double.tryParse(item.variant.curr_price) ?? 0.0; // Parsing curr_price as double
//       total += price * item.quantity;
//     }
//
//     return total;
//   }
//
//
// }




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
}
