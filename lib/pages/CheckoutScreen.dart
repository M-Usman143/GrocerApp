import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../theme/app_theme.dart';
import '../Common/SetupProgressWidget.dart';
import 'dart:async';
import 'OrderCompleted/OrderCompletedScreen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  int _paymentMethod = 0; // 0: Cash on Delivery, 1: Credit Card, 2: Online Payment
  String _selectedDay = 'Tomorrow';
  String _selectedTime = '02:00 - 05:00 PM';
  Set<Marker> _markers = {};
  
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.422, -122.084),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    // Add a marker at initial position
    _markers.add(
      Marker(
        markerId: MarkerId('delivery_location'),
        position: LatLng(37.422, -122.084),
        infoWindow: InfoWindow(title: 'Delivery Location'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Checkout'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: StepProgressWidget(currentStep: 2),
            ),
            _buildSectionCard(
              title: 'Delivery Options',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDeliveryOptionTile(),
                  SizedBox(height: 16),
                  _buildDeliveryDayAndWindow(),
                ],
              ),
            ),
            _buildSectionCard(
              title: 'Delivery Location',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMapView(),
                  SizedBox(height: 16),
                  _buildAddressFields(),
                ],
              ),
            ),
            _buildSectionCard(
              title: 'Payment Method',
              child: Column(
                children: [
                  _buildPaymentMethodTile(
                    index: 0,
                    icon: Icons.money,
                    title: 'Cash on Delivery',
                    subtitle: 'Pay when your order is delivered',
                  ),
                  Divider(height: 1),
                  _buildPaymentMethodTile(
                    index: 1,
                    icon: Icons.credit_card,
                    title: 'Credit Card',
                    subtitle: 'Pay using your credit or debit card',
                  ),
                  Divider(height: 1),
                  _buildPaymentMethodTile(
                    index: 2,
                    icon: Icons.account_balance_wallet,
                    title: 'Online Payment',
                    subtitle: 'Pay using your preferred online payment method',
                  ),
                ],
              ),
            ),
            _buildSectionCard(
              title: 'Order Summary',
              child: Column(
                children: [
                  _buildOrderSummaryItem('Subtotal', '\$45.97'),
                  _buildOrderSummaryItem('Delivery Fee', '\$2.99'),
                  _buildOrderSummaryItem('Tax', '\$3.59'),
                  Divider(),
                  _buildOrderSummaryItem('Total', '\$52.55', isTotal: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle place order and navigate to order completed screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderCompletedScreen(
                        orderNumber: 'GR-${DateTime.now().year}-${1000 + DateTime.now().millisecond}',
                        totalAmount: 52.55,
                        deliveryDate: _selectedDay,
                        deliveryTime: _selectedTime,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'PLACE ORDER',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptionTile() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.green.withOpacity(0.05),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio(
              value: true,
              groupValue: true,
              onChanged: (value) {},
              activeColor: Colors.green,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scheduled Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Earliest slot: $_selectedTime',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Date: $_selectedDay',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_shipping, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'FREE Delivery on orders over \$29.99',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
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

  Widget _buildDeliveryDayAndWindow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Day',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              _buildDropdownButton(_selectedDay, ['Today', 'Tomorrow', 'Day After Tomorrow'], (value) {
                setState(() {
                  _selectedDay = value!;
                });
              }),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Window',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              _buildDropdownButton(_selectedTime, ['09:00 - 12:00 PM', '12:00 - 03:00 PM', '02:00 - 05:00 PM', '05:00 - 08:00 PM'], (value) {
                setState(() {
                  _selectedTime = value!;
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownButton<T>(T value, List<T> items, Function(T?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(item.toString()),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Colors.green),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  // Handle map location edit
                },
                backgroundColor: Colors.white,
                child: Icon(Icons.edit_location_alt, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Full Address',
            hintText: 'e.g., 123 Main St, Apt 4B',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.home, color: Colors.green),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Zip Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Additional Instructions',
            hintText: 'e.g., Ring doorbell, leave at front door',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            prefixIcon: Icon(Icons.note, color: Colors.green),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return RadioListTile(
      value: index,
      groupValue: _paymentMethod,
      onChanged: (value) {
        setState(() {
          _paymentMethod = value as int;
        });
      },
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      secondary: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.green,
          size: 24,
        ),
      ),
      activeColor: Colors.green,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildOrderSummaryItem(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
