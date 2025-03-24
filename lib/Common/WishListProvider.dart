import 'package:flutter/material.dart';
import '../Models/model.dart';
import '../LocalStorageHelper/LocalStorageService.dart';

class WishlistProvider with ChangeNotifier {
  List<Variant> _wishlistItems = [];
  
  List<Variant> get wishlistItems => _wishlistItems;
  
  int get wishlistCount => _wishlistItems.length;
  
  // Load wishlist items from localStorage
  Future<void> loadWishlistItems() async {
    try {
      final items = await LocalStorageService.getWishlistItems();
      _wishlistItems = items;
      notifyListeners();
    } catch (e) {
      print('Error loading wishlist items: $e');
    }
  }
  
  // Add an item to the wishlist
  Future<void> addToWishlist(Variant variant) async {
    // Check if item already exists in wishlist
    if (!isInWishlist(variant)) {
      _wishlistItems.add(variant);
      await _saveWishlist();
      notifyListeners();
    }
  }
  
  // Remove an item from the wishlist
  Future<void> removeFromWishlist(String variantId) async {
    _wishlistItems.removeWhere((item) => item.var_id == variantId);
    await _saveWishlist();
    notifyListeners();
  }
  
  // Toggle an item in the wishlist (add if not exists, remove if exists)
  Future<void> toggleWishlistItem(Variant variant) async {
    if (isInWishlist(variant)) {
      await removeFromWishlist(variant.var_id);
    } else {
      await addToWishlist(variant);
    }
  }
  
  // Check if an item is in the wishlist
  bool isInWishlist(Variant variant) {
    return _wishlistItems.any((item) => item.var_id == variant.var_id);
  }
  
  // Clear the entire wishlist
  Future<void> clearWishlist() async {
    _wishlistItems.clear();
    await _saveWishlist();
    notifyListeners();
  }
  
  // Save wishlist to localStorage
  Future<void> _saveWishlist() async {
    try {
      await LocalStorageService.saveWishlistItems(_wishlistItems);
    } catch (e) {
      print('Error saving wishlist: $e');
    }
  }
}
