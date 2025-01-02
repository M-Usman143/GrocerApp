// search_service.dart
import 'package:GrocerApp/products_category/DummyDataa.dart';


class SearchService {
  static List<dynamic> searchItems(String query) {
    List<dynamic> results = [];

    for (var category in DummyData().categories) {
      for (var product in category.products) {
        // Match product name
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          results.add(product);
        }

        // Match variant name
        for (var variant in product.variants) {
          if (variant.name.toLowerCase().contains(query.toLowerCase())) {
            results.add(variant);
          }
        }
      }
    }

    return results;
  }
}
