import 'package:flutter/material.dart';
import 'package:GrocerApp/pages/MyCartScreen.dart';
import 'package:GrocerApp/pages/ViewAllWishList.dart';
import 'package:provider/provider.dart';

import '../Common/Cart Provider.dart';
import '../Common/WishListProvider.dart';
import '../Common/fly_to_cart_animation.dart';
import '../Models/model.dart';
import '../products_category/ProductDetailPage.dart';

class WishListScreen extends StatefulWidget {
  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  List<Variant> wishlist = [];
  final GlobalKey _cartIconKey = GlobalKey();
  final int index = 0;
  @override
  Widget build(BuildContext context) {
    final uniqueProductCount = Provider.of<CartProvider>(context).uniqueProductCount;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist ?? [];

    return Scaffold(
      appBar: buildAppBar(context, uniqueProductCount),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Default Wish List (1)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.orange),
                  onPressed: () {},
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WishListScreen()),
                    );
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final variant = wishlist[index];
                  final cartProvider = Provider.of<CartProvider>(context);
                  int quantity = cartProvider.getListViewCartQuantityOfProduct(variant);

                  return buildProductListView(context, variant, quantity, cartProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductListView(BuildContext context, Variant variant, int quantity, CartProvider cartProvider) {
    final GlobalKey listItemKey = GlobalKey();

    return GestureDetector(
      onTap: () {},
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
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      variant.weight, // Variant weight
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        variant.discount, // Variant discount
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
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
                            decoration: TextDecoration.lineThrough,
                          ),
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
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: quantity > 0
                        ? buildListViewQuantityCounter(index, quantity, cartProvider, variant)
                        : ElevatedButton(
                      onPressed: () {
                        cartProvider.addToListViewCart(variant);
                        FlyToCartAnimation(
                          context: context,
                          fromKey: listItemKey,
                          toKey: _cartIconKey,
                          imagePath: variant.image,
                          onComplete: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${variant.name} added to cart!"),
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
  }



  AppBar buildAppBar(BuildContext context, int uniqueProductCount) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.orange),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Wish List",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              key: _cartIconKey,
              icon: const Icon(Icons.shopping_cart, color: Colors.orange),
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
            icon: const Icon(Icons.remove, size: 20, color: Colors.green),
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
