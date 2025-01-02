import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:GrocerApp/pages/OtpScreen.dart';

import '../Common/SharedPreferenceHelper.dart';
import '../FirebaseHelper/FirebaseServiceAuth.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _phoneController = TextEditingController();
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isPhoneNumberValid = false;

  void _onPhoneNumberChanged() {
    String phoneNumber = _phoneController.text.trim();
    setState(() {
      // Ensure the phone number is valid when it has 9 digits
      _isPhoneNumberValid = RegExp(r'^[3][0-9]{9}$').hasMatch(phoneNumber);
    });
  }

  void _handleLoginSignUp() async {
    String phoneNumber = '+92' + _phoneController.text.trim();

    await _authService.requestOTP(phoneNumber);

    await SharedPreferencesHelper.savePhoneNumber(phoneNumber);
    await _databaseRef.push().set({'phone': phoneNumber}).catchError((error) {
      print('Error saving to database: $error');
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpScreen(phoneNumber: phoneNumber),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneNumberChanged); // Listen for input changes
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneNumberChanged); // Remove listener
    _phoneController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Enter your mobile number',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your number to create an account or login',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  width: 60,
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: '+92',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      hintText: '3',

                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      counterText: '', // Hide character counter
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPhoneNumberValid ? _handleLoginSignUp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPhoneNumberValid
                      ? Colors.orange
                      : Color(0xFFFAD7C5), // Change color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Login/Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
