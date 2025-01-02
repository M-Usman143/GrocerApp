import 'package:flutter/material.dart';
import 'package:GrocerApp/Common/SearchingPage.dart';
import 'package:GrocerApp/pages/TrendingProduct.dart';
import 'package:GrocerApp/products_category/ProductListPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Cart Provider.dart';
import '../Common/VariantProvider.dart';
import '../FirebaseHelper/FIrebaseHelper.dart';
import '../products_category/dummy_data.dart';
import '../drawer/Drawer_home.dart';
import '../Models/model.dart';
import '../Common/AutoScrollSlider.dart';
import '../pages/LocationScreen.dart';
import '../Common/fly_to_cart_animation.dart';
import 'MyCartScreen.dart';
import 'ProductDetailT.dart';


class Dashbaord extends StatefulWidget {
  final String homePageContent = "Welcome to our app! Check out our latest products.";
  final String homePageUrl = "https://www.example.com";
  final String? userLocation;
  const Dashbaord({super.key, this.userLocation});
  @override
  State<Dashbaord> createState() => _DashbaordState();
}

class _DashbaordState extends State<Dashbaord> {
  Map<int, bool> expandedCategories = {};
  final int index = 0;
  late Future<List<Categories>> categoriesFuture;
  late Future<void> productsFuture;
  Map<int, List<Products>> categoryProducts = {};
  String? _userLocation;
  final GlobalKey _cartIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    categoriesFuture = FirebaseHelper.getCategoriesFromFirebase();
    _loadLocation();

  }

  Future<void> _loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userLocation = prefs.getString('user_location') ?? 'Location not set';
    });
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
    final cartProvider = Provider.of<CartProvider>(context);

    return WillPopScope(
        onWillPop: () async {
      return true;
    },

      child: Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildAppBar(context),
      drawer: const Drawer_home(),
      body: Column(
        children: [
          buildLocationContainer(context),

          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Stack_Main(context),
                  Positioned.fill(
                    top: 860,
                    right: 1,
                    left: 2,
                    child:SingleChildScrollView(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Stack Stack_Main(BuildContext context) {
    List<Variant> trendingProducts = getTrendingProducts(categories);
    return Stack(
      children: [
        SizedBox(height: 30),
        Container(
            margin: EdgeInsets.symmetric(vertical: 40),
            child: AutoScrollSlider()),
        trending_container(context),
        Positioned(
          top: 500,
          right: 1,
          left: 15,
          child: horizontal_listview(trendingProducts),
        ),
      ],
    );
  }


  AppBar buildAppBar(BuildContext context) {
    final uniqueProductCount = Provider.of<CartProvider>(context).uniqueProductCount;
    return AppBar(
      backgroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopSearchesScreen(),
                    ),
                  );
                },

                decoration: InputDecoration(
                  hintText: 'What are you looking for',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 2,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none, // Allow the badge to overlap the icon
          children: [
            IconButton(
              key: _cartIconKey,
              icon: const Icon(Icons.shopping_cart, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyCartScreen(),
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

  Widget buildLocationContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the location screen when the container is clicked
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocationScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.black, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Deliver to " + (_userLocation ?? 'Fetching location...'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationScreen()),
                );
              },
              child: const Icon(Icons.arrow_drop_down, color: Colors.black, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Column trending_container(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 2680,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 410),
          padding: EdgeInsets.all(16), // Added padding for inner spacing
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spaces items horizontally
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns to the top
            children: [
              const Text(
                "Trending Products",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrendingProducts(categories: categories),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

  Container horizontal_listview(List<Variant> trendingProducts) {
    print("Data in horizontal_listview: $trendingProducts"); // Debugging line
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VariantProvider>(context, listen: false).updateVariants(trendingProducts);
    });
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 305,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingProducts.length,

        itemBuilder: (context, index) {
          final variant = trendingProducts[index];
          return trendingProductCard(variant , trendingProducts);
        },

      ),
    );
  }

  Widget trendingProductCard(Variant varient , List<Variant> trendingProducts) {

    final cartProvider = Provider.of<CartProvider>(context);
    int quantity = cartProvider.getListViewCartQuantityOfProduct(varient);
    final GlobalKey listItemKey = GlobalKey();


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductShowPage(
              mainProduct: varient,
              allProducts: trendingProducts.where((product) => product != varient).toList(),            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 5, // Shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1), // Rounded corners
        ),
        margin: const EdgeInsets.only(right: 16, top: 8, bottom: 6), // Space between cards
        child: Container(
          width: 200, // Width of each card
          height: 200, // Height of each card
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18), // Rounded corners for the card container
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // Clip the content to match rounded corners
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    varient.image,
                    key: listItemKey,
                    width: 180,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                // Product Name
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    varient.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle long text
                  ),
                ),
                const SizedBox(height: 4),
                // Product Weight
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "${varient.weight}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Product Price
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        varient.curr_price,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          varient.pre_price,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration:
                            TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    varient.discount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: quantity > 0
                      ? buildListViewQuantityCounter(index, quantity, cartProvider ,varient)
                      : ElevatedButton(
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
                        direction: AnimationDirection.left, // Specify the direction (left or right)
                      ).startAnimation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(1),
                      ),
                    ),
                    child: Text("Add to Cart" , style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

}
