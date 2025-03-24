import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../pages/MyCartScreen.dart';
import '../../OrderCompleted/OrderCompletedScreen.dart';
import 'wishlist_page.dart';
import '../../LocationScreen.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile edit form would go here
            Text('Edit your profile information here'),
          ],
        ),
      ),
    );
  }
}

class SavedAddressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Addresses'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Saved addresses would go here
          Text('Your saved addresses will appear here'),
        ],
      ),
    );
  }
}

class PaymentMethodsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Payment methods would go here
          Text('Your payment methods will appear here'),
        ],
      ),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Notification settings would go here
          Text('Manage your notification preferences here'),
        ],
      ),
    );
  }
}

class RecentlyViewedPage extends StatelessWidget {
  // Sample data for recently viewed products
  final List<Map<String, dynamic>> recentlyViewedProducts = [
    {
      'name': 'Organic Bananas',
      'image': 'assets/images/product5.png',
      'price': '\$5.99',
      'timestamp': '2 hours ago',
    },
    {
      'name': 'Fresh Apples',
      'image': 'assets/images/product7.png',
      'price': '\$4.99',
      'timestamp': 'Yesterday',
    },
    {
      'name': 'Avocado',
      'image': 'assets/images/product8.png',
      'price': '\$3.99',
      'timestamp': '2 days ago',
    },
    {
      'name': 'Milk Carton',
      'image': 'assets/images/product4.png',
      'price': '\$2.99',
      'timestamp': '3 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recently Viewed Products'),
        backgroundColor: Colors.green,
      ),
      body: recentlyViewedProducts.isEmpty
          ? _buildEmptyState()
          : _buildProductsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_off,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No recently viewed products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Products you view will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: recentlyViewedProducts.length,
      itemBuilder: (context, index) {
        final product = recentlyViewedProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Product image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(product['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Product details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product['price'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Viewed ${product['timestamp']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // View button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to product detail
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'View',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reviews'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User reviews would go here
          Text('Your product reviews will appear here'),
        ],
      ),
    );
  }
}

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Help center content would go here
          Text('Find help and support here'),
        ],
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contact form would go here
            Text('Contact our support team'),
          ],
        ),
      ),
    );
  }
}

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('1. Introduction'),
          _buildSectionContent(
            'Welcome to GrocerApp. These Terms and Conditions govern your use of our mobile application and the services we provide. By accessing or using GrocerApp, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you disagree with any part of these terms, please do not use our application.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('2. Definitions'),
          _buildSectionContent(
            '"App" refers to the GrocerApp mobile application.\n\n'
            '"User," "You," and "Your" refers to the individual accessing or using the App.\n\n'
            '"Company," "We," "Us," and "Our" refers to GrocerApp.\n\n'
            '"Goods" refers to the items offered for sale on the App.\n\n'
            '"Services" refers to any services offered through the App, including delivery services.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('3. User Accounts'),
          _buildSectionContent(
            '3.1 You must create an account to use certain features of the App. You must provide accurate, current, and complete information during the registration process.\n\n'
            '3.2 You are responsible for safeguarding your account credentials and for any activities or actions under your account.\n\n'
            '3.3 You agree to notify us immediately of any unauthorized access to or use of your username or password.\n\n'
            '3.4 We reserve the right to disable any user account at any time if, in our opinion, you have failed to comply with these Terms and Conditions.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('4. Orders and Payments'),
          _buildSectionContent(
            '4.1 All orders are subject to acceptance and availability. We reserve the right to refuse any order without giving reasons.\n\n'
            '4.2 Prices for Goods are subject to change without notice.\n\n'
            '4.3 Payment must be made through the payment methods available on the App.\n\n'
            '4.4 You agree to provide current, complete, and accurate purchase information for all purchases made via the App.\n\n'
            '4.5 We reserve the right to refuse or cancel your order if fraud or an unauthorized or illegal transaction is suspected.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('5. Delivery'),
          _buildSectionContent(
            '5.1 Delivery times are estimates and not guaranteed. We are not liable for any delays in delivery.\n\n'
            '5.2 You are responsible for ensuring that the delivery address provided is accurate and complete.\n\n'
            '5.3 Risk of loss and title for items purchased from the App pass to you upon delivery of the items to the shipping carrier or, if applicable, upon delivery to your specified delivery location.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('6. Returns and Refunds'),
          _buildSectionContent(
            '6.1 You may return Goods within 24 hours of delivery if they are damaged, defective, or not as described.\n\n'
            '6.2 To initiate a return, please contact our customer support through the App.\n\n'
            '6.3 Refunds will be processed to the original payment method, typically within 5-7 business days.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('7. Intellectual Property'),
          _buildSectionContent(
            '7.1 The App and its original content, features, and functionality are owned by GrocerApp and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.\n\n'
            '7.2 You may not reproduce, distribute, modify, create derivative works of, publicly display, publicly perform, republish, download, store, or transmit any of the material on our App.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('8. Limitation of Liability'),
          _buildSectionContent(
            '8.1 In no event shall GrocerApp, its directors, employees, partners, agents, suppliers, or affiliates be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses resulting from:\n\n'
            '(a) Your access to or use of or inability to access or use the App;\n'
            '(b) Any conduct or content of any third party on the App;\n'
            '(c) Any content obtained from the App; and\n'
            '(d) Unauthorized access, use, or alteration of your transmissions or content.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('9. Termination'),
          _buildSectionContent(
            '9.1 We may terminate or suspend your account and bar access to the App immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever, including without limitation if you breach the Terms.\n\n'
            '9.2 All provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity, and limitations of liability.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('10. Changes to Terms'),
          _buildSectionContent(
            '10.1 We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect.\n\n'
            '10.2 By continuing to access or use our App after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use the App.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('11. Governing Law'),
          _buildSectionContent(
            'These Terms shall be governed and construed in accordance with the laws of [Your Country/State], without regard to its conflict of law provisions.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('12. Contact Us'),
          _buildSectionContent(
            'If you have any questions about these Terms, please contact us at support@grocerapp.com.'
          ),
          
          SizedBox(height: 16),
          Text(
            'Last updated: May 1, 2023',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
    );
  }
  
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Colors.black87,
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Privacy Policy'),
          _buildSectionContent(
            'GrocerApp is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this Privacy Policy carefully. By using the App, you consent to the data practices described in this statement.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('1. Information We Collect'),
          _buildSectionContent(
            'We may collect information about you in various ways, including:\n\n'
            '1.1 Personal Information: When you register an account, place an order, or use our services, we may collect personal information such as your name, email address, phone number, delivery address, and payment information.\n\n'
            '1.2 Usage Information: We automatically collect certain information about your device and how you interact with our App, including your IP address, device type, operating system, browser type, app interactions, and time spent on various screens.\n\n'
            '1.3 Location Information: With your consent, we may collect and process information about your precise or approximate location to provide location-based services such as delivery.\n\n'
            '1.4 Transaction Information: We collect information related to your purchases, including items purchased, prices, payment method, and delivery details.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('2. How We Use Your Information'),
          _buildSectionContent(
            'We may use the information we collect for various purposes, including to:\n\n'
            '2.1 Provide, maintain, and improve our services;\n\n'
            '2.2 Process and fulfill your orders and send related information, including order confirmations and delivery updates;\n\n'
            '2.3 Communicate with you about products, services, offers, promotions, and events, and provide news and information we think will be of interest to you;\n\n'
            '2.4 Personalize your experience and deliver content and product offerings relevant to your interests;\n\n'
            '2.5 Monitor and analyze trends, usage, and activities in connection with our services;\n\n'
            '2.6 Detect, investigate, and prevent fraudulent transactions and other illegal activities and protect the rights and property of GrocerApp and others;\n\n'
            '2.7 Comply with legal obligations.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('3. Sharing Your Information'),
          _buildSectionContent(
            'We may share your information in the following circumstances:\n\n'
            '3.1 With service providers, such as delivery partners, payment processors, and cloud service providers who perform services on our behalf;\n\n'
            '3.2 With business partners with whom we jointly offer products or services;\n\n'
            '3.3 In response to legal process or request from public and governmental authorities;\n\n'
            '3.4 To protect our rights, privacy, safety, or property, or that of our customers or others;\n\n'
            '3.5 In connection with or during negotiation of any merger, sale of company assets, financing, or acquisition of all or a portion of our business to another company;\n\n'
            '3.6 With your consent or at your direction.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('4. Data Security'),
          _buildSectionContent(
            'We implement appropriate technical and organizational measures to protect the security of your personal information. However, please be aware that no method of transmission over the internet or electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('5. Your Rights and Choices'),
          _buildSectionContent(
            'Depending on your location, you may have certain rights regarding your personal information, including:\n\n'
            '5.1 Access: You may request access to your personal information that we hold.\n\n'
            '5.2 Correction: You may request that we correct inaccurate or incomplete information about you.\n\n'
            '5.3 Deletion: You may request that we delete your personal information in certain circumstances.\n\n'
            '5.4 Restriction: You may request that we restrict the processing of your information in certain circumstances.\n\n'
            '5.5 Portability: You may request to receive your personal information in a structured, commonly used, and machine-readable format.\n\n'
            '5.6 Objection: You may object to our processing of your personal information in certain circumstances.\n\n'
            'To exercise these rights, please contact us using the information provided in the "Contact Us" section below.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('6. Data Retention'),
          _buildSectionContent(
            'We will retain your personal information for as long as necessary to fulfill the purposes for which we collected it, including for the purposes of satisfying any legal, accounting, or reporting requirements. To determine the appropriate retention period, we consider the amount, nature, and sensitivity of the personal information, the potential risk of harm from unauthorized use or disclosure, and applicable legal requirements.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('7. Children\'s Privacy'),
          _buildSectionContent(
            'Our services are not intended for children under the age of 13, and we do not knowingly collect personal information from children under 13. If we learn that we have collected personal information from a child under 13, we will take steps to delete such information as quickly as possible.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('8. International Data Transfers'),
          _buildSectionContent(
            'Your information may be transferred to, and maintained on, computers located outside of your state, province, country, or other governmental jurisdiction where the data protection laws may differ from those in your jurisdiction. If you are located outside the United States and choose to provide information to us, please note that we transfer the information to the United States and process it there.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('9. Third-Party Services'),
          _buildSectionContent(
            'Our App may contain links to third-party websites or services that are not owned or controlled by GrocerApp. We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third-party websites or services. We strongly advise you to review the privacy policy of every website you visit.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('10. Changes to This Privacy Policy'),
          _buildSectionContent(
            'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.'
          ),
          
          SizedBox(height: 16),
          _buildSectionTitle('11. Contact Us'),
          _buildSectionContent(
            'If you have any questions about this Privacy Policy, please contact us at privacy@grocerapp.com.'
          ),
          
          SizedBox(height: 16),
          Text(
            'Last updated: May 1, 2023',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
    );
  }
  
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Colors.black87,
      ),
    );
  }
}

class Order {
  final String id;
  final String date;
  final double amount;
  final String status; // "completed", "pending", "cancelled"
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final String image;
  final double price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });
}

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String _selectedFilter = 'All';
  
  // Sample orders data
  final List<Order> _orders = [
    Order(
      id: 'GR-2023-45678',
      date: '15 Apr 2023',
      amount: 52.55,
      status: 'completed',
      items: [
        OrderItem(
          name: 'Organic Bananas',
          image: 'assets/images/product5.png',
          price: 5.99,
          quantity: 2,
        ),
        OrderItem(
          name: 'Fresh Apples',
          image: 'assets/images/product7.png',
          price: 4.99,
          quantity: 3,
        ),
      ],
    ),
    Order(
      id: 'GR-2023-57891',
      date: '20 Apr 2023',
      amount: 37.25,
      status: 'pending',
      items: [
        OrderItem(
          name: 'Fresh Milk',
          image: 'assets/images/product4.png',
          price: 3.49,
          quantity: 1,
        ),
        OrderItem(
          name: 'Brown Eggs',
          image: 'assets/images/product9.png',
          price: 6.99,
          quantity: 2,
        ),
      ],
    ),
    Order(
      id: 'GR-2023-63421',
      date: '10 Apr 2023',
      amount: 22.15,
      status: 'cancelled',
      items: [
        OrderItem(
          name: 'Red Peppers',
          image: 'assets/images/product8.png',
          price: 3.99,
          quantity: 1,
        ),
      ],
    ),
  ];

  List<Order> get filteredOrders {
    if (_selectedFilter == 'All') {
      return _orders;
    } else {
      return _orders.where((order) => order.status.toLowerCase() == _selectedFilter.toLowerCase()).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          _buildFilterOptions(),
          Expanded(
            child: filteredOrders.isEmpty
                ? _buildEmptyState()
                : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip('All'),
            SizedBox(width: 8),
            _buildFilterChip('Completed'),
            SizedBox(width: 8),
            _buildFilterChip('Pending'),
            SizedBox(width: 8),
            _buildFilterChip('Cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No ${_selectedFilter.toLowerCase()} orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'You haven\'t placed any orders yet'
                : 'You don\'t have any ${_selectedFilter.toLowerCase()} orders',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return GestureDetector(
      onTap: () {
        // Only completed orders can be viewed in detail
        if (order.status == 'completed') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderCompletedScreen(
                orderNumber: order.id,
                totalAmount: order.amount,
                deliveryDate: 'Tomorrow',
                deliveryTime: '02:00 - 05:00 PM',
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(order),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildOrderItemsList(order),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildOrderFooter(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(Order order) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Placed on ${order.date}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          _buildStatusBadge(order.status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    
    switch (status.toLowerCase()) {
      case 'completed':
        badgeColor = Colors.green;
        break;
      case 'pending':
        badgeColor = Colors.orange;
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildOrderItemsList(Order order) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          ...order.items.map((item) => _buildOrderItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(item.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderFooter(Order order) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Total:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                '\$${order.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (order.status == 'completed')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderCompletedScreen(
                            orderNumber: order.id,
                            totalAmount: order.amount,
                            deliveryDate: 'Tomorrow',
                            deliveryTime: '02:00 - 05:00 PM',
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'ORDER DETAILS',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (order.status == 'pending')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle cancel order action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red[700],
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CANCEL ORDER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final String userName = "John Doe";
  final String userEmail = "johndoe@example.com";
  final String userPhone = "+1 123-456-7890";
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          SizedBox(height: 16),
          _buildSectionTitle('Account Settings'),
          _buildMenuList(),
          SizedBox(height: 16),
          _buildSectionTitle('My Activity'),
          _buildActivityList(),
          SizedBox(height: 16),
          _buildSectionTitle('Help & Support'),
          _buildSupportList(),
          SizedBox(height: 24),
          _buildLogoutButton(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.green,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white.withOpacity(0.9),
                child: Text(
                  userName.substring(0, 1),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      userPhone,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem('My Profile', Icons.person_outline, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }),
          Divider(height: 1),
          _buildMenuItem('Notification Settings', Icons.notifications_none_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem('My Orders', Icons.shopping_bag_outlined, () {
            // Navigate to orders history page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryPage()),
            );
          }),
          Divider(height: 1),
          _buildMenuItem('Wishlist', Icons.favorite_border_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WishlistPage(),
              ),
            );
          }),
          Divider(height: 1),
          _buildMenuItem('Recently Viewed Products', Icons.visibility_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecentlyViewedPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSupportList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem('Contact Us', Icons.headset_mic_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactUsPage()),
            );
          }),
          Divider(height: 1),
          _buildMenuItem('Terms & Conditions', Icons.description_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsPage()),
            );
          }),
          Divider(height: 1),
          _buildMenuItem('Privacy Policy', Icons.privacy_tip_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Implement logout functionality
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Implement actual logout
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade100,
          foregroundColor: Colors.red.shade700,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}