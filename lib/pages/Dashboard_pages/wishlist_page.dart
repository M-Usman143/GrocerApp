import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Models/model.dart';
import '../../../Common/WishListProvider.dart';
import '../../../Common/Cart Provider.dart';
import '../../../theme/app_theme.dart';
import 'product_detail_page.dart';
import '../../../utils/cart_animations.dart';
import '../../../pages/MyCartScreen.dart';

class WishlistPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Offset cartIconOffset = Offset(350, 40); // Adjusted for app bar position

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text('My Wishlist', style: TextStyle(color: Colors.white)),
        actions: [
          // Cart icon with counter
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final itemCount = cartProvider.getTotalItems();
              
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCartScreen(),
                        ),
                      );
                    },
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
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          final wishlistItems = wishlistProvider.wishlistItems;
          
          if (wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Save your favorite items to buy later',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('Start Shopping'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final variant = wishlistItems[index];
              return _buildWishlistItem(context, variant, wishlistProvider);
            },
          );
        },
      ),
    );
  }
  
  Widget _buildWishlistItem(BuildContext context, Variant variant, WishlistProvider wishlistProvider) {
    bool hasDiscount = variant.discount.isNotEmpty && variant.discount != '0%';
    final cartProvider = Provider.of<CartProvider>(context);
    final GlobalKey _productImageKey = GlobalKey();
    final itemCount = cartProvider.getItemCount(variant);
    
    return GestureDetector(
      onTap: () {
        // Navigate to product detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              variant: variant,
              categoryColor: AppTheme.primaryColor,
              parentCategory: null,
              parentProduct: null,
            ),
          ),
        );
      },
      child: Container(
        height: 120,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image with Discount Badge
            Stack(
              children: [
                Container(
                  key: _productImageKey,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: AssetImage(variant.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: variant.image.isEmpty
                      ? Center(child: Icon(Icons.image_not_supported, color: Colors.grey))
                      : null,
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        variant.discount,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          variant.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 2,
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
                      ],
                    ),
                    
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
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            Text(
                              variant.curr_price,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            itemCount > 0
                                ? _buildCounterButton(
                                    context: context,
                                    variant: variant,
                                    count: itemCount,
                                    cartProvider: cartProvider,
                                    productImageKey: _productImageKey,
                                    cartIconOffset: cartIconOffset,
                                  )
                                : _buildAddButton(
                                    context: context,
                                    variant: variant,
                                    cartProvider: cartProvider,
                                    productImageKey: _productImageKey,
                                    cartIconOffset: cartIconOffset,
                                  ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              color: Colors.red,
                              onPressed: () {
                                wishlistProvider.removeFromWishlist(variant.var_id);
                              },
                            ),
                          ],
                        ),
                      ],
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
  
  Widget _buildAddButton({
    required BuildContext context,
    required Variant variant,
    required CartProvider cartProvider,
    required GlobalKey productImageKey,
    required Offset cartIconOffset,
  }) {
    return ElevatedButton.icon(
      icon: Icon(Icons.shopping_cart_outlined, size: 16),
      label: Text('Add', style: TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        cartProvider.addToMainCart(variant);
        CartAnimations.flyToCart(context, productImageKey, variant.image, cartIconPos: cartIconOffset);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${variant.name} added to cart'),
            duration: Duration(seconds: 1),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }
  
  Widget _buildCounterButton({
    required BuildContext context,
    required Variant variant,
    required int count,
    required CartProvider cartProvider,
    required GlobalKey productImageKey,
    required Offset cartIconOffset,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 32,
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
              padding: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
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
                cartIconPos: cartIconOffset,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
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