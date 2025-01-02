import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  Future<void> requestOTP(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print("The provided phone number is invalid.");
          } else {
            print("Phone number verification failed: ${e.message}");
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          print("Code sent to $phoneNumber. Verification ID: $verificationId");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print("Code auto-retrieval timeout. Verification ID: $verificationId");
        },
      );
    } catch (e) {
      print("Error during phone number authentication: $e");
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        throw Exception("Verification ID is null. Request an OTP first.");
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _signInWithCredential(credential);
    } catch (e) {
      print("Error during OTP verification: $e");
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      // Authenticate and sign in the user
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print("User signed in successfully. Phone number: ${user.phoneNumber}");
      } else {
        print("User sign-in failed.");
      }
    } catch (e) {
      print("Error during sign-in with credential: $e");
    }
  }

  // Optional: Sign out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }

  // Optional: Check if a user is signed in
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
