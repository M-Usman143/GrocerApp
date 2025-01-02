import 'package:flutter/material.dart';
import 'package:GrocerApp/FAQ/FAQScreen.dart';
import 'package:GrocerApp/pages/MyCartScreen.dart';
import 'package:GrocerApp/pages/MyProfile.dart';
import 'package:GrocerApp/pages/ProfileGetter.dart';
import 'package:GrocerApp/pages/ViewAllWishList.dart';
import 'package:GrocerApp/pages/WelcomeScreen.dart';
import 'package:GrocerApp/pages/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/ShareUtil.dart';
import '../Common/SharedPreferenceHelper.dart';
import '../pages/LocationScreen.dart';
import '../products_category/categories_page_ui.dart';

class Drawer_home extends StatefulWidget {

  const Drawer_home({super.key});

  @override
  State<Drawer_home> createState() => _Drawer_homeState();
}

class _Drawer_homeState extends State<Drawer_home> {
  String? _userLocation;


  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userLocation = prefs.getString('user_location') ?? 'Location not set';
    });
  }

  // Build the location container
  Widget buildLocationContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocationScreen()),
        );
      },
      child: Container(
        width: 250,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 3),
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
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Hey, Muhammad Usman',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Location Container
          buildLocationContainer(context),

          // List of navigation items
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesPageshow()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  MyCartScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_2_rounded),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark_rounded),
            title: const Text('Customer Care'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerCarePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('GrocerClub'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GrocerClubPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              final productName = "Product Name";
              final productPrice = "Product Price";
              final productUrl = "https://www.example.com/products/product-id";
              ShareUtil.shareProductDetails(productName, productPrice, productUrl);
            },
          ),
          ListTile(
            leading: const Icon(Icons.query_stats),
            title: const Text('FAQs'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Wish List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  WishListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign In'),
            onTap: () async {
              await SharedPreferencesHelper.clearPhoneNumber();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}



class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: const Center(child: Text('Orders Page')),
    );
  }
}

class CustomerCarePage extends StatelessWidget {
  const CustomerCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Care')),
      body: const Center(child: Text('Customer Care Page')),
    );
  }
}

class GrocerClubPage extends StatelessWidget {
  const GrocerClubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GrocerClub')),
      body: const Center(child: Text('GrocerClub Page')),
    );
  }
}
