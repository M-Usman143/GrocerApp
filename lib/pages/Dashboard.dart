import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../products_category/dummy_data.dart';
import 'Dashboard_pages/HomePage.dart';
import 'Dashboard_pages/account_page.dart';
import 'Dashboard_pages/categories_page.dart';
import 'Dashboard_pages/orders_page.dart';
import 'Dashboard_pages/wishlist_page.dart';
import 'Dashboard_widgets/custom_app_bar.dart';
import 'Dashboard_widgets/location_widget.dart';
import 'Dashboard_widgets/search_widget.dart';
import '../LocationScreen.dart';
import '../../LocalStorageHelper/LocalStorageService.dart';
import 'package:provider/provider.dart';
import '../../Common/WishListProvider.dart';
import '../../Common/Cart Provider.dart';
import '../../pages/MyCartScreen.dart';

class Dashboard extends StatefulWidget {
  final String? userLocation;
  
  Dashboard({this.userLocation});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool _showBackButton = false;
  String _pageTitle = 'Home';
  String? _currentLocation;
  
  late final List<Widget> _pages;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _currentLocation = widget.userLocation;
    _loadUserLocation();
    _pages = [
      HomePage(userLocation: _currentLocation),
      CategoriesPage(),
      OrdersPage(),
      AccountPage(),
    ];
    
    // Set system UI overlay style to match green app bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green, // Make status bar green
      statusBarIconBrightness: Brightness.light, // Make status bar icons white
    ));
  }

  Future<void> _loadUserLocation() async {
    if (_currentLocation == null) {
      final savedLocation = await LocalStorageService.getUserLocation();
      if (savedLocation != null && mounted) {
        setState(() {
          _currentLocation = savedLocation;
          _updatePages();
        });
      }
    }
  }

  void _updatePages() {
    setState(() {
      _pages[0] = HomePage(userLocation: _currentLocation);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update page title based on selected index
    _updatePageTitle();
    
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Column(
          children: [
            // Custom App Bar
            Container(
              color: Colors.green,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      if (_showBackButton)
                        IconButton(
                          onPressed: _onBackPressed,
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      if (_showBackButton) SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _pageTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Consumer<WishlistProvider>(
                        builder: (context, wishlistProvider, child) {
                          return Stack(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: Text('My Wishlist'),
                                          backgroundColor: Colors.green,
                                        ),
                                        body: WishlistPage(),
                                      ),
                                    ),
                                  );
                                  wishlistProvider.loadWishlistItems();
                                },
                                icon: Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                ),
                              ),
                              if (wishlistProvider.wishlistCount > 0)
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${wishlistProvider.wishlistCount}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return Stack(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyCartScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              if (cartProvider.uniqueProductCount > 0)
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${cartProvider.uniqueProductCount}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Location and Search Widgets (only shown on Home page)
            if (_selectedIndex == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    // Location Widget
                    LocationWidget(
                      userLocation: _currentLocation ?? 'Set your location',
                      onTap: () => _navigateToLocationScreen(),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Search Widget
                    SearchWidget(
                      controller: _searchController,
                      onTap: () {
                        // Handle search tap
                      },
                      onChanged: (value) {
                        // Handle search text change
                      },
                    ),
                  ],
                ),
              ),
            
            // Main Content
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  void _updatePageTitle() {
    switch (_selectedIndex) {
      case 0:
        _pageTitle = 'Home';
        _showBackButton = false;
        break;
      case 1:
        _pageTitle = 'Categories';
        _showBackButton = true;
        break;
      case 2:
        _pageTitle = 'My Orders';
        _showBackButton = true;
        break;
      case 3:
        _pageTitle = 'Account';
        _showBackButton = true;
        break;
      default:
        _pageTitle = 'GrocerApp';
        _showBackButton = false;
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  void _onBackPressed() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  void _navigateToLocationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationScreen()),
    );
    
    // Handle the result if needed
    if (result != null && result is String && mounted) {
      setState(() {
        _currentLocation = result;
        _updatePages();
      });
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.category_outlined, Icons.category_rounded, 'Categories'),
              _buildNavItem(2, Icons.receipt_long_outlined, Icons.receipt_rounded, 'Orders'),
              _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, 'Account'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    bool isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? Colors.green : Colors.grey[600],
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}