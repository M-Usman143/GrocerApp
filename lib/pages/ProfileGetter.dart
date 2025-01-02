import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _DOBController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child("Profiles");

  void _saveUserInfo() async {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _numberController.text.isNotEmpty &&
        _DOBController.text.isNotEmpty &&
        _genderController.text.isNotEmpty) {
      try {
        await _databaseRef.push().set({
          "name": _nameController.text,
          "email": _emailController.text,
          "number": _numberController.text,
          "dob": _DOBController.text,
          "gender": _genderController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile saved successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        _nameController.clear();
        _emailController.clear();
        _numberController.clear();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving profile: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Input
            TextField(
              controller: _nameController,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Email Input
            TextField(
              controller: _emailController,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Number Input
            TextField(
              controller: _numberController,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Number Input
            TextField(
              controller: _DOBController,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: "DOB",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Number Input
            TextField(
              controller: _genderController,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: "Gender",
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(height: 40),

            // Submit Button
            Center(
              child: Container(
                width: 400,
                child: ElevatedButton(
                  onPressed: _saveUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Removed border corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: Text("Submit",
                  style: TextStyle(color: Colors.white),
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
