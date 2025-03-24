import 'package:flutter/material.dart';
import 'package:GrocerApp/theme/app_theme.dart';
import '../../../products_category/dummy_data.dart';
import '../../../Models/model.dart';
import '../Dashboard_widgets/promo_banner_widget.dart';
import 'subcategory_page.dart';
import '../../../Common/WishListProvider.dart';
import '../../../Common/Cart Provider.dart';
import 'package:provider/provider.dart';
import 'wishlist_page.dart';
import '../../../utils/cart_animations.dart';
import '../../../pages/MyCartScreen.dart';
import 'product_detail_page.dart';
import '../../../pages/FeaturedProductsPage.dart';
import '../../../pages/TrendingProduct.dart';

class HomePage extends StatefulWidget {
  final String? userLocation;
  HomePage({this.userLocation});
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    return Container(
      color: Colors.grey[50],
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PromoBannerWidget(
                    title: 'Fresh Groceries',
                    subtitle: 'Get 20% off on your first order!',
                    buttonText: 'Shop Now',
                    onPressed: () {
                      // Navigate to promotions page
                    },
                    backgroundColor: const Color(0xFFEEF7FF),
                    imageAsset: 'assets/images/grocerapplogo.jpeg',
                  ),
                ),
              ),
              
              // Featured Categories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Featured Categories', () {
                        // Navigate to categories page
                      }),
                      SizedBox(height: 16),
                      _buildCategoryList(),
                    ],
                  ),
                ),
              ),
              
              // Featured Products
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Featured Products', () {
                        // Navigate to products page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeaturedProductsPage(),
                          ),
                        );
                      }),
                      SizedBox(height: 16),
                      _buildFeaturedProducts(),
                    ],
                  ),
                ),
              ),
              
              // Best Selling Items
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Best Selling Items', () {
                        // Navigate to best selling page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrendingProduct(),
                          ),
                        );
                      }),
                      SizedBox(height: 16),
                      _buildTrendingProducts(),
                    ],
                  ),
                ),
              ),
              
              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
          
          // Cart icon with counter
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final itemCount = cartProvider.getTotalItems();
                
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyCartScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              itemCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            'See All',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubcategoryPage(category: category),
                ),
              );
            },
            child: Container(
              width: 100,
              margin: EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        category.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    // Collect first variant from each product across all categories
    List<Variant> featuredVariants = [];
    Map<Variant, Products> variantToProduct = {};
    Map<Variant, Categories> variantToCategory = {};

    for (var category in categories) {
      for (var product in category.products) {
        if (product.variants.isNotEmpty) {
          featuredVariants.add(product.variants[0]);
          variantToProduct[product.variants[0]] = product;
          variantToCategory[product.variants[0]] = category;
          // Limit to 10 featured products
          if (featuredVariants.length >= 10) break;
        }
      }
      if (featuredVariants.length >= 10) break;
    }

    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredVariants.length,
        itemBuilder: (context, index) {
          final variant = featuredVariants[index];
          final product = variantToProduct[variant];
          final category = variantToCategory[variant];
          
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    variant: variant,
                    categoryColor: AppTheme.primaryColor,
                    parentCategory: category,
                    parentProduct: product,
                  ),
                ),
              );
            },
            child: _buildProductCard(variant),
          );
        },
      ),
    );
  }

  Widget _buildTrendingProducts() {
    // Find trending variants
    List<Variant> trendingVariants = [];
    Map<Variant, Products> variantToProduct = {};
    Map<Variant, Categories> variantToCategory = {};

    for (var category in categories) {
      for (var product in category.products) {
        for (var variant in product.variants) {
          if (variant.isTrending) {
            trendingVariants.add(variant);
            variantToProduct[variant] = product;
            variantToCategory[variant] = category;
          }
        }
      }
    }

    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingVariants.length,
        itemBuilder: (context, index) {
          final variant = trendingVariants[index];
          final product = variantToProduct[variant];
          final category = variantToCategory[variant];
          
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    variant: variant,
                    categoryColor: AppTheme.primaryColor,
                    parentCategory: category,
                    parentProduct: product,
                  ),
                ),
              );
            },
            child: _buildProductCard(variant, showDiscount: true),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Variant variant, {bool showDiscount = false}) {
    return Consumer2<WishlistProvider, CartProvider>(
      builder: (context, wishlistProvider, cartProvider, child) {
        final isInWishlist = wishlistProvider.isInWishlist(variant);
        final itemCount = cartProvider.getItemCount(variant);
        final GlobalKey _productImageKey = GlobalKey();

        return Container(
          width: 160,
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with favorite button
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      key: _productImageKey,
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Image.asset(
                        variant.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          wishlistProvider.toggleWishlistItem(variant);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  isInWishlist
                                      ? '${variant.name} removed from wishlist'
                                      : '${variant.name} added to wishlist'
                              ),
                              duration: Duration(seconds: 1),
                              backgroundColor: isInWishlist ? Colors.red : AppTheme.primaryColor,
                            ),
                          );

                          if (!isInWishlist) {
                            // Navigate to wishlist page if adding to wishlist
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text('My Wishlist'),
                                    backgroundColor: AppTheme.primaryColor,
                                  ),
                                  body: WishlistPage(),
                                ),
                              ),
                            );
                          }
                        },
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isInWishlist ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  if (variant.discount != '' && variant.discount != '0%')
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          variant.discount,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Product Details
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      variant.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      variant.weight,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (variant.pre_price != variant.curr_price)
                              Text(
                                variant.pre_price,
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            Text(
                              variant.curr_price,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        itemCount > 0
                            ? _buildCounterButton(
                          variant: variant,
                          count: itemCount,
                          cartProvider: cartProvider,
                          productImageKey: _productImageKey,
                        )
                            : _buildAddButton(
                          variant: variant,
                          cartProvider: cartProvider,
                          productImageKey: _productImageKey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddButton({
    required Variant variant,
    required CartProvider cartProvider,
    required GlobalKey productImageKey,
  }) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () {
          cartProvider.addToMainCart(variant);

          // Animation - fly to cart
          CartAnimations.flyToCart(
            context,
            productImageKey,
            variant.image,
            cartIconPos: Offset(MediaQuery.of(context).size.width - 30, MediaQuery.of(context).padding.top + 20),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${variant.name} added to cart'),
              duration: Duration(seconds: 1),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildCounterButton({
    required Variant variant,
    required int count,
    required CartProvider cartProvider,
    required GlobalKey productImageKey,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor),
        borderRadius: BorderRadius.circular(6),
      ),
      height: 26,
      child: Row(
        children: [
          // Decrease button
          InkWell(
            onTap: () {
              if (count > 1) {
                cartProvider.decreaseItemQuantity(variant);
              } else {
                cartProvider.removeFromCart(variant);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),

          // Counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),

          // Increase button
          InkWell(
            onTap: () {
              cartProvider.increaseItemQuantity(variant);

              // Animation - fly to cart
              CartAnimations.flyToCart(
                context,
                productImageKey,
                variant.image,
                cartIconPos: Offset(MediaQuery.of(context).size.width - 30, MediaQuery.of(context).padding.top + 20),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}