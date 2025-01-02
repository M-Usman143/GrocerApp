import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:GrocerApp/pages/sign_up.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("Profiles");
  Map<String, dynamic>? _userData;
  String? _userId;

  Future<void> _fetchUserProfile() async {
    try {
      final snapshot = await _databaseRef.once();
      if (snapshot.snapshot.exists) {
        final Map<dynamic, dynamic> profiles = snapshot.snapshot.value as Map<dynamic, dynamic>;
        final String userId = profiles.keys.first; // Assume the first user ID for demonstration
        final userProfile = profiles[userId];

        setState(() {
          _userData = Map<String, dynamic>.from(userProfile);
          _userId = userId;
        });
      }
    } catch (error) {
      print("Error fetching user profile: $error");
    }
  }

  Future<void> _deleteAccount() async {
    if (_userId != null) {
      try {
        await _databaseRef.child(_userId!).remove();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      } catch (error) {
        print("Error deleting account: $error");
      }
    }
  }

  void _editProfile() {
    if (_userData != null && _userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfileScreen(userId: _userId!, userData: _userData!),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _editProfile,
            child: const Text(
              'EDIT',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
      body: _userData == null
          ? const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileDetail('Name', _userData?['name']),
          _buildProfileDetail('Email (optional)', _userData?['email']),
          _buildProfileDetail('Mobile Number', _userData?['number']),
          _buildProfileDetail('Date of Birth', _userData?['dob']),
          _buildProfileDetail('Gender', _userData?['gender']),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                const Icon(Icons.delete, color: Colors.red),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _deleteAccount,
                  child: const Text(
                    'Delete my account',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildProfileDetail(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        const Divider(color: Colors.orange, thickness: 1),
      ],
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;

  EditProfileScreen({required this.userId, required this.userData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: userData['name']);
    final TextEditingController emailController = TextEditingController(text: userData['email']);
    final TextEditingController numberController = TextEditingController(text: userData['number']);
    final TextEditingController dobController = TextEditingController(text: userData['dob']);
    final TextEditingController genderController = TextEditingController(text: userData['gender']);

    final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("Profiles");

    Future<void> _updateProfile() async {
      try {
        await _databaseRef.child(userId).update({
          'name': nameController.text,
          'email': emailController.text,
          'number': numberController.text,
          'dob': dobController.text,
          'gender': genderController.text,
        });
        Navigator.pop(context);
      } catch (error) {
        print("Error updating profile: $error");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Name', nameController),
            _buildTextField('Email', emailController),
            _buildTextField('Mobile Number', numberController),
            _buildTextField('Date of Birth', dobController),
            _buildTextField('Gender', genderController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
