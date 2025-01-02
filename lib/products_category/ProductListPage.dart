import 'package:flutter/material.dart';
import '../Common/Cart Provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../Common/ShareUtil.dart';
import '../Common/VariantProvider.dart';
import '../Common/fly_to_cart_animation.dart';
import '../FirebaseHelper/FIrebaseHelper.dart';
import '../pages/MyCartScreen.dart';
import '../Models/model.dart';
import 'ProductDetailPage.dart';

class ProductListPage extends StatefulWidget {
  final Categories category;
  final int categoryIndex;

  ProductListPage({required this.category ,  required this.categoryIndex});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late ScrollController _scrollController;
  String? selectedOption;
  late Categories category;
  double itemWidth = 120.0;
  List<Products> allproducts = [];
  final GlobalKey _cartIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    category = widget.category;
    _pageController = PageController(initialPage: _selectedIndex);
    _scrollController = ScrollController();
    _fetchProductVariants();
  }
  void _fetchProductVariants() async {
    try {
      await FirebaseHelper.getVariantsForProduct(widget.category.products[_selectedIndex],
          widget.categoryIndex, _selectedIndex);

      setState(() {});
    } catch (e) {
      // Handle any errors
      print('Error fetching variants: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildScreenSwiper(),
    );
  }

  Widget buildProductListView({required Products selectedProduct}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VariantProvider>(context, listen: false).updateVariants(selectedProduct.variants);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedProduct.variants.length,
      itemBuilder: (context, index) {
        final GlobalKey listItemKey = GlobalKey();
        final variant = selectedProduct.variants[index];
        final cartProvider = Provider.of<CartProvider>(context);
        int quantity = cartProvider.getListViewCartQuantityOfProduct(variant);

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
                                  ? buildListViewQuantityCounter(index, quantity, cartProvider, variant):
                         ElevatedButton(
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

  Widget buildScreenSwiper() {
    return Column(
      children: [
        buildProductSlider(),
        Divider(color: Colors.grey, thickness: 1),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.category.products.length,
            itemBuilder: (context, index) {
              final product = widget.category.products[index];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          buildProductListView(
                            selectedProduct: product,
                            //relatedProducts: getRelatedProducts(product),
                            // onProductTap: (selectedProduct) {
                            //   print("Tapped on: ${selectedProduct.name}");
                            // },
                          ),
                          SizedBox(height: 8),
                          FeedbackSection(),//feedback code
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
              _scrollToCenter(index);
            },
          ),
        ),
      ],
    );
  }

  Widget buildProductSlider() {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Divider(color: Colors.grey, thickness: 1),
        ),
        Container(
          color: Colors.white,
          height: 40,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.category.products.length,
            itemBuilder: (context, index) {
              final product = widget.category.products[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    _pageController.animateToPage(
                      _selectedIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              color: _selectedIndex == index ? Colors.orange : Colors.black,
                            ),
                          ),
                          if (_selectedIndex == index)
                            Positioned(
                              bottom: -10,
                              left: 0,
                              right: 0,
                              child: Container(
                                width: 40,
                                height: 2,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _scrollToCenter(int index) {
    double offset = (index * itemWidth) - (MediaQuery.of(context).size.width / 2) + (itemWidth / 2);
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
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
            title: Text(
              widget.category.name,
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.orange),
                onPressed: () {
               final productUrl = "https://www.example.com/products/${category.products}";
               ShareUtil.shareProductDetails(category.name, category.image, productUrl);
               },
              ),
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
        ),
      ),
    );
  }
  //feedback Section--------------------------
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
}
