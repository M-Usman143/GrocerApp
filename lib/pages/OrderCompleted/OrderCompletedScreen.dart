import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import '../../theme/app_theme.dart';

class OrderCompletedScreen extends StatefulWidget {
  final String orderNumber;
  final double totalAmount;
  final String deliveryDate;
  final String deliveryTime;

  const OrderCompletedScreen({
    Key? key, 
    this.orderNumber = "GR-2023-45678",
    this.totalAmount = 52.55,
    this.deliveryDate = "Tomorrow",
    this.deliveryTime = "02:00 - 05:00 PM",
  }) : super(key: key);

  @override
  _OrderCompletedScreenState createState() => _OrderCompletedScreenState();
}

class _OrderCompletedScreenState extends State<OrderCompletedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showOrderDetails = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    
    _animationController.forward();
    
    // Show order details after animation completes
    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        _showOrderDetails = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text('Order Completed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    _buildSuccessAnimation(),
                    SizedBox(height: 20),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Text(
                        'Order Placed Successfully!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedOpacity(
                      opacity: _showOrderDetails ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Your order has been placed successfully. You will receive a confirmation email shortly.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    if (_showOrderDetails) _buildOrderDetailsCard(),
                    if (_showOrderDetails) SizedBox(height: 20),
                    if (_showOrderDetails) _buildDeliveryInfo(),
                    if (_showOrderDetails) SizedBox(height: 20),
                    if (_showOrderDetails) _buildTrackingCard(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Lottie.network(
        'https://assets10.lottiefiles.com/packages/lf20_poqmycwy.json',
        repeat: false,
        controller: _animationController,
        onLoaded: (composition) {
          _animationController
            ..duration = composition.duration
            ..forward();
        },
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderDetailRow('Order Number', widget.orderNumber),
            Divider(height: 24),
            _buildOrderDetailRow('Total Amount', '\$${widget.totalAmount.toStringAsFixed(2)}'),
            Divider(height: 24),
            _buildOrderDetailRow('Payment Method', 'Cash on Delivery'),
            Divider(height: 24),
            _buildOrderDetailRow('Delivery Date', '${widget.deliveryDate}, ${widget.deliveryTime}'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Delivery Date',
            value: widget.deliveryDate,
          ),
          SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.access_time_outlined,
            title: 'Delivery Time',
            value: widget.deliveryTime,
          ),
          SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            title: 'Delivery Address',
            value: '123 Main Street, Apt 4B, New York, NY 10001',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.green,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingStatus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildStatusCircle(isActive: true, isCompleted: true),
              _buildStatusLine(isActive: true),
              _buildStatusCircle(isActive: true, isCompleted: false),
              _buildStatusLine(isActive: false),
              _buildStatusCircle(isActive: false, isCompleted: false),
              _buildStatusLine(isActive: false),
              _buildStatusCircle(isActive: false, isCompleted: false),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusText('Order Placed', 'March 24, 2025 | 11:30 AM', true),
                SizedBox(height: 24),
                _buildStatusText('Processing', 'Your order is being processed', true),
                SizedBox(height: 24),
                _buildStatusText('Shipped', 'Your order will be shipped soon', false),
                SizedBox(height: 24),
                _buildStatusText('Delivered', 'Estimated delivery: ${widget.deliveryDate}', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCircle({required bool isActive, required bool isCompleted}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? (isCompleted ? Colors.green : Colors.white) : Colors.grey[300],
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey,
          width: 2,
        ),
      ),
      child: isCompleted
          ? Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  Widget _buildStatusLine({required bool isActive}) {
    return Container(
      width: 2,
      height: 30,
      color: isActive ? Colors.green : Colors.grey[300],
    );
  }

  Widget _buildStatusText(String title, String subtitle, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: isActive ? Colors.grey[700] : Colors.grey,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTrackingCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Track Your Order',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          _buildTrackingStatus(),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Navigate to order tracking screen
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'TRACK ORDER',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to home or shop
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'SHOP MORE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 