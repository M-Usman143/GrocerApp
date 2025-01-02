import 'package:flutter/material.dart';
import '../Models/model.dart';

class VariantProvider with ChangeNotifier {
  // List to store all variants
  List<Variant> _variants = [];

  // Getter for variants
  List<Variant> get variants => _variants;

  // Setter to update variants
  void updateVariants(List<Variant> variants) {
    _variants = variants;
    notifyListeners();
  }

  // Select a variant
  void selectVariant(Variant selectedVariant) {
    notifyListeners();
  }

  // Function to get all variants
  List<Variant> getAllVariants() {
    return _variants;
  }
}
