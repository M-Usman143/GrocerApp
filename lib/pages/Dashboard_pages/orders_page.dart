import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(OrderStatus.active),
          _buildOrderList(OrderStatus.completed),
          _buildOrderList(OrderStatus.cancelled),
        ],
      ),
    );
  }
  
  Widget _buildOrderList(OrderStatus status) {
    // Get orders based on status
    final orders = _getOrders(status);
    
    if (orders.isEmpty) {
      return _buildEmptyState(status);
    }
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }
  
  Widget _buildOrderCard(Order order) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
          ),
          Divider(height: 1),
          
          // Order items
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Items (${order.items.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                ...order.items.map((item) => _buildOrderItem(item)).toList(),
              ],
            ),
          ),
          
          Divider(height: 1),
          
          // Order details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildOrderDetail('Order Date', order.date),
                SizedBox(height: 8),
                _buildOrderDetail('Delivery Address', order.address),
                SizedBox(height: 8),
                _buildOrderDetail('Payment Method', order.paymentMethod),
                SizedBox(height: 8),
                _buildOrderDetail('Total Amount', order.totalAmount),
              ],
            ),
          ),
          
          // Actions
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showOrderDetails(order),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('View Details'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: order.status == OrderStatus.active ? () => _trackOrder(order) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(order.status == OrderStatus.active ? 'Track Order' : 'Reorder'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(Icons.shopping_bag_outlined, color: Colors.grey),
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
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${item.quantity} x ${item.price}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${(double.parse(item.price.substring(1)) * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusBadge(OrderStatus status) {
    Color badgeColor;
    String statusText;
    
    switch (status) {
      case OrderStatus.active:
        badgeColor = Colors.blue;
        statusText = 'In Progress';
        break;
      case OrderStatus.completed:
        badgeColor = Colors.green;
        statusText = 'Delivered';
        break;
      case OrderStatus.cancelled:
        badgeColor = Colors.red;
        statusText = 'Cancelled';
        break;
      default:
        badgeColor = Colors.grey;
        statusText = 'Unknown';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildEmptyState(OrderStatus status) {
    String message;
    IconData icon;
    
    switch (status) {
      case OrderStatus.active:
        message = 'You have no active orders';
        icon = Icons.shopping_cart_outlined;
        break;
      case OrderStatus.completed:
        message = 'You have no completed orders';
        icon = Icons.check_circle_outline;
        break;
      case OrderStatus.cancelled:
        message = 'You have no cancelled orders';
        icon = Icons.cancel_outlined;
        break;
      default:
        message = 'No orders found';
        icon = Icons.shopping_bag_outlined;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to HomePage for shopping
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
  
  void _showOrderDetails(Order order) {
    // Navigate to order details page
  }
  
  void _trackOrder(Order order) {
    // Show tracking information
  }
  
  List<Order> _getOrders(OrderStatus status) {
    // Dummy orders data
    if (status == OrderStatus.active) {
      return [
        Order(
          id: '12345',
          date: '21 Mar 2023',
          status: OrderStatus.active,
          address: '123 Main St, Apt 4B, City, State, 12345',
          paymentMethod: 'Credit Card',
          totalAmount: '₹567.00',
          items: [
            OrderItem(name: 'Fresh Apples', quantity: 2, price: '₹149.00'),
            OrderItem(name: 'Organic Milk', quantity: 1, price: '₹59.00'),
            OrderItem(name: 'Whole Wheat Bread', quantity: 1, price: '₹40.00'),
          ],
        ),
      ];
    } else if (status == OrderStatus.completed) {
      return [
        Order(
          id: '12344',
          date: '18 Mar 2023',
          status: OrderStatus.completed,
          address: '123 Main St, Apt 4B, City, State, 12345',
          paymentMethod: 'Credit Card',
          totalAmount: '₹432.00',
          items: [
            OrderItem(name: 'Yogurt Pack', quantity: 2, price: '₹80.00'),
            OrderItem(name: 'Bananas', quantity: 1, price: '₹40.00'),
            OrderItem(name: 'Eggs (12 pcs)', quantity: 1, price: '₹95.00'),
          ],
        ),
        Order(
          id: '12343',
          date: '10 Mar 2023',
          status: OrderStatus.completed,
          address: '123 Main St, Apt 4B, City, State, 12345',
          paymentMethod: 'Credit Card',
          totalAmount: '₹355.00',
          items: [
            OrderItem(name: 'Chicken Breast', quantity: 1, price: '₹180.00'),
            OrderItem(name: 'Mixed Vegetables', quantity: 1, price: '₹75.00'),
            OrderItem(name: 'Rice (1kg)', quantity: 1, price: '₹100.00'),
          ],
        ),
      ];
    } else {
      return [
        Order(
          id: '12340',
          date: '05 Mar 2023',
          status: OrderStatus.cancelled,
          address: '123 Main St, Apt 4B, City, State, 12345',
          paymentMethod: 'Credit Card',
          totalAmount: '₹290.00',
          items: [
            OrderItem(name: 'Premium Coffee', quantity: 1, price: '₹180.00'),
            OrderItem(name: 'Cookies', quantity: 2, price: '₹55.00'),
          ],
        ),
      ];
    }
  }
}

enum OrderStatus { active, completed, cancelled }

class Order {
  final String id;
  final String date;
  final OrderStatus status;
  final String address;
  final String paymentMethod;
  final String totalAmount;
  final List<OrderItem> items;
  
  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.address,
    required this.paymentMethod,
    required this.totalAmount,
    required this.items,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final String price;
  
  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}