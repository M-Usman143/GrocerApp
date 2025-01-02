import 'package:flutter/material.dart';
import 'package:GrocerApp/pages/MyCartScreen.dart';
import 'package:GrocerApp/products_category/DummyDataa.dart';
import 'package:provider/provider.dart';
import '../Models/model.dart';
import '../products_category/ProductDetailPage.dart';
import 'Cart Provider.dart';
import 'VariantProvider.dart';
import 'fly_to_cart_animation.dart';

class TopSearchesScreen extends StatefulWidget {
  @override
  State<TopSearchesScreen> createState() => _TopSearchesScreenState();
}

class _TopSearchesScreenState extends State<TopSearchesScreen> {
  final GlobalKey _cartIconKey = GlobalKey();
  List<dynamic> searchResults = [];
  String query = "";
  List<String> topSearches = [
    'Batteries',
    'Stationery',
    'Sugar',
    'Atta',
    'Oil',
    'Bread',
    'Chicken',
    'Eggs',
    'Onion',
    'Milk'
  ];

  void performSearch(String input) {
    setState(() {
      query = input;
      searchResults = searchItems(query);
    });
  }

  List<dynamic> searchItems(String query) {
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

  Map<String, int> getCategoryCounts() {
    Map<String, int> categoryCounts = {};

    for (var category in DummyData().categories) {
      int count = 0;
      for (var product in category.products) {
        if (product.name.toLowerCase().contains(query.toLowerCase())) {
          count++;
        }
        for (var variant in product.variants) {
          if (variant.name.toLowerCase().contains(query.toLowerCase())) {
            count++;
          }
        }
      }
      categoryCounts[category.name] = count;
    }

    return categoryCounts;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> categoryCounts = getCategoryCounts();
    final uniqueProductCount = Provider.of<CartProvider>(context).uniqueProductCount;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {},
        ),
        title: TextField(
          onChanged: (value) => performSearch(value),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            hintText: 'What are you looking for?',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none, // Allow the badge to overlap the icon
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.orange),
                key: _cartIconKey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:(context) => MyCartScreen(),
                    ),
                  );
                },
              ),
              if (uniqueProductCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$uniqueProductCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            query.isEmpty
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Top Searches',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: topSearches.map((search) => _buildChip(search)).toList(),
                ),
              ],
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categoryCounts.entries
                    .where((entry) => entry.value > 0)
                    .map(
                      (entry) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "${entry.key} (${entry.value})",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: query.isEmpty
                  ? Center(child: Text('Search for items'))
                  : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    if (item is Products) {
                      return buildProductListView(selectedProduct: item);
                    }
                    return SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () => performSearch(label),
      child: Chip(
        label: Text(label),
        labelStyle: TextStyle(color: Colors.orange),
        backgroundColor: Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(color: Colors.orange),
        ),
      ),
    );
  }



  Widget buildProductListView({required Products selectedProduct}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VariantProvider>(context, listen: false)
          .updateVariants(selectedProduct.variants);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedProduct.variants.length,
      itemBuilder: (context, index) {
        final GlobalKey listItemKey = GlobalKey();
        final variant = selectedProduct.variants[index];
        final cartProvider = Provider.of<CartProvider>(context);
        int quantity =
        cartProvider.getListViewCartQuantityOfProduct(variant);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: selectedProduct,
                  selectedVariantId: variant.var_id,
                  varients_prodcuts: selectedProduct.variants,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            shape: Border.all(color: Colors.transparent),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    variant.image,
                    width: 60,
                    height: 60,
                    key: listItemKey,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          variant.name, // Variant name
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          variant.weight, // Variant weight
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            variant.discount, // Variant discount
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            Text(
                              "\$${variant.curr_price}", // Variant current price
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "\$${variant.pre_price}", // Variant previous price
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 80, top: 40),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: quantity > 0
                            ? buildListViewQuantityCounter(index, quantity,
                            cartProvider, variant)
                            : ElevatedButton(
                          onPressed: () {
                            cartProvider.addToListViewCart(variant);
                            FlyToCartAnimation(
                              context: context,
                              fromKey: listItemKey,
                              toKey: _cartIconKey,
                              imagePath: selectedProduct.image,
                              onComplete: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${variant.name} added to cart!"),
                                  ),
                                );
                              },
                              direction: AnimationDirection.right,
                              margin: 5.0,
                            ).startAnimation();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListViewQuantityCounter(
      int index, int quantity, CartProvider cartProvider, Variant relatedProduct) {
    return buildQuantityCounterTemplateListview(
      quantity,
          () => cartProvider.updateListViewCartQuantity(relatedProduct.var_id, quantity - 1),
          () => cartProvider.updateListViewCartQuantity(relatedProduct.var_id, quantity + 1),
    );
  }


  Widget buildQuantityCounterTemplateListview(
      int quantity, VoidCallback decrementAction, VoidCallback incrementAction) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: decrementAction,
            icon: const Icon(Icons.delete, size: 20, color: Colors.green),
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            onPressed: incrementAction,
            icon: const Icon(Icons.add, size: 20, color: Colors.green),
          ),
        ],
      ),
    );
  }

}
