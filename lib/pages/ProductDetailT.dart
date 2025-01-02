import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Common/Cart Provider.dart';
import '../Common/SearchingPage.dart';
import '../Common/ShareUtil.dart';
import '../Common/WishListProvider.dart';
import '../Common/fly_to_cart_animation.dart';
import '../Models/model.dart';
import 'MyCartScreen.dart';

class ProductShowPage extends StatefulWidget {
  final Variant mainProduct;
  final List<Variant> allProducts;

  ProductShowPage({required this.mainProduct, required this.allProducts});

  @override
  State<ProductShowPage> createState() => _ProductShowPageState();
}

class _ProductShowPageState extends State<ProductShowPage> {
  String? selectedOption;
  final GlobalKey _cartIconKey = GlobalKey();
  final GlobalKey _productImageKey = GlobalKey();
  List<String> wishlistIds = [];
  final int index = 0;


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isInWishlist = wishlistProvider.isInWishlist(widget.mainProduct.var_id);

    return Scaffold(
      appBar:buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            mainFunction(wishlistProvider, widget.mainProduct, isInWishlist),
            SizedBox(height: 8),
            FeedbackSection(),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomLayout(widget.mainProduct , index , cartProvider),

    );
  }

  Widget buildBottomLayout(Variant selectedProduct, int index, CartProvider cartProvider) {
    final variant = selectedProduct;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: cartProvider.getMainCartQuantityOfProduct(variant) > 0
          ? buildMainCartQuantityCounter(variant, cartProvider)
          : ElevatedButton(
        onPressed: () {
          cartProvider.addToMainCart(variant);

          FlyToCartAnimation(
            context: context,
            fromKey: _productImageKey,
            toKey: _cartIconKey,
            imagePath: variant.image,
            onComplete: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${variant.name} added to cart")),
              );
            },
            direction: AnimationDirection.right,
            margin: 370.0,
          ).startAnimation();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          "Add to Cart",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }


  Widget mainFunction(WishlistProvider wishlistProvider, Variant mainVariant,
      bool isInWishlist) {
    final relatedVariants = widget.allProducts.where((v) => v != mainVariant).toList();
    //final mainVariant = widget.allProducts.variants.firstWhere((v) => v.var_id == widget.selectedVariantId);
    final isInWishlist = wishlistIds.contains(widget.mainProduct.var_id);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mainVariant.name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Product Image
            Center(
              child: Image.asset(
                mainVariant.image,
                key: _productImageKey,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  mainVariant.curr_price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                // Wishlist Icon and Weight
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isInWishlist) {
                          wishlistProvider.removeFromWishlist(mainVariant.var_id);
                        } else {
                          wishlistProvider.addToWishlist(mainVariant);
                        }
                      },
                      icon: Icon(
                        isInWishlist
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.orange,
                      ),
                      tooltip: "Add to Wishlist",
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Weight: ${mainVariant.weight}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // "More other Products" Text
            const Text(
              "More other Products",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            relatedVariants.isNotEmpty
                ? SizedBox(
              height: 270,
              child: listViewOtherProducts(relatedVariants),

            )
                : const Center(child: Text("No related products")),
          ],
        ),
      ),
    );
  }
  ListView listViewOtherProducts(List<Variant> relatedProducts) {

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.allProducts.length,
      itemBuilder: (context, index) {
        final relatedProduct =  widget.allProducts[index];
        final GlobalKey listItemKey = GlobalKey();
        final cartProvider = Provider.of<CartProvider>(context);
        int quantity = cartProvider.getListViewCartQuantityOfProduct(relatedProduct);

        return GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProductShowPage(
                  mainProduct: relatedProduct,
                  allProducts: widget.allProducts,
                ),
              ),
            );
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
                    relatedProduct.image,
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
                        relatedProduct.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Weight: ${relatedProduct.weight}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        relatedProduct.curr_price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: quantity > 0
                      ? buildListViewQuantityCounter(index, quantity, cartProvider, relatedProduct)
                      : ElevatedButton(
                    onPressed: () {
                      cartProvider.addToListViewCart(relatedProduct);
                      FlyToCartAnimation(
                        context: context,
                        fromKey: listItemKey,
                        toKey: _cartIconKey,
                        imagePath: relatedProduct.image,
                        onComplete: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${relatedProduct.name} added to cart!"),
                            ),
                          );
                        },
                        direction: AnimationDirection.right,
                        margin: 370.0,
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
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

  Widget buildMainCartQuantityCounter(Variant variant, CartProvider cartProvider) {
    int quantity = cartProvider.getMainCartQuantityOfProduct(variant);
    return buildQuantityCounterTemplateMain(
      quantity,
          () => cartProvider.updateMainCartQuantity(variant.var_id, quantity - 1),
          () => cartProvider.updateMainCartQuantity(variant.var_id, quantity + 1),
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
  Widget buildQuantityCounterTemplateMain(
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
          Container(
            margin: EdgeInsets.only(left: 120),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 145),
            child: IconButton(
              onPressed: incrementAction,
              icon: const Icon(Icons.add, size: 20, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }


























  PreferredSize buildAppBar(BuildContext context) {
    final uniqueProductCount = Provider.of<CartProvider>(context).uniqueProductCount;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.orange),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Product Details",
              style: TextStyle(color: Colors.black),
            ),            actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.orange),
              onPressed: () {
                final productName = "Product Name";
                final productPrice = "Product Price";
                final productUrl = "https://www.example.com/products/product-id";
                ShareUtil.shareProductDetails(productName, productPrice, productUrl);
              },
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  TopSearchesScreen(),
                  ),
                );
              },
            ),
            Stack(
              clipBehavior: Clip.none, // Allow the badge to overlap the icon
              children: [
                IconButton(
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
          ),
        ),
      ),
    );
  }

  Container FeedbackSection() {
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.yellow[50],
            height: 50,
            width: 500,
            child: const Center(
              child: Text(
                "Having trouble? Let us know",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              // First container
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = "Couldnt find my item";
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  width: 170,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedOption == "Couldnt find my item"
                          ? Colors.orange
                          : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Couldnt find my item",
                      style: TextStyle(
                        color: selectedOption == "Couldnt find my item"
                            ? Colors.orange
                            : Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              // Second container
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = "Prices are too high";
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  width: 170,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedOption == "Prices are too high"
                          ? Colors.orange
                          : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Prices are too high",
                      style: TextStyle(
                        color: selectedOption == "Prices are too high"
                            ? Colors.orange
                            : Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              // Third container
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = "Too less item info";
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  width: 170,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedOption == "Too less item info"
                          ? Colors.orange
                          : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Too less item info",
                      style: TextStyle(
                        color: selectedOption == "Too less item info"
                            ? Colors.orange
                            : Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              // Fourth container
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = "Other";
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 40,
                  width: 170,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedOption == "Other"
                          ? Colors.orange
                          : Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Other",
                      style: TextStyle(
                        color: selectedOption == "Other"
                            ? Colors.orange
                            : Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          // Submit button
          Container(
            height: 50,
            width: 380,
            decoration: BoxDecoration(),
            child: ElevatedButton(
              onPressed: selectedOption == null
                  ? null
                  : () {
                // Show a dialog popup
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Feedback Submitted"),
                      content: Text("Thank you for your feedback!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption != null ? Colors.orange : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // Rounded corners
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

          ),

          SizedBox(height: 40)
        ],
      ),
    );
  }




















  SingleChildScrollView hashfunction() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Product Display
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    widget.mainProduct.image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  widget.mainProduct.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Price: ${widget.mainProduct.curr_price}",
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                SizedBox(height: 8),
                Text(
                  "Previous Price: ${widget.mainProduct.pre_price}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Other Trending Products",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Horizontal List of Other Products
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.allProducts.length,
              itemBuilder: (context, index) {
                final product = widget.allProducts[index];
                if (product == widget.mainProduct) return SizedBox.shrink(); // Skip main product
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductShowPage(
                          mainProduct: product,
                          allProducts: widget.allProducts,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          product.image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          product.curr_price,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
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
    );
  }

}