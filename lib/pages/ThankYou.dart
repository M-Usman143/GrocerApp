import 'package:flutter/material.dart';
import '../Common/SetupProgressWidget.dart';

class ThankYouScreen extends StatelessWidget {
  final String transactionId;
  final String productName;
  final double amount;

  ThankYouScreen({
    required this.transactionId,
    required this.productName,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You!' ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StepProgressWidget(currentStep: 3),
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 16.0),
            Text(
              'Thank you for your purchase!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Your order has been successfully placed.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 24.0),
            // Display transaction details
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction ID: $transactionId',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Product: $productName',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Amount: \$${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
            // Buttons for further actions
            ElevatedButton(
              onPressed: () {
                // Navigate to Home screen (or another screen)
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Continue Shopping'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to Order Details screen (you can replace with your order details page)
                Navigator.pushReplacementNamed(context, '/orderDetails');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('View Order Details'),
            ),
          ],
        ),
      ),
    );
  }
}
