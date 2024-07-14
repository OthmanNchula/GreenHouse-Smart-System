import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel user;

  const UserDetailPage({super.key, required this.user});

  @override
  UserDetailPageState createState() => UserDetailPageState();
}

class UserDetailPageState extends State<UserDetailPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    _phoneNumberController.text = widget.user.phonenumber;
  }

  Future<void> _updateUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.user.id).update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'phonenumber': _phoneNumberController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User details updated successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $e')),
      );
    }
  }

  Future<void> _deleteUser() async {
    try {
      if (kDebugMode) {
        print('Deleting user with ID: ${widget.user.id}');
      }

      // delete the user from Firebase Authentication
      await FirebaseFirestore.instance.collection('users').doc(widget.user.id).delete();

      // delete the user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      await user?.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete user: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Save Changes'),
            ),
            ElevatedButton(
              onPressed: _deleteUser,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete User'),
            ),
          ],
        ),
      ),
    );
  }
}
