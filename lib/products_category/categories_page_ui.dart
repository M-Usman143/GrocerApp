import 'package:flutter/material.dart';
import 'package:GrocerApp/products_category/ProductListPage.dart';
import '../FirebaseHelper/FIrebaseHelper.dart';
import '../Models/model.dart';
import 'dummy_data.dart';

class CategoriesPageshow extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPageshow> {
  // Keep track of expanded categories
  Map<int, bool> expandedCategories = {};
  late Future<List<Categories>> categoriesFuture;
  late Future<void> productsFuture;
  Map<int, List<Products>> categoryProducts = {};

  @override
  void initState() {
    super.initState();
    categoriesFuture = FirebaseHelper.getCategoriesFromFirebase();
  }
  Future<void> getProductsForCategory(Categories category, int index) async {
    try {
      FirebaseHelper firebaseHelper = FirebaseHelper();
      List<Products> products = await firebaseHelper.getProductsForCategory(category, index);
      setState(() {
        categoryProducts[index] = products;
      });
    } catch (e) {
      print('Error fetching products for category: ${category.name}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
        title: Text(
          'Categories',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.orange),
            onPressed: () {
              print("Cart icon pressed");
            },
          ),
        ],
      ),
      body: //category_lists(),


      FutureBuilder<List<Categories>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No categories available"));
          } else {
            return category_lists(snapshot.data!);
          }
        },
      ),




    );
  }

  ListView category_lists(List<Categories> categories) {
    return ListView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = categories[index];
        bool isExpanded = expandedCategories[index] ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                expandedCategories.clear();
                expandedCategories[index] = !isExpanded;
                if (!isExpanded && categoryProducts[index] == null) {
                  getProductsForCategory(category, index);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isExpanded ? Colors.yellow[50] : Colors.white,
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Image.asset(category.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(category.name),
                    subtitle: Text(category.subheading),
                    trailing: Icon(
                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child:GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemCount: categoryProducts[index]?.length ?? 0,
                        itemBuilder: (context, productIndex) {
                          //final product = category.products[productIndex];
                          final product = categoryProducts[index]![productIndex];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductListPage(
                                    category: category,    // Pass the category directly
                                    categoryIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300, width: 0.5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(product.image, height: 50, fit: BoxFit.cover),
                                  SizedBox(height: 8),
                                  Text(
                                    product.name,
                                    style: const TextStyle(color: Colors.black, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
