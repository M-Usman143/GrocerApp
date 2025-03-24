import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Models/model.dart';
import '../../../theme/app_theme.dart';
import '../../../Common/WishListProvider.dart';
import '../../../Common/Cart Provider.dart';
import '../../../utils/cart_animations.dart';
import '../../../pages/MyCartScreen.dart';

class ProductDetailPage extends StatefulWidget {
  final Variant variant;
  final Color categoryColor;
  final Categories? parentCategory;
  final Products? parentProduct;

  const ProductDetailPage({
    Key? key, 
    required this.variant, 
    required this.categoryColor,
    required this.parentCategory,
    required this.parentProduct,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  final GlobalKey _productImageKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool hasDiscount = widget.variant.discount != '' && widget.variant.discount != '0%';
    final double appBarHeight = screenHeight * 0.1;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartIconOffset = Offset(screenWidth - 70, MediaQuery.of(context).padding.top + 40);
    final itemCount = cartProvider.getItemCount(widget.variant);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Main scrollable content
          CustomScrollView(
            slivers: [
              // Top image section with gradient overlay
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Product Image
                    Container(
                      height: screenHeight * 0.45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.categoryColor.withOpacity(0.1),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Hero(
                        tag: 'product_${widget.variant.var_id}',
                        child: Container(
                          key: _productImageKey,
                          child: Image.asset(
                            widget.variant.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 80,
                                  color: widget.categoryColor.withOpacity(0.3),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    // Discount badge
                    if (hasDiscount)
                      Positioned(
                        top: appBarHeight + 20,
                        right: 20,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.variant.discount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    // Top spacing for app bar
                    Container(height: appBarHeight),
                  ],
                ),
              ),
              
              // Product details
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name and rating row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.variant.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  widget.variant.weight,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildRatingWidget(),
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Price section
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.variant.pre_price != widget.variant.curr_price)
                                Text(
                                  widget.variant.pre_price,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              Text(
                                widget.variant.curr_price,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: widget.categoryColor,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          _buildQuantitySelector(),
                        ],
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Description section
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _getDescription(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Other variants section
                      _buildOtherVariantsSection(),
                      
                      // Bottom padding for cart button
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Back button, cart icon, and favorite button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: appBarHeight,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: Container(
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
                      child: Icon(Icons.arrow_back, color: widget.categoryColor),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),
                  
                  // Cart icon with counter
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      final totalItems = cartProvider.getTotalItems();
                      
                      return Stack(
                        children: [
                          IconButton(
                            icon: Container(
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
                                color: widget.categoryColor,
                              ),
                            ),
                            onPressed: () {
                              // Navigate to cart page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyCartScreen(),
                                ),
                              );
                            },
                          ),
                          if (totalItems > 0)
                            Positioned(
                              right: 8,
                              top: 8,
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
                                    totalItems.toString(),
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
                  
                  // Favorite button
                  Consumer<WishlistProvider>(
                    builder: (context, wishlistProvider, child) {
                      final isInWishlist = wishlistProvider.isInWishlist(widget.variant);
                      
                      return IconButton(
                        icon: Container(
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
                            isInWishlist ? Icons.favorite : Icons.favorite_border,
                            color: isInWishlist ? Colors.red : widget.categoryColor,
                          ),
                        ),
                        onPressed: () {
                          wishlistProvider.toggleWishlistItem(widget.variant);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isInWishlist
                                    ? '${widget.variant.name} removed from wishlist'
                                    : '${widget.variant.name} added to wishlist'
                              ),
                              duration: Duration(seconds: 1),
                              backgroundColor: isInWishlist ? Colors.red : widget.categoryColor,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Share button
                  IconButton(
                    icon: Container(
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
                      child: Icon(Icons.share, color: widget.categoryColor),
                    ),
                    onPressed: () {
                      // Share functionality
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Add to cart button or counter at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: itemCount > 0
                    ? _buildCartCounterButton(cartIconOffset)
                    : _buildAddToCartButton(cartIconOffset),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRatingWidget() {
    return Row(
      children: [
        ...List.generate(5, (index) => 
          Icon(
            index < 4 ? Icons.star : Icons.star_border,
            color: index < 4 ? Colors.amber : Colors.grey[400],
            size: 18,
          )
        ),
        SizedBox(width: 6),
        Text(
          '(4.0)',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: () {
              if (quantity > 1) {
                setState(() {
                  quantity--;
                });
              }
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: () {
              setState(() {
                quantity++;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.categoryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: widget.categoryColor,
          size: 16,
        ),
      ),
    );
  }
  
  String _getDescription() {
    // Dummy descriptions for demo purpose
    final descriptions = [
      "This premium quality ${widget.variant.name.toLowerCase()} is sourced from organic farms and carefully selected to ensure the best taste and freshness. Perfect for your daily needs and healthy lifestyle.",
      "Enjoy our fresh ${widget.variant.name.toLowerCase()} which is packed with essential nutrients and vitamins. Sourced directly from local farmers to guarantee quality and freshness.",
      "Our ${widget.variant.name.toLowerCase()} is handpicked to ensure premium quality. It contains essential nutrients that are beneficial for your health.",
      "Premium quality ${widget.variant.name.toLowerCase()} that's perfect for your everyday cooking needs. Sustainably sourced and carefully selected for the best taste experience.",
    ];
    
    // Generate a consistent index based on variant ID to always show same description
    int varId = 0;
    try {
      varId = int.parse(widget.variant.var_id);
    } catch (e) {
      varId = widget.variant.name.length;
    }
    
    final index = varId % descriptions.length;
    return descriptions[index];
  }
  
  Widget _buildOtherVariantsSection() {
    // Get all variants from the parent product except the current one
    List<Variant> otherVariants = widget.parentProduct!.variants
        .where((v) => v.var_id != widget.variant.var_id)
        .toList();
    
    if (otherVariants.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Other Variants",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: otherVariants.length,
            itemBuilder: (context, index) {
              final variant = otherVariants[index];
              return _buildOtherVariantCard(variant);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildOtherVariantCard(Variant variant) {
    final bool hasDiscount = variant.discount != '' && variant.discount != '0%';
    final cartProvider = Provider.of<CartProvider>(context);
    final GlobalKey _variantImageKey = GlobalKey();
    final itemCount = cartProvider.getItemCount(variant);
    final cartIconOffset = Offset(
      MediaQuery.of(context).size.width - 70,
      MediaQuery.of(context).padding.top + 40,
    );
    
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              variant: variant,
              categoryColor: widget.categoryColor,
              parentCategory: widget.parentCategory,
              parentProduct: widget.parentProduct,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    key: _variantImageKey,
                    height: 120,
                    width: double.infinity,
                    color: widget.categoryColor.withOpacity(0.05),
                    child: Image.asset(
                      variant.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: widget.categoryColor.withOpacity(0.3),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
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
            
            // Details
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
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
                      Text(
                        variant.curr_price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: widget.categoryColor,
                        ),
                      ),
                      itemCount > 0
                          ? _buildVariantCounter(
                              variant: variant,
                              count: itemCount,
                              cartProvider: cartProvider,
                              variantImageKey: _variantImageKey,
                              cartIconOffset: cartIconOffset,
                            )
                          : _buildVariantAddButton(
                              variant: variant,
                              cartProvider: cartProvider,
                              variantImageKey: _variantImageKey,
                              cartIconOffset: cartIconOffset,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildVariantAddButton({
    required Variant variant,
    required CartProvider cartProvider,
    required GlobalKey variantImageKey,
    required Offset cartIconOffset,
  }) {
    return InkWell(
      onTap: () {
        // Add to cart
        cartProvider.addToMainCart(variant);
        
        // Animation - fly to cart
        CartAnimations.flyToCart(
          context,
          variantImageKey,
          variant.image,
          cartIconPos: cartIconOffset,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${variant.name} added to cart'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: widget.categoryColor,
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: widget.categoryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_shopping_cart_outlined,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
  
  Widget _buildVariantCounter({
    required Variant variant,
    required int count,
    required CartProvider cartProvider,
    required GlobalKey variantImageKey,
    required Offset cartIconOffset,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.categoryColor),
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
              width: 20,
              decoration: BoxDecoration(
                color: widget.categoryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
          
          // Counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: widget.categoryColor,
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
                variantImageKey,
                variant.image,
                cartIconPos: cartIconOffset,
              );
            },
            child: Container(
              width: 20,
              decoration: BoxDecoration(
                color: widget.categoryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCartCounterButton(Offset cartIconOffset) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final itemCount = cartProvider.getItemCount(widget.variant);
    
    return Row(
      children: [
        // Price
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${widget.variant.curr_price}',
                  style: TextStyle(
                    color: widget.categoryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Counter
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: widget.categoryColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Decrease button
              InkWell(
                onTap: () {
                  if (itemCount > 1) {
                    cartProvider.decreaseItemQuantity(widget.variant);
                  } else {
                    cartProvider.removeFromCart(widget.variant);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.categoryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              
              // Counter
              Container(
                width: 60,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    itemCount.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.categoryColor,
                    ),
                  ),
                ),
              ),
              
              // Increase button
              InkWell(
                onTap: () {
                  cartProvider.increaseItemQuantity(widget.variant);
                  
                  // Animation - fly to cart
                  CartAnimations.flyToCart(
                    context,
                    _productImageKey,
                    widget.variant.image,
                    cartIconPos: cartIconOffset,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.categoryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildAddToCartButton(Offset cartIconOffset) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    return ElevatedButton(
      onPressed: () {
        // Add to cart functionality
        for (int i = 0; i < quantity; i++) {
          cartProvider.addToMainCart(widget.variant);
        }
        
        // Animation - fly to cart
        CartAnimations.flyToCart(
          context,
          _productImageKey,
          widget.variant.image,
          cartIconPos: cartIconOffset,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${quantity} ${widget.variant.name} added to cart'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: widget.categoryColor,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.categoryColor,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        shadowColor: widget.categoryColor.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Add to Cart - ${widget.variant.curr_price}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 