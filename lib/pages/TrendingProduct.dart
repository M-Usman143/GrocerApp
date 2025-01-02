import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:GrocerApp/pages/ProductDetailT.dart';
import 'package:GrocerApp/pages/Uploading.dart';
import 'package:provider/provider.dart';
import '../Common/Cart Provider.dart';
import '../Common/SearchingPage.dart';
import '../Common/ShareUtil.dart';
import '../Common/VariantProvider.dart';
import '../FirebaseHelper/FIrebaseHelper.dart';
import '../Common/fly_to_cart_animation.dart';
import '../Models/model.dart';
import 'MyCartScreen.dart';

class TrendingProducts extends StatefulWidget {
  final List<Categories> categories;
  TrendingProducts({required this.categories});

  @override
  _TrendingProductsState createState() => _TrendingProductsState();
}

class _TrendingProductsState extends State<TrendingProducts> {
  Map<int, int> productQuantities = {};
  String? selectedOption;
  double itemWidth = 120.0;
  List<Products> allproducts = [];
  final GlobalKey _cartIconKey = GlobalKey();


  late Future<List<Variant>> _trendingVariants;

  @override
  void initState() {
    super.initState();
    _trendingVariants = FirebaseHelper().fetchTrendingVariants();
  }
  @override
  Widget build(BuildContext context) {
    List<Variant> trendingProducts = getTrendingProducts(widget.categories);
    Products products = getSampleProduct();

    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<List<Variant>>(
        future: _trendingVariants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Variant> trendingProducts = snapshot.data!;
            return SingleChildScrollView(
              child: buildProductListView(trendingProducts, products),
            );
          } else {
            return Center(child: Text('No trending products available.'));
          }
        },
      ),
    );
  }

  Widget buildProductListView(List<Variant> trendingProducts,  Products product) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VariantProvider>(context, listen: false).updateVariants(trendingProducts);
    });
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: trendingProducts.length,
      itemBuilder: (context, index) {
        final variant = trendingProducts[index];
        final cartProvider = Provider.of<CartProvider>(context);
        int quantity = cartProvider.getListViewCartQuantityOfProduct(variant);
        return trendingProductCard(context,index,quantity , cartProvider,variant,trendingProducts,
          product);
      },
    );
  }

  GestureDetector trendingProductCard(BuildContext context, int index, int currentQuantity, CartProvider cartProvider
      ,Variant varient,  List<Variant> trendingProducts,
       Products product) {
    Products products = getSampleProduct();

    final GlobalKey listItemKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductShowPage(
              mainProduct: varient,
              allProducts: trendingProducts,
            ),
          ),
        );
      },
      child: Container(
          height: 220,
          child: Card(
            color: Colors.white,
            shape: Border.all(color: Colors.transparent),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: Image.asset(
                      varient.image,
                      key: listItemKey,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            varient.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Product Weight
                          Text(
                            varient.weight,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Discount Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "36% Off", // Static discount for this example
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Product Prices
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: Row(
                              children: [
                                Text(
                                  varient.curr_price,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  varient.pre_price,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Add to Cart Button with Icons and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures content is spaced
                    children: [
                      // Add to Cart Button
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 150),
                        child: currentQuantity > 0
                            ? buildListViewQuantityCounter(index, currentQuantity, cartProvider, varient):
                        ElevatedButton(
                          onPressed: () {
                            cartProvider.addToListViewCart(varient);
                            FlyToCartAnimation(
                              context: context,
                              fromKey: listItemKey,
                              toKey: _cartIconKey,
                              imagePath: varient.image,
                              onComplete: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${varient.name} added to cart!"),
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

                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }



  List<Variant> getTrendingProducts(List<Categories> categories) {
    List<Variant> trendingProducts = [];

    for (var category in categories) {
      for (var product in category.products) {
        trendingProducts.addAll(
          product.variants.where((variant) => variant.isTrending),
        );
      }
    }
    return trendingProducts;
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
              "Trending Product",
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
          ),
        ),
      ),
    );
  }


  Products getSampleProduct() {
    return Products(
      pro_id: '1', // Sample product ID
      name: "Sample Product", // Sample product name
      image: "assets/sample_product.png", // Path to a placeholder image in your assets
      curr_price: '100.0', // Sample price
      variants: [
        Variant(
          var_id: '101',
          name: "Sample Variant",
          weight: "500g",
          discount: '25%',
          curr_price: "100 PKR",
          pre_price: "150 PKR",
          image: "assets/sample_variant.png",
        ),
      ], // Sample variants
    );
  }


}
