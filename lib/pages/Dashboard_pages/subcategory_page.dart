import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Models/model.dart';
import '../../../theme/app_theme.dart';
import '../../../Common/WishListProvider.dart';
import '../../../Common/Cart Provider.dart';
import 'product_detail_page.dart';
import 'wishlist_page.dart';
import '../../../utils/cart_animations.dart';
import '../../../pages/MyCartScreen.dart';

class SubcategoryPage extends StatefulWidget {
  final Categories category;

  const SubcategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _SubcategoryPageState createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  late PageController _pageController;
  int _selectedSubcategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  List<Variant> _filteredVariants = [];
  Map<String, int> _variantQuantities = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedSubcategoryIndex);
    _filteredVariants = widget.category.products.isNotEmpty 
        ? List.from(widget.category.products[_selectedSubcategoryIndex].variants)
        : [];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToSelectedSubcategory() {
    if (_scrollController.hasClients) {
      final itemWidth = 120.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final targetPosition = (_selectedSubcategoryIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
      
      _scrollController.animateTo(
        targetPosition < 0 ? 0 : targetPosition,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _searchVariants(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredVariants = widget.category.products[_selectedSubcategoryIndex].variants;
      });
      return;
    }
    
    final variants = widget.category.products[_selectedSubcategoryIndex].variants;
    final results = variants.where((variant) {
      return variant.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    setState(() {
      _filteredVariants = results;
    });
  }

  Color _getCategoryColor() {
    final name = widget.category.name.toLowerCase();
    
    if (name.contains('breakfast')) {
      return Colors.orange;
    } else if (name.contains('meat') || name.contains('fish')) {
      return Colors.redAccent;
    } else if (name.contains('vegetable') || name.contains('veg')) {
      return Colors.green;
    } else if (name.contains('fruit')) {
      return Colors.deepOrange;
    } else if (name.contains('dairy')) {
      return Colors.lightBlue;
    } else if (name.contains('bakery') || name.contains('bread')) {
      return Colors.brown;
    } else if (name.contains('snack')) {
      return Colors.amber;
    } else if (name.contains('beverage') || name.contains('drink')) {
      return Colors.teal;
    } else if (name.contains('household')) {
      return Colors.indigo;
    } else if (name.contains('personal')) {
      return Colors.purple;
    }
    
    return AppTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    final cartIconOffset = Offset(MediaQuery.of(context).size.width - 60, 60);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    categoryColor.withOpacity(0.8),
                    categoryColor.withOpacity(0.6),
                    categoryColor.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: _showSearch 
                          ? _buildSearchField(categoryColor)
                          : Text(
                              widget.category.name,
                              style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _showSearch ? Icons.close : Icons.search, 
                            color: Colors.white
                          ),
                          onPressed: () {
                            setState(() {
                              _showSearch = !_showSearch;
                              if (!_showSearch) {
                                _searchController.clear();
                                _searchVariants('');
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          final itemCount = cartProvider.getTotalItems();
                          
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
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
                    ],
                  ),
                  
                  if (!_showSearch)
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${widget.category.products.length} Subcategories',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.category.products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSubcategoryIndex = index;
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        _filteredVariants = widget.category.products[index].variants;
                        if (_showSearch && _searchController.text.isNotEmpty) {
                          _searchVariants(_searchController.text);
                        }
                      });
                      _scrollToSelectedSubcategory();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
                      decoration: BoxDecoration(
                        color: _selectedSubcategoryIndex == index 
                            ? categoryColor.withOpacity(0.1) 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedSubcategoryIndex == index 
                              ? categoryColor 
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.category.products[index].name,
                          style: TextStyle(
                            fontWeight: _selectedSubcategoryIndex == index 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                            color: _selectedSubcategoryIndex == index 
                                ? categoryColor 
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Expanded(
              child: _showSearch
                ? _buildSearchResults(categoryColor)
                : PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedSubcategoryIndex = index;
                        _filteredVariants = widget.category.products[index].variants;
                      });
                      _scrollToSelectedSubcategory();
                    },
                    itemCount: widget.category.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.category.products[index];
                      return _buildProductVariantsList(product, categoryColor);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSearchField(Color categoryColor) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search products...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: Colors.white70),
        suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear, color: Colors.white70),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchVariants('');
                });
              },
            )
          : null,
      ),
      onChanged: _searchVariants,
    );
  }
  
  Widget _buildSearchResults(Color categoryColor) {
    if (_filteredVariants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _filteredVariants.length,
      itemBuilder: (context, index) {
        final variant = _filteredVariants[index];
        return _buildVariantCard(variant, categoryColor);
      },
    );
  }

  Widget _buildProductVariantsList(Products product, Color categoryColor) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: product.variants.length,
      itemBuilder: (context, index) {
        final variant = product.variants[index];
        return _buildVariantCard(variant, categoryColor);
      },
    );
  }

  Widget _buildVariantCard(Variant variant, Color categoryColor) {
    bool hasDiscount = variant.discount.isNotEmpty && variant.discount != '0%';
    final GlobalKey _productImageKey = GlobalKey();
    final cartIconOffset = Offset(MediaQuery.of(context).size.width - 60, 60);
    
    return Consumer2<WishlistProvider, CartProvider>(
      builder: (context, wishlistProvider, cartProvider, child) {
        final isInWishlist = wishlistProvider.isInWishlist(variant);
        final itemCount = cartProvider.getItemCount(variant);
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  variant: variant,
                  categoryColor: categoryColor,
                  parentCategory: widget.category,
                  parentProduct: widget.category.products[_selectedSubcategoryIndex],
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
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            isInWishlist ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                          ),
                          color: isInWishlist ? Colors.red : categoryColor,
                          onPressed: () {
                            wishlistProvider.toggleWishlistItem(variant);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isInWishlist
                                      ? '${variant.name} removed from wishlist'
                                      : '${variant.name} added to wishlist'
                                ),
                                duration: Duration(seconds: 1),
                                backgroundColor: isInWishlist ? Colors.red : categoryColor,
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
                                    color: categoryColor,
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
                                    categoryColor: categoryColor,
                                    cartIconOffset: cartIconOffset,
                                  )
                                : _buildAddButton(
                                    variant: variant,
                                    cartProvider: cartProvider,
                                    productImageKey: _productImageKey,
                                    categoryColor: categoryColor,
                                    cartIconOffset: cartIconOffset,
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
      },
    );
  }
  
  Widget _buildAddButton({
    required Variant variant,
    required CartProvider cartProvider,
    required GlobalKey productImageKey,
    required Color categoryColor,
    required Offset cartIconOffset,
  }) {
    return ElevatedButton.icon(
      icon: Icon(
        Icons.shopping_cart_outlined,
        size: 16,
        color: Colors.white,
      ),
      label: Text(
        'Add',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: categoryColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            backgroundColor: categoryColor,
          ),
        );
      },
    );
  }
  
  Widget _buildCounterButton({
    required Variant variant,
    required int count,
    required CartProvider cartProvider,
    required GlobalKey productImageKey,
    required Color categoryColor,
    required Offset cartIconOffset,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: categoryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 36,
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
                color: categoryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          
          // Counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: categoryColor,
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
                color: categoryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}