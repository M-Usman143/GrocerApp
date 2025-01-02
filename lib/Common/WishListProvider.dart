// import 'package:flutter/material.dart';
//
// import '../Models/model.dart';
//
// class WishlistProvider with ChangeNotifier {
//   List<String> _wishlistIds = [];
//   List<Variant> _wishlist = [];
//
//   List<Variant> get wishlist => _wishlist;
//
//   void addToWishlist(Variant variant) {
//     _wishlist.add(variant);
//     notifyListeners();
//   }
//
//
//   void removeFromWishlist(String variantId) {
//     _wishlistIds.remove(variantId);
//     notifyListeners();
//   }
//
//   bool isInWishlist(String variantId) {
//     return _wishlistIds.contains(variantId);
//   }
//
// }



import 'package:flutter/material.dart';
import '../Models/model.dart';

import 'package:flutter/material.dart';
import '../Models/model.dart';

class WishlistProvider with ChangeNotifier {
  List<String> _wishlistIds = []; // This stores the IDs of the items
  List<Variant> _wishlist = [];   // This stores the actual Variant objects

  List<Variant> get wishlist => _wishlist;

  // Add a variant to the wishlist
  void addToWishlist(Variant variant) {
    if (!_wishlistIds.contains(variant.var_id)) {
      _wishlist.add(variant);              // Add the Variant object to the wishlist
      _wishlistIds.add(variant.var_id);    // Add the Variant's ID to the _wishlistIds list
      notifyListeners();                   // Notify listeners to update the UI
    }
  }

  // Remove a variant from the wishlist
  void removeFromWishlist(String variantId) {
    _wishlist.removeWhere((variant) => variant.var_id == variantId); // Remove the Variant from the wishlist
    _wishlistIds.remove(variantId); // Remove the Variant ID from the _wishlistIds list
    notifyListeners();               // Notify listeners to update the UI
  }

  // Check if a product is in the wishlist
  bool isInWishlist(String variantId) {
    return _wishlistIds.contains(variantId);  // Check if the ID is in the list of wishlist IDs
  }
  // Add this method to clear the wishlist
  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}
