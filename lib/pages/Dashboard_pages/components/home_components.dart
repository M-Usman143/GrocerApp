import 'package:flutter/material.dart';
import '../../../../Models/model.dart';
import '../../../../theme/app_theme.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'subCategory_components.dart';

// Search Bar Widget
class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
        onTap: () {
          // Navigate to search screen
        },
      ),
    );
  }
}

// Banner Carousel
class BannerCarousel extends StatefulWidget {
  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  int _currentPage = 0;

  final List<Map<String, dynamic>> banners = [
    {
      'title': 'Fresh Veggies',
      'subtitle': 'Up to 40% OFF',
      'color': Colors.green,
    },
    {
      'title': 'Weekend Sale',
      'subtitle': 'Save Big on Groceries',
      'color': Colors.blue,
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Check out our latest products',
      'color': Colors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        _autoScroll();
      }
    });
  }

  void _autoScroll() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        if (_currentPage < banners.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
        _autoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: 150,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        banner['color'],
                        banner['color'].withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
                          ),
                          child: Opacity(
                            opacity: 0.2,
                            child: Icon(
                              Icons.shopping_basket,
                              size: 150,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              banner['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              banner['subtitle'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: banner['color'],
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Shop Now'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppTheme.primaryColor
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Category Row
class CategoryRow extends StatelessWidget {
  final List<Categories> categories;
  
  CategoryRow({required this.categories});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryColor = _getCategoryColor(category.name);
          final categoryIcon = _getCategoryIcon(category.name);
          
          return Container(
            width: 90,
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  category.name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  // Helper method to get icon based on category name
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'breakfast essentails':
        return Icons.breakfast_dining;
      case 'milk & dairy':
        return Icons.water_drop;
      case 'fruits & vegetables':
        return Icons.eco;
      case 'beverages':
        return Icons.local_drink;
      case 'snacks & packaged foods':
        return Icons.fastfood;
      case 'personal care':
        return Icons.face;
      case 'staples & grains':
        return Icons.grain;
      default:
        return Icons.category;
    }
  }
  
  // Helper method to get color based on category name
  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'breakfast essentails':
        return Colors.orange;
      case 'milk & dairy':
        return Colors.blue;
      case 'fruits & vegetables':
        return Colors.green;
      case 'beverages':
        return Colors.purple;
      case 'snacks & packaged foods':
        return Colors.red;
      case 'personal care':
        return Colors.teal;
      case 'staples & grains':
        return Colors.amber;
      default:
        return AppTheme.primaryColor;
    }
  }
}

// Trending Products List
class TrendingProductsList extends StatelessWidget {
  final List<Categories> categories;
  
  TrendingProductsList({required this.categories});
  
  @override
  Widget build(BuildContext context) {
    // Create a list of trending variants from all categories
    List<Map<String, dynamic>> trendingProducts = [];
    
    for (var category in categories) {
      for (var product in category.products) {
        for (var variant in product.variants) {
          if (variant.isTrending) {
            trendingProducts.add({
              'variant': variant,
              'product': product,
              'category': category,
            });
          }
        }
      }
    }
    
    // Sort by trending status
    trendingProducts.sort((a, b) {
      if (a['variant'].isTrending && !b['variant'].isTrending) return -1;
      if (!a['variant'].isTrending && b['variant'].isTrending) return 1;
      return 0;
    });
    
    return Container(
      height: 220,
      child: trendingProducts.isEmpty
          ? Center(child: Text('No trending products available'))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: trendingProducts.length > 10 ? 10 : trendingProducts.length, // Limit to 10 items
              itemBuilder: (context, index) {
                final trendingProduct = trendingProducts[index];
                final variant = trendingProduct['variant'] as Variant;
                final product = trendingProduct['product'] as Products;
                final category = trendingProduct['category'] as Categories;
                
                return Container(
                  width: 160,
                  margin: EdgeInsets.symmetric(horizontal: 8),
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
                      // Product Image
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              variant.image,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                Container(
                                  height: 120,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                                ),
                            ),
                          ),
                          // Discount tag
                          if (variant.discount.isNotEmpty)
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
                          // Trending tag
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Trending',
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
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              variant.weight,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  variant.curr_price,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  variant.pre_price,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
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
            ),
    );
  }
}

// Special Offers List
class SpecialOffersList extends StatelessWidget {
  final List<Map<String, dynamic>> offers = [
    {
      'title': 'Weekend Special',
      'description': 'Flat 30% off on selected items',
      'color': Colors.orange,
      'icon': Icons.local_offer,
    },
    {
      'title': 'New User Offer',
      'description': 'Get 50% off on your first order',
      'color': Colors.purple,
      'icon': Icons.person_add,
    },
    {
      'title': 'Free Delivery',
      'description': 'On orders above Rs 500',
      'color': Colors.blue,
      'icon': Icons.delivery_dining,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          
          return Container(
            width: 250,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  offer['color'],
                  offer['color'].withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -15,
                  bottom: -15,
                  child: Icon(
                    offer['icon'],
                    size: 100,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        offer['description'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: offer['color'],
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(0, 30),
                        ),
                        child: Text(
                          'View Offer',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}