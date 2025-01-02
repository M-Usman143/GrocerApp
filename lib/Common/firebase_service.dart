import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Function to send OTP to the user's phone number
  Future<void> sendOtp(String phoneNumber, BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-signed in, store phone number and navigate
          await _auth.signInWithCredential(credential);
          _storePhoneNumber(phoneNumber);
        },
        verificationFailed: (FirebaseAuthException e) {
          _showErrorDialog(context, 'Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Code sent, show OTP dialog
          _showOtpDialog(verificationId, context);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _showErrorDialog(context, 'Error sending OTP: $e');
    }
  }

  // Function to store the phone number in Firebase Realtime Database
  Future<void> _storePhoneNumber(String phoneNumber) async {
    DatabaseReference ref = _database.ref().child('users').push();
    await ref.set({
      'phone': phoneNumber,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).then((_) {
      print('Phone number stored successfully');
    }).catchError((error) {
      print('Error storing phone number: $error');
    });
  }

  // Show OTP dialog to enter the code
  void _showOtpDialog(String verificationId, BuildContext context) {
    TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'OTP'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String otp = otpController.text.trim();
                if (otp.isNotEmpty) {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otp,
                  );
                  await _signInWithCredential(credential, context);
                }
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  // Sign in the user with the provided OTP
  Future<void> _signInWithCredential(PhoneAuthCredential credential, BuildContext context) async {
    try {
      await _auth.signInWithCredential(credential);
      _storePhoneNumber(_auth.currentUser!.phoneNumber!);
      Navigator.pop(context);  // Close the OTP dialog
    } catch (e) {
      _showErrorDialog(context, 'OTP verification failed: $e');
    }
  }

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
