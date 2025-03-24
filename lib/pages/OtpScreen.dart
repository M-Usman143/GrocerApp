import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:GrocerApp/pages/LocationScreen.dart';
import '../Common/OtpService.dart';
import 'Dashboard/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../theme/app_theme.dart';
import 'ProfileGetter.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  OtpScreen({required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late String _generatedOtp;
  late OtpService _otpService;

  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final FocusNode _focusNode = FocusNode();
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<bool> _isFieldFilled = List.generate(6, (index) => false);
  String? _verificationId;
  late int _start;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _otpService = OtpService();
    _otpService.initializeNotifications();
    _generatedOtp = _otpService.generateOtp();
    _otpService.storeOtpInRealtimeDatabase(_generatedOtp, widget.phoneNumber); // Store OTP in Firebase
    _otpService.showOtpNotification(_generatedOtp);
    startTimer();
    _sendOtp();
  }

  // Send OTP using Firebase Authentication
  void _sendOtp() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Verification failed. Please try again."),
          backgroundColor: Colors.red,
        ));
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("OTP has been sent to your phone."),
          backgroundColor: Colors.green,
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  // Start countdown timer for OTP
  void startTimer() {
    _start = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(FocusNode()); // Move to next focus
    }
  }

  Future<void> verifyOtp(String enteredOtp, String phoneNumber, BuildContext context) async {
    try {
      DatabaseEvent event = await FirebaseDatabase.instance
          .ref()
          .child("otps")
          .child(phoneNumber)
          .once();

      if (event.snapshot.exists && event.snapshot.value != null) {
        Map<dynamic, dynamic> otpData = event.snapshot.value as Map<dynamic, dynamic>;

        String storedOtp = otpData['otp'];
        int timestamp = otpData['timestamp'];
        if (DateTime.now().millisecondsSinceEpoch - timestamp > 5 * 60 * 1000) {
          // OTP has expired
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("OTP has expired. Please request a new one."),
            backgroundColor: Colors.red,
          ));
        } else if (enteredOtp == storedOtp) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Invalid OTP. Please try again."),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("OTP not found. Please try again."),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Close the keyboard when tapping outside the input fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    'Verify your mobile number',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter the pin you have received on ${widget.phoneNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _isFieldFilled[index]
                                  ? Colors.black
                                  : Colors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => _onOtpChanged(value, index),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '00:${_start.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                      onPressed: () async {
                        String enteredOtp = _controllers
                            .map((controller) => controller.text)
                            .join();
                        await verifyOtp(enteredOtp, widget.phoneNumber, context);
                      },
                      child:
                      Text('Verify', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Didn't receive SMS?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please verify your mobile phone number by sending 'MNP' in an SMS to 99095, and then re-try SMS verification",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
