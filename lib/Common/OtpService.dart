import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OtpService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Generate OTP
  String generateOtp() {
    Random rand = Random();
    String otp = (rand.nextInt(999999 - 100000 + 1) + 100000).toString();
    return otp;
  }

  // Store OTP in Firebase Realtime Database
  Future<void> storeOtpInRealtimeDatabase(String otp, String userId) async {
    try {
      DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('otps').child(userId);
      await ref.set({
        'otp': otp,
        'timestamp': ServerValue.timestamp,
      });
      print("OTP stored in Realtime Database");
    } catch (e) {
      print("Error storing OTP in Realtime Database: $e");
    }
  }

  // Show OTP notification
  Future<void> showOtpNotification(String otp) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'otp_channel', // Channel ID
      'OTP Notifications', // Channel Name
      channelDescription: 'Shows OTP notifications', // Description
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'OTP',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      0, // Notification ID
      'Your OTP Code', // Notification Title
      'Your OTP is $otp', // Notification Body
      platformChannelSpecifics,
    );
  }

  // Verify OTP from Realtime Database
  Future<bool> verifyOtp(String otp, String userId) async {
    try {
      DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('otps').child(userId);
      DataSnapshot snapshot = (await ref.once()) as DataSnapshot;
      if (snapshot.exists) {
        Map<String, dynamic> otpData = snapshot.value as Map<String, dynamic>;
        if (otpData['otp'] == otp) {
          return true; // OTP is valid
        } else {
          return false; // OTP is invalid
        }
      } else {
        return false; // OTP not found in the database
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }
}
