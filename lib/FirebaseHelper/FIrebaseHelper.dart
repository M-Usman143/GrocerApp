import 'package:firebase_database/firebase_database.dart';
import '../Models/model.dart';

class FirebaseHelper {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;
  static Map<int, List<Products>> categoryProducts = {};
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<List<Products>> getProductsForCategory(Categories category, int index) async {
    try {
      final categoriesRef = _database.ref('categories/categories');
      final categoriesSnapshot = await categoriesRef.get();

      if (categoriesSnapshot.exists) {
        if (categoriesSnapshot.value is List) {
          List<dynamic> categoriesList = categoriesSnapshot.value as List<dynamic>;

          if (categoriesList.length > index) {
            var categoryData = categoriesList[index];
            String cat_id = categoryData['category_id'];

            final productsRef = _database.ref('categories/categories/$index/products');
            final productsSnapshot = await productsRef.get();

            if (productsSnapshot.exists) {
              List<Products> products = [];
              if (productsSnapshot.value is List) {
                List<dynamic> dataList = productsSnapshot.value as List<dynamic>;
                for (var item in dataList) {
                  if (item is Map) {
                    products.add(Products.fromJson(item));
                  }
                }
              }
              return products;  // Return the list of products
            } else {
              throw Exception('No products found for category: $cat_id');
            }
          } else {
            throw Exception('Category with index $index not found.');
          }
        } else {
          throw Exception('Categories data is not in the expected format.');
        }
      } else {
        throw Exception('No categories found in the database.');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products for category: $category');
    }
  }

  static Future<List<Categories>> getCategoriesFromFirebase() async {
    final databaseRef = _database.ref('categories');
    final snapshot = await databaseRef.get();

    if (snapshot.exists) {
      List<Categories> categories = [];

      // Check if the snapshot is a Map or a List
      if (snapshot.value is Map) {
        // If the data is a Map, iterate over its values
        Map<dynamic, dynamic> dataMap = snapshot.value as Map<dynamic, dynamic>;

        dataMap.forEach((key, value) {
          // Check if the value is a list
          if (value is List) {
            for (var item in value) {
              categories.add(Categories.fromJson(item));
            }
          }
        });
      } else if (snapshot.value is List) {
        // If it's already a list, handle it directly
        List<dynamic> dataList = snapshot.value as List<dynamic>;
        for (var item in dataList) {
          categories.add(Categories.fromJson(item));
        }
      } else {
        throw Exception('Data format is neither List nor Map');
      }

      return categories;
    } else {
      throw Exception('No categories found');
    }
  }

  static Future<void> getVariantsForProduct(Products product, int categoryIndex, int productIndex) async {
    try {
      // Fetch variants for the product from Firebase
      final databaseRef = _database.ref('categories/categories/$categoryIndex/products/$productIndex/variants');
      final snapshot = await databaseRef.get();

      if (snapshot.exists) {
        List<Variant> variants = [];

        // Check if the snapshot is a List (since variants are expected as a List)
        if (snapshot.value is List) {
          List<dynamic> dataList = snapshot.value as List<dynamic>;
          for (var item in dataList) {
            if (item is Map) {
              variants.add(Variant.fromJson(item));
            }
          }
        } else {
          throw Exception('Unexpected data format for variants, expected a List.');
        }
        product.variants = variants;

        print('Fetched ${variants.length} variants for product: ${product.name}');
      } else {
        // No variants found for the product
        throw Exception('No variants found for product: ${product.pro_id}');
      }
    } catch (e) {
      // Catch any errors
      print('Error fetching variants: $e');
      throw Exception('Error fetching variants for product: ${product.pro_id}');
    }
  }

  Future<List<Variant>> fetchTrendingVariants() async {
    List<Variant> trendingVariants = [];
    try {
      DatabaseEvent categoriesSnapshot = await _dbRef.child('categories/categories').once();
      List<dynamic>? categories = categoriesSnapshot.snapshot.value as List<dynamic>?;

      if (categories != null) {
        for (int categoryIndex = 0; categoryIndex < categories.length; categoryIndex++) {
          DatabaseEvent productsSnapshot = await _dbRef
              .child('categories/categories/$categoryIndex/products')
              .once();

          List<dynamic>? products = productsSnapshot.snapshot.value as List<dynamic>?;

          if (products != null) {
            // Iterate through each product index
            for (int productIndex = 0; productIndex < products.length; productIndex++) {
              // Fetch variants for the product
              DatabaseEvent variantsSnapshot = await _dbRef
                  .child('categories/categories/$categoryIndex/products/$productIndex/variants')
                  .once();

              List<dynamic>? variants = variantsSnapshot.snapshot.value as List<dynamic>?;

              if (variants != null) {
                // Iterate through each variant
                for (int variantIndex = 0; variantIndex < variants.length; variantIndex++) {
                  var variantData = variants[variantIndex];
                  Variant variant = Variant.fromJson(variantData);
                  // Check if the variant is trending
                  if (variant.isTrending) {
                    trendingVariants.add(variant); // Add this trending variant
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return trendingVariants;
  }

}
