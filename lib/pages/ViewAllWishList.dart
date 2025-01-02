import 'package:flutter/material.dart';
import 'package:GrocerApp/pages/MyCartScreen.dart';
import 'package:GrocerApp/pages/WishLish.dart';
import 'package:provider/provider.dart';
import '../Common/Cart Provider.dart';
import '../Common/WishListProvider.dart';
import '../Common/fly_to_cart_animation.dart';
import '../Models/model.dart';
import '../Common/WishListProvider.dart';
import '../products_category/ProductDetailPage.dart';


class WishListPage extends StatefulWidget {

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
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
      body: wishlist.isEmpty
          ? Center(
        child: buildBody(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Default Wish List (${wishlist.length})",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.orange),
                      onPressed: () {
                        // Handle delete action
                        wishlistProvider.clearWishlist();
                        setState(() {}); // Refresh the screen after removal
                      },
                    ),
                    TextButton(
                      onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  WishListScreen()),
                          );
                          },
                      child: Container(
                        height: 40,
                        width: 80,
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "View all",
                          style: TextStyle(color: Colors.orange, fontSize: 15),

                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final variant = wishlist[index];
                  return listViewOtherProducts(variant);
                },
              ),
            ),
          ],
        ),
      ),

    );
  }



  Widget listViewOtherProducts(Variant variant) {
    final GlobalKey listItemKey = GlobalKey();
    final cartProvider = Provider.of<CartProvider>(context);
    int quantity = cartProvider.getListViewCartQuantityOfProduct(variant);

    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                variant.image,
                width: 150,
                key: listItemKey,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Weight: ${variant.weight}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    variant.curr_price,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
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
                        SnackBar(content: Text("${variant.name} added to cart!")),
                      );
                    },
                    direction: AnimationDirection.right,
                    margin: 5.0,
                  ).startAnimation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(120, 38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
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





  /// Method to build the Body
  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildWishListIcon(),
          const SizedBox(height: 10),
          buildWishListMessage(),
        ],
      ),
    );
  }

  /// Method to build the Wish List icon
  Widget buildWishListIcon() {
    return const Icon(
      Icons.favorite,
      color: Colors.orange,
      size: 50,
    );
  }

  /// Method to build the Wish List message
  Widget buildWishListMessage() {
    return const Text(
      "You haven't added any items to your Wish List yet.",
      style: TextStyle(
        color: Colors.orange,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }

}
