import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Common/SetupProgressWidget.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {},
        ),
        title: Text('Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: StepProgressWidget(currentStep: 2),
            ),
            Divider(height: 1, color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Option', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Radio(
                      value: true,
                      groupValue: true,
                      onChanged: (value) {},
                      activeColor: Colors.orange,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scheduled Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          'Earliest slot 02:00 - 05:00 PM Tomorrow',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 4),
                        Text('FREE Delivery on shopping of Rs 2999',
                            style: TextStyle(fontSize: 12, color: Colors.green)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDeliveryDayAndWindow(),
                  SizedBox(height: 16),
                  Text('Delivery Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(37.422, -122.084),
                            zoom: 15,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Please add detail address like house #',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Icon(Icons.money, color: Colors.black),
                    title: Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SIGN IN TO PLACE ORDER', style: TextStyle(color: Colors.white)),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(String title, bool isActive) {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          color: isActive ? Colors.green : Colors.grey,
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryDayAndWindow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Day', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text('Tomorrow', style: TextStyle(color: Colors.orange)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Window', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text('02:00 - 05:00 PM', style: TextStyle(color: Colors.orange)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
